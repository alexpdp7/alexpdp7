# About relational databases

## What is a relation?

A common misconception is that the "relations" in a relational database are about relations between database tables.

Actually, the relations in a relational database are the tables.

A relation "relates" a set of values with another set of values.

For example, a relation can relate the name of a person with their birth date and birth place.
For example:

```
(person name) => (birth date, birth place)
(Alice) => (1979-12-03, Barcelona)
(Bob) => (1995-03-04, Paris)
...
```

Many computer languages have similar concepts:

* [Python mapping types such as `dict`](https://docs.python.org/3/library/stdtypes.html#mapping-types-dict)
* C++ `std::map`
* Java `java.util.Map`
* [C# `System.Collections.Generic.Dictionary`](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0)
* [Javascript `Object`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)
* [PHP arrays](https://www.php.net/manual/en/language.types.array.php)

Relations are a natural concept, so although non-relational data systems exist, most data can be stored as relations.
