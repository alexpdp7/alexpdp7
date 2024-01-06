# About APIs

The [Jeff Bezos' API memo](https://gist.github.com/kislayverma/d48b84db1ac5d737715e8319bd4dd368) is one of the most talked stories about API programming.

It is, in my opinion, also one of those things which are successful for some environments, but not for all.

## The levels of API accessibility

An "operation" in your application can be in one of the following levels of "API accessibility":

* -oo The operation cannot be invoked in isolation easily.
For instance, it is embedded in an MVC controller, mixed with form handling and HTML generation, and thus the best approach to invoke it programatically is to simulate a browser
* 0 The operation can be invoked, in-process, by calling a function or method, but requiring complex setup or using complex types (e.g. others than lists, maps, numbers and strings)
* 1 The operation can be invoked, in-process, by calling a function without complex setup and using plain types
* 2 The operation can be invoked, off-process, by calling a function without complex setup and using plain types
* 3 The operation can be invoked via a command line tool
* 4 The operation can be invoked via a network call

Many proponents of APIs propose level 4 as the target.
This obviously allows your operations to be integrated in separate processes via network calls, which is the most powerful way of API access.
They will also reason that this will force your application to have a clean architecture with separation of concerns.

Note also that doing proper testing will probably force your operations to be tested to be in levels 0-2, as otherwise it will be annoyingly complex to test them.

We propose that the architecture benefits of level 4 are also present in levels 0-3, but achieving these levels requires much less effort than achieving level 4 (where you need to add a network protocol, handle aspects such as authentication/authorization, marshalling/unmarshalling, etc.), so unless you require level 4, you can stay in levels 0-3.
Going to level 3 instead of 0 should be easy when creating new operations, so that's the level of API accessibility we recommend new code to adhere to by default.

Note also that level 3 can provide many benefits of level 4, but with less development overhead, so it's a level we recommend considering explicitly, as it is often overlooked.

Level -oo is typical of legacy applications.
Note that we consider the distance between level -oo and the rest of levels much bigger than the distance between the rest of levels.
