# Showing the similarities between SQL and Prolog

SQL is a very common programming language, which sometimes is compared to the relatively more obscure Prolog language.
Both are examples of declarative languages, where you define some facts, then you can ask questions about those facts, and the system answers the questions without you writing an explicit program.

However, I could not find a good example of their similarities.
This text presents the most typical Prolog example, and translates it to SQL.

## A typical Prolog example

`[x]` reads Prolog facts from file `x`.
We can use the special file `user` to read facts from the REPL, ending the facts with ctrl+d:


```
$ swipl
?- [user].
|: father(jim, julian).
|: father(julian, joe).
|: father(julian, jerome).
|: father(pete, perry).
|: ^D
true.
```

You should read `father(X,Y)` as "`X` is the father of `Y`".
So Jim is the father of Julian, and so on.

We can ask Prolog questions:

```
?- father(julian, jim).
false.
```

Is Julian the father of Jim? There is no known fact about this, so no.
But Julian *is* the father of Joe:

```
?- father(julian, joe).
true.
```

More interestingly, you can ask who are Julian's children:

```
?- father(julian, X).
X = joe ;
X = jerome.
```

(You press `;` to get further answers.)

## A simple translation to SQL

You can do pretty much the same with SQL, first define the facts as values in tables:

```
$ sqlite3
sqlite> create table fatherhood(father, son);
sqlite> insert into fatherhood values ('jim', 'julian');
sqlite> insert into fatherhood values ('julian', 'joe');
sqlite> insert into fatherhood values ('julian', 'jerome');
sqlite> insert into fatherhood values ('pete', 'perry');
```

Then you can get the same answers:

```
sqlite> select * from fatherhood where father = 'julian' and son = 'jim';
sqlite> select * from fatherhood where father = 'julian' and son = 'joe';
julian|joe
sqlite> select * from fatherhood where father = 'julian';
julian|joe
julian|jerome
```

## The next step in Prolog

The typical example continues with some logic:

```
?- [user].
|: grandfather(X,Y) :- father(X, Z), father(Z, Y).
|: ^D
true.
```

`X` is the grandfather of `Y` if `X` is the father of `Z`, and `Z` is the father of `Y`.
Then you can ask questions, and Prolog knows the answers:

```
?- grandfather(jim, X).
X = joe ;
X = jerome.

?- grandfather(X, jerome).
X = jim ;
false.
```

## Can we do the same in SQL?

You might not guess the answer on the first try, but the answer is not complex: you can do the same thing with SQL views:

```
sqlite> create view grandfatherhood as
   ...>   select fatherhood_1.father as grandfather, fatherhood_2.son as nephew
   ...>   from fatherhood as fatherhood_1 join fatherhood as fatherhood_2 on (fatherhood_1.son = fatherhood_2.father);
```

And if you ask the same questions, SQLite gives the same answers:

```
sqlite> select * from grandfatherhood where grandfather = 'jim';
jim|jerome
jim|joe
sqlite> select * from grandfatherhood where nephew = 'jerome';
jim|jerome
```
