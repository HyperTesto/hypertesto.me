---
title: "JAVA ed i numeri positivi casuali"
date: 2017-11-26T23:44:42+01:00
draft: false
categories:
  - appunti
tags:
  - java
  - bug
---

Oggi stavo revisionando del codice JAVA che conteneva una funzione per generare dei Long casuali positivi scritta come segue:

```java
public Long randomPositiveLong() {
    return Math.abs(new Random().nextLong());
}
```
Riuscite a vedere il BUG nascosto tra le righe?

Il problema di questa funzione si verifica esattamente quando si cerca di rendere positito il valore `Long.MIN_VALUE`. Perchè?

Se prendiamo la [documentazione ufficale](https://docs.oracle.com/javase/7/docs/api/java/lang/Long.html) ed andiamo a vedere quali sono i valori che è possibile rappresentare troveremo che `Long.MIN_VALUE` è uguale a 2<sup>-63</sup>, mentre `Long.MAX_VALUE` è uguale a 2<sup>63</sup>-1 (questo perchè tra i numeri positivi c'è anche lo zero). Ciò significa che `Long.MIN_VALUE` non ha una controparte positiva; nella pratica quel che succede è che `Math.abs` ritornerà nuovamente il numero come negativo. Questo è anche indicato nella relativa [JavaDoc](https://docs.oracle.com/javase/7/docs/api/java/lang/Math.html#abs(long)):

> Note that if the argument is equal to the value of Long.MIN_VALUE, the most negative representable long value, the result is that same value, which is negative.

Ci sono più modi per riscrivere la funzione, io ho preferito non reiventare la ruota e ho sfruttato la funzione `nextLong(long n)` che ritorna un Long tra 0 (incluso) ed n (escluso). Questa funzione si trova in una classe un po' meno conosciuta: `ThreadLocalRandom`, che è anche pensata per essere usata in ambienti concorrenti. Bene! Due piccioni con una fava!

La funzione riscritta è la seguente

```java
public Long randomPositiveLong() {
    return ThreadLocalRandom.current().nextLong(Long.MAX_VALUE);
}
```

Come al solito i BUG peggiori si annidano sempre in aree del codice innocue all'apparenza!

