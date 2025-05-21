# CRUD is an important unsolved problem

The CRUD (initials of create, replace, update, and delete) term is used to describe the implementation of applications that provide a simple interface to a database.

If you have used a computer for work, then you likely have used a system that allows to manipulate records of customers, orders, products, or any other information related to the business.

Although programmers have been written a huge amount of CRUD systems for decades, my perception is that the costs of implementing CRUD systems is a major problem with important consequences.

There are two major approaches to implementing CRUD systems:

* Traditional programming: combining a relational database and most existing programming languages enables programmers to create CRUD systems.

* "No code" (or "low code"): many products and services enable non-programmers to describe their data structure and the user interface requiring less technical knowledge than the traditional programming approach.

## About implementing CRUD systems with traditional programming

The Python Django web framework coupled with a relational database requires writing the least code of all the platforms I have used to write CRUD systems.

Most of what you need to do when using Django is to describe what you need, instead of implementing the mechanical parts of a CRUD system.

Out of the box, Django provides:

* List and detail views, including nested views.
  Many systems provide "flat" details view where you can edit a record, but not associated records.
  For example, they provide a detail view for customers where you can edit the customer name and other information, but any "multiple" information, such as multiple addresses or phone numbers, must be edited in a different view.
  This is frequently a huge issue, and it can require writing a significant amount of code in other systems.
  With Django, you can implement this by describing the associated data.

* Multi user authentication and role-based authentication.
  With Django and without programming any code, administrators can create groups, assign users to groups, and limit the kinds of records that each group can view or edit.

* Primitive change tracking.
  Out of the box, changes to records are tracked automatically and can be consulted.

For most CRUD implementations, alternative platforms require significantly more effort to implement those features.

Additionally, the entire stack is open source software that does not require paying licenses.

(Surprisingly, in the past there existed even more sophisticated CRUD platforms.
 But sadly, most have disappeared.)

## About implementing CRUD systems with no code

A huge amount of systems provide similar functionality, in an even more friendly manner.

They typically provide a user interface where you can create tables, add columns, and describe the user interface without programming.

Some of those systems offer features comparable or superior to Django.

However, because those systems focus on no code usage, frequently you hit roadblocks when using them.

When you need a feature that they do not provide, it is either impossible to do it, or it requires programming in an unfriendly environment.

Programming CRUD features can be complex.
While traditional programming tools have evolved providing many features such as automated testing and advanced code revision control systems (rolling back bad changes and others), no code CRUD platforms do not reuse the wealth of programming tools that have been developed for traditional programming.

Non-developers frequently face huge challenges going beyond the basics of what the tool provides, and developers struggle and suffer by working in environments that are more limiting compared to others.

## The consequences of the high cost of development of CRUD systems

In these conditions, most CRUD systems are expensive and do not work well.

Organizations often resort to systems such as spreadsheets that can be productive, but have severe reliability concerns.

No code CRUD systems often have significant costs and lock in their customers, because migrating costs can be astronomical.

CRUD systems implemented with traditional programming often are costly to maintain and extend.

In most cases, organizations cannot justify the costs of tailoring the CRUD system entirely to their needs, so they suffer from using CRUD systems that do not meet their needs.

## Possible approaches

### Improving existing traditional programming CRUD platforms

I believe systems such as Django can still see many improvements.
Likely, both the amount of technical knowledge to use these systems and the amount of effort to design CRUD systems can be reduced significantly.

### Providing systems to transition from no code approaches to traditional programming

No code approaches are wonderful, because giving end users the ability to describe what they need enables them to experiment and become productive very quickly.

However, no code platforms cannot provide all features needed, and in many cases, end users will struggle past a certain point.

Providing a way to migrate to a traditional programming approach would enable breaking this barrier and scaling systems more effectively.

(Some no code platforms have APIs.
 With them, programmers can write code to extend the no code CRUD systems using traditional programming approaches.
 However, implementing functionalities through APIs has limitations and specific problems.)

## Further reading

* [About Django](python/about_django.md).
