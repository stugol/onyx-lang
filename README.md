Onyx - a practical, enjoyable, efficient programming language
=======

## "tl;dr Summary" ##
_Enjoy writing an app that runs with trustworthy stability at speeds of C/C++
with just the effort of scripting or writing pseudo._

## Index ##
- Long Version
- What do you mean with scientific approach?
- Usages?
- Relation to Crystal
- Inspiration
- Why?
- What does it look like currently?
- Installing
- Documentation
- Community
- Contributing

## Long Version ##
* **Use scientific findings** for aspects of programming linguistics where research is available, in order to obtain:
    - _Highest possible productivity_ (which according to findings seem to require "enjoying the process")
    - Most _secure functioning_ possible produced by that effort
    - _Efficient code_ naturally by the common patterns.
* **Which from current findings and interpretations means**:
    - _Statically type-checked_, with inheritance, mixins, re-openable types, generics and type vars. _ALL types inferred_ unless explicit annotation wanted or demanded by coder.
    - A _terse and clear indent based syntax_ with voluntary explicit block ends (wysiwyg + safety net).
        - Both _alpha-style and symbol-style notation_ offered for many constructs for starters (might change).
        - _Underscores and dashes_ (`snake_case` and `dash-case`/`lisp-case`) are used interchangeably in identifiers per preference.
    - Common constructs gets _terser notation_. Syntax for traditional constructs that are not used often in practice today gets demoted.
    - _OOP-based_, with functional-style coding fully possible where applicable (all of code if wished)
    - Advanced and hygienic _templates and macros_ to avoid boilerplate code.
    - _Compile quickly!_ (fast turn over).
    - _Informative errors_ - the aim is for the compiler to be able to figure out as closely as possible what you _likely_ wanted and reduce debugging time.
    - Compile to _efficient fast native code_.
* **Further**:
    - Dead _simple to call C code_ by writing bindings to it in Onyx.
    - Full _compatibility with Crystal_ modules - the language semantics core - (any Crystal module can be used seamlessly in the same project) to enlarge the module universe.
    - During development, we'll _try_ to build "upgrade" functionality into the
    compiler to upgrade user code when syntax changes / gets depreceated. That way
    more serious code can be written without worrying about completely rewriting
    it.

## What do you mean with scientific approach? ##
Well, there are very few quantitative, or otherwise, studies. So admittedly the
statement could be seen a kind of vague.
What is _not_ meant is "highly theoretical functional lambda theory". What _is_
meant is:
- Optimize for human parsing - not computers parsing (_not_ lisp syntax uniformity)
- Human languages has exceptions to rules, so common constructs should get sugar if warranted.
- A language has to work for several scenarios, be _elegantly out of the way when
  prototyping_. Be _lovingly tough on diciplined code_ when demanded by coder.
- A language has to work for a wide range of coders. Any team bigger than one will
  have mixed levels of experience and requirements, while still working on the same code base.
- Any work should be enjoyable if we're smart about being human, so also coding.
- Not every coder, nor every _project_ suits the same syntactic style. There
  should be variations to suit preferences. For a given project a good style
  guideline should be set by/for teams though. But it should always be up to the
  developers. One (or even two variants) of an "official" Onyx styleguide will
  be developed via discussions. Further, some _named styleguides_ will be
  developed for different scenarios, so that some uniform choices to start off
  from exists - sort of styleguide templates.

