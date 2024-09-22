# So you want to play with functional programming

If you are a programmer working on popular languages such as Python or Java, you are likely to have read articles about "functional programming".
These articles can give you the idea that learning functional programming improves your skills as a programmer.
I share this opinion.

This article tries to help people who have read about functional programming figure out how to proceed.

Note that this article expresses personal opinion.
Particularly, I am not an expert in this topic:

* I have programmed some Haskell (about 50 Project Euler problems, plus experimentation on and off during the years).
* I have studies of SML and functional programming.
* I have some minimal experience with Lisp.
* I have applied some functional programming techniques while being paid to write in non-functional programming languages.
* However, I have never been paid to write in any of those languages.

## The basics of functional programming

[The Wikipedia article on functional programming](https://en.wikipedia.org/wiki/Functional_programming) is a great place to get started.

The article describes a few concepts related to functional programming.
I consider the following two the pillars of functional programming:

* First-class and higher order functions.
  In languages with first-class functions, functions are values that you can use like other types such as integers.
  Higher-order functions are functions that take functions as arguments or return functions.

* Pure functions.
  Pure functions always return the same value for a given set of arguments.
  Pure functions also have no side effects; they do not modify anything in the system they run.
  For example, a function that creates a file is not pure.

These concepts can be applied in most popular programming languages.

For example, in Python:

```
def hello():
    print("hello")

def twice(f):
    f()
    f()
```

`twice` is a higher order function because it takes a function as an argument.
Functions are first-class functions because you can use `hello` as a value:

```
>>> twice(hello)
hello
hello
```

Similarly, you can write pure functions in almost any language.

When you have first-class functions, you can define some higher-order functions that generalize some common code.
Three very common higher-order functions are:

* Filter.
  Filter applies a function to each element of a list, and returns a list composed of the elements for which the function returned true.
* Map.
  Map applies a function to each element of a list, and returns a list of the result of the application of the function to each element.
* Fold.
  A fold starts from an initial value, then calls a function with the initial value and the first element of the list.
  Then it calls the function with the result of the previous call, and the next element of the list.
  This continues until the list end, returning the last result of the function.

(For example, folding with the sum operator and an initial value of 0, sums the elements of a list.)

Note that you can implement many list manipulations by composing filters, maps, and folds with different functions.
(And by adding more higher-order functions, you can implement more list manipulations.)

Also, you can manipulate other data structures with equivalent or other higher-order functions.

Implementing code using higher-order functions and pure functions already has some interesting benefits.

* Impure functions frequently require more mental overhead to understand, because you need to understand state.
  With pure functions, you do not have to think about state.

* To understand a program written as a composition of functions, you can start by understanding individual functions and then understand how they fit together.
  The same program written as a sequence of statements is often more difficult to understand.
  (However, sometimes the opposite effect occurs.)

You can use these concepts in most popular programming languages.
(Most popular languages also provide higher-order functions such as filters, maps, and folds.)

So you can get started with functional programming by using the programming languages you already know:

* Try to write as much code as possible as pure functions.
* Learn which higher-order functions your programming language provides.
* Learn how to implement higher-order functions.
* Write code by composing pure functions with higher-order functions.

## The consequences of first-class functions, higher-order functions, and pure functions

Writing code using these concepts often leads to:

* Writing cumbersome code if the programming language you use lacks certain features.
* Unlocking additional functional programming techniques.

Therefore, many programming languages provide features that make functional programming more straightforward, or features enabled by functional programming.
Languages providing features related to functional programming are commonly named "functional programming languages".

Although you can use functional programming with non-functional programming languages, this can often lead to:

* Extra effort
* Not being able to use the full spectrum of functional programming features

### The need for powerful type systems and type inference

Higher-order functions often have complex type requirements.
For example, to filter a list of a given type, you must pass a function that takes a single argument of that type and returns a boolean.
If the arguments do not have the correct types, then the code does not work correctly.

In languages with dynamic types, the program fails at runtime.
In languages with static types, you frequently must specify the types, and higher-order functions often require complex types involving different function types.

Functional programming languages frequently:

* Have static types, to prevent frequent runtime failures.
* Automatically infer types instead of requiring programmers to declare them.
  (However, automatic type inference can cause issues in some scenarios, so frequently programming languages allow writing explicit types, or even require explicit types in some cases.)

Because functional programs often use more complex types, functional programming languages often have more powerful type systems than non-functional programming languages.

Derived from those properties, functional programming languages result in the "if it compiles, it works *correctly*" phenomenon.
This phenomenon helps avoid incorrect programs.

## Functional programming languages

### Haskell

Functional programming practitioners often recommend Haskell as a functional programming language.

[According to the Wikipedia](https://en.wikipedia.org/wiki/Haskell), "Haskell is a general-purpose, statically-typed, purely functional programming language with type inference and lazy evaluation".
Also, Haskell was designed by a committee whose purpose was "to consolidate existing functional languages into a common one to serve as a basis for future research in functional-language design".

* Haskell is perhaps the language with more built-in functional programming features.
As mentioned, Haskell is used for research about functional programming, therefore many new concepts appear in Haskell first.
* Haskell is also very strict about functional programming, so Haskell drives programmers more strongly towards avoiding non-functional programming.
* Haskell syntax is designed so Haskell programs can be extremely terse and contain almost no extraneous syntax.
* Haskell is a very popular language, with a very large ecosystem.
  You can take advantage of many existing libraries and tools for developing real-world programs faster.

However, Haskell's benefits frequently also are negative for learning.

* Haskell uses "lazy" evaluation, where most programming languages use "eager" evaluation.
  Haskell does not evaluate expressions until needed (and might not evaluate some expressions).
  Lazy evaluation can lead to efficiency.
  However, lazy evaluation can cause unexpected performance problems.
  [Foldr Foldl Foldl'](https://wiki.haskell.org/Foldr_Foldl_Foldl%27) explains how choosing incorrectly among different implementations of fold can lead to impactful performance problems.
  When writing Haskell code for learning, you can likely stumble into issues not present in languages that use eager evaluation.

* Haskell is very strict about purity.
  To implement programs that have side effects, such as accessing files, you must use specific language features.
  Many articles try to explain those features, because many people have trouble understanding them.

* Many libraries and tools in the ecosystem take advantage of powerful features enabled by Haskell.
  However, this might cause that using these libraries and tools require the understanding of the features they are based upon.

Also, Haskell syntax is very terse, which leads to Haskell compilers not providing clear error messages.
For example:

```
$ ghci
> let sum a b = a + b
> sum 2 2
4
> sum 2 2 2

<interactive>:3:1: error:
    • Non type-variable argument in the constraint: Num (t1 -> t2)
      (Use FlexibleContexts to permit this)
    • When checking the inferred type
        it :: forall {t1} {t2}. (Num t1, Num (t1 -> t2)) => t2
```

In complex programs, programmers new to Haskell might have trouble identifying that a function has been called with an extra argument from that error message.

Personally, Haskell is my favorite functional programming language.
However, I learned Haskell after learning (with teachers and support from others) other functional programming languages.
I think that Haskell is ideal to learn the most powerful concepts in functional programming, but it is not as ideal as a first functional programming language.

(Note that these recommendations come from someone who only has implemented about 50 Project Euler problems in Haskell, and has experimented on and off with the language, but not been paid for it.)

### Lisp

Many programmers like Lisp and languages in the Lisp family, such as Scheme or Clojure.
Lisp programmers often recommend Lisp to learn functional programming.

Lisp is a very minimalistic, yet infinitely flexible language.
Lisp is extensible, so you can add most programming language features to Lisp, including functional programming features.

Therefore, you can do functional programming in Lisp, and also benefit from all other Lisp features.

However, languages in the Lisp family tend to not have static typing and associated features, thus do not frequently exhibit the "if it compiles, it works *correctly*" phenomenon.

Lisp has one of the simplest syntaxes of any programming language.
The simple syntax of Lisp is directly tied to its power.
Many favor the Lisp syntax and argue that the syntax makes Lisp better for learning programming.
Personally, I find the Lisp syntax hard to read and write, and likely an additional difficulty on top of learning functional programming.

I recommend learning Lisp because it is a unique programming language that can teach you many programming language concepts that are not present in many other languages.
However, I do not recommend Lisp for learning functional programming (unless you already know Lisp).

(Note that these recommendations come from someone who has some formal training on Lisp but only uses Lisp infrequently [as a recent Emacs user].)

### The ML family of programming languages

ML is a language that appeared in 1973.
Since then, three dialects have become the most popular implementations of ML:

* OCaml
* Standard ML
* F# (part of the .NET platform)

Specifically, OCaml and F# have very strong ecosystems (OCaml because it is a popular and mature language, F# because as part of the .NET platform, it can use many .NET libraries and tools).

Haskell is inspired by ML, but many of the Haskell features discussed above are not present in the ML languages:

* MLs have eager evaluation, therefore avoiding the performance pitfalls of Haskell.
* MLs have simpler syntax, therefore frequently leading to clearer error messages.

For example, compare the following snippet of OCaml to the previous error message example from Haskell:

```
$ utop  # utop is a friendlier OCaml REPL
# let sum a b = a + b ;;
val sum : int -> int -> int = <fun>
# sum 2 2 ;;
- : int = 4
# sum 2 2 2 ;;
Error: This function has type int -> int -> int
       It is applied to too many arguments; maybe you forgot a `;'.
```

In my opinion, OCaml and F# are better languages for the initial learning of functional programming than Haskell.
After learning an ML, you are likely more prepared to learn Haskell and more sophisticated functional programming.

(Note that those recommendations come from someone who only has experimented with OCaml and F#, and learned SML formally.)
