---
authors:
- hypertesto
categories:
- guida
cover: /images/create_table.jpg
date: "2018-07-09T20:50:00.000+00:00"
tags:
- sql
- oracle
title: CREATE TABLE IF NOT EXISTS su database Oracle
---
Il problema di oggi era apparentemente semplice: create una tabella se non era già presente nel DB.
Erroneamente davo per scontato che la sintassi MySQL, con i dovuti adattamenti per Oracle, funzionasse:

```sql
CREATE TABLE IF NOT EXISTS nome_tabella
    (definizione colonne,...)
    [opzioni tabella]
    [opzioni partizione]
```

Ho cercato un po' sulla documentazione ufficiale ma senza grossi risultati, per cui mi sono fatto andar bene una [risposta su stackoverflow](https://stackoverflow.com/a/15437080):

> Normally, it doesn't make a lot of sense to check whether a table exists or not because objects shouldn't be created at runtime and the application should know what objects were created at install time. If this is part of the installation, you should know what objects exist at any point in the process so you shouldn't need to check whether a table already exists.

Opinabile ma sicuramente sensato. Dal momento che non sembro essere stato l'unico a necessitare di questa funzione, uno *zuccherino sintattico* non avrebbe di certo fatto male.

Nella stessa risposta ci sono anche tre utili spunti su come aggirare il problema:

> If you really need to, however,  

> * You can attempt to create the table and catch the `ORA-00955: name is already used by an existing object` exception.
> * You can query USER_TABLES (or ALL_TABLES or DBA_TABLES depending on whether you are creating objects owned by other users and your privileges in the database) to check to see whether the table already exists.
> * You can try to drop the table before creating it and catch the `ORA-00942: table or view does not exist` exception if it doesn't.
>

Ritengo la prima soluzione concettualmente più giusta poiché analogo al try-catch in programmazione (ovviamente ignoro se con Oracle ci siano casi limite o altri grattacapi).

Questa è la soluzione che ho adottato:

```sql
declare
begin
  execute immediate 'create table "TABELLA" ("ID" number not null)';
  exception when others then
    if SQLCODE = -955 then null; else raise; end if;
end;
```

Sul sito ufficiale trovate [l'elenco dei codici](https://docs.oracle.com/cd/B28359_01/server.111/b28278/toc.htm) di errore che vi è possibile catturare.