## Usages? ##
* _"Scripting"_: Because it compiles quickly and you don't _need_ to explicitly type annotate anything - it could be used in place of Python, Ruby, etc, for pretty much any task.
* _System coding_: Since binaries achieve speeds nearing (some times beating) C/C++, interfacing with C is dead simple, and hardening/strictening policies are available.
* _Game coding_: As above.
* _Business systems_: As above.
* _Analytics and math_: As above.
* **Well, anything really**, except hard real time applications (where you'd probably use C - however it is _fully possible_ in Onyx)

## Relation to Crystal ##
Onyx uses Crystal backend semantics, type inference and code generation, and as
such it's basically just an alternative syntax / front-end, with some additional
semantics.
It's not intended as a competitor to Crystal, but rather a different approach to
the same linguistic "core". Crystal is a fantastic project and language, the
gripe for some of us is its "stay true to Ruby" motto, which keeps it from being
_the_ next generation language of choice, because of accumulated inconsistencies
hindering free innovation.
Without the effort of the Crystal team, Onyx wouldn't be on its way _today_ -
Onyx would still be one of my countless experimental implementations that come
to a halt and are re-iterated again and again (I coded my first _transpiler_
[simple heuristic] to C/C++ in '99-'00, called Cython [_no relation to the
project with the same name that came eight years later!_]).

_**Crystal** is for those who do love the Ruby way._

_**Onyx** is for those who simply want a language as fun, productive and secure as
possible_. The path to this is by building on scientific studies on computer
linguistics (_something strangely lacking in the community!!_), inspiration from
other languages created to date, the common patterns and problems faced in
today's coding - and _that's where **you come in to the picture**_. _Your input is
what will shape the language._
Because of Onyx compatibility goal with Crystal, some minor trade offs might
have to be done, but the gains of a greater module universe, being a
"language family", will likely be a bigger pro.

## Inspiration ##
Inspiration is taken from languages as diverse as Crystal (obviously), Haskell,
Rust, Nim, LiveScript, Go, Lisp, Python, C++, etc. - only "the best parts",
in an integrated way.

## Why? ##

- You want to write code as fast as pseudo.

- You want it to compile quickly while developing.

- You want that code to execute at speeds of C/C++.

- You want to be able to increase demands and strictness on code _when needed_.

- Onyx loves you unconditionally - and so won't imprison you; an onyx-to-crystal
converter is one aim - so that you can opt over to that if you'd wish to for some
reason.

## What does it look like currently? ##

```haskell

-- types inherits Class by default if nothing else specified

type Greeter
    @greeting-phrase = "Greetings,"
    -- @greeting-phrase Str = "Greetings," -- a more explicit way

    init() ->
        -- do nothing - just keep defaults

    init(@greeting-phrase) ->
        -- do nothing here. Sugar for assigning a member did all we need

    -- above could have been written more verbose; in many different levels.
    -- def init(greeting-phrase Str) ->
    --     @greeting-phrase = greeting-phrase
    -- end-def

    -- define a method that greets someone
    greet-someone(who-or-what) ->
        say make-greeting who-or-what
        -- say(make-greeting(who-or-what)) -- parentheses or juxtaposition calls

    -- a method that constructs the message
    make-greeting(who-or-what) ->
        "#{@greeting-phrase} #{who-or-what}"
    end  -- you can explicitly end code block at will

    -- All on one line works too of course:
    -- make-greeting(who-or-what) -> "#{@greeting-phrase} #{who-or-what}"

end-type -- you can be even more explicit about end-tokens at will

type HelloWorldishGreeter << Greeter
    @greeting-phrase = "Hello"
end

greeter = HelloWorldishGreeter "Goodbye cruel"
greeter.greet-someone "World" --  => "Goodbye cruel World"
-- greeter.greet_someone "World" -- separator (-|–|_) completely interchangable

```


## Status ##

* Onyx is in "design stage"/alpha while settling it. Input (RFC's) on the syntax
  and language in general is **highly welcomed**!
* Currently the basic first syntax ideas are implemented, it only has a few days
  of coding on it yet you see. Several keywords to do the same thing are
  available many times, until agreement on what to keep and what to ditch comes up.
* Some syntax doesn't have semantics yet, until it gets carved deeper in the
  onyx. For example declaring func's `pure`, `method`, `lenient`. And mutation/
  immutable modifiers on parameters and variables.
* Macros and templates syntax has not been worked on at all yet. Semantics are
  in place, thanks to Crystal.
* The "core semantics language" Crystal is in alpha, close to beta.
* **It will need a few more weeks of coding before it's ready for public
  consumption, I think.**

## Roadmap ##

* Nail down core syntax and semantic concepts while continually implementing syntax
* Implement core semantics according to agreed upon
    - PR as much as is accepted directly to Crystal code base
* Iron out bugs and do final language tweaks
* Onyx 1.0
* Nail down improved concurrency syntax and semantics
* Implement improved concurrency constructs
    - PR as much as is accepted directly to Crystal code base
* Onyx 1.1+
* Improve low level aspects of language core
    - PR as much as is accepted directly to Crystal code base:
    - Tailor made GC for optimal throughput and lowest latency
    - Tailor made co-routines low level code
* Onyx 1.2+
* Improve low level further by facilitating manual memory managment when wanted
    - for many cases, the lifespan of data and structure of code is really
      straight forward, if working with hardcore speed need / low latency code,
      being able to manually allocate and destroy data, thereby keeping the GC
      sleeping, can be very beneficial, while still being able to setup the
      non hot parts of the app utilizing the comfort and safety of GC.
    - in devel mode, the GC will be used behind the scenes still, in order to be
      able to make extra checks that objects are not accessed after their
      official destruction.
    - in release mode you get full on blazing speed.
* Onyx 1.3+

### Notes ###
- Since the low level aspects are beneficial and transparent to Crystal as well as
Onyx, those items are not dependent on the Onyx project.
- Roadmap - as everything at this point - is subject to change.

## Installing ##

For the time being:
- You might want highlighter for sublime, etc: `git clone https://github.com/ozra/sublime-onyx.git`
- Install Crystal (compiler source is in crystal for a forseeable future)
- clone repo `git clone https://github.com/ozra/onyx-lang.git`
- `make`
- Run freshly built compiler. which currently looks less then nice, in order to
  ease the pain of 3rd-party libs, onyx source stdlib. `--stats` and `--verbose`
  can be nice when hacking on it. Change `./spec/onyx-compiler/first-test.ox` to
  your application main file to compile your onyx project. Use `release` command
  instead of `devel` to compile with optimizations.
```
CRYSTAL_PATH=./src \
      .build/onyx devel --stats --verbose --link-flags "-L/opt/crystal/embedded/lib" \
      ./spec/onyx-compiler/first-test.ox
```

## Documentation ##

To come. For standard library, refer to Crystals docs - the lib is shared.

## Community ##

Use "issues" for now. Add RFC's or ideas already if you feel like it!
Read the general [Contributing guide](https://github.com/ozra/onyx-lang/blob/master/Contributing.md),
(it's very terse, you will get through it!)

## Contributing ##

Read the general [Contributing guide](https://github.com/ozra/onyx-lang/blob/master/Contributing.md),
(it's very terse, you will get through it!) and then:

The code base follows the same guide lines and style as Crystal - since it
simplifies features making its way back into the Crystal project when reasonable.

1. Fork it ( https://github.com/ozra/onyx-lang/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
