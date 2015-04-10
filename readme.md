Kahlua
======

A small library to simplify common tasks.
An eventual goal is "batteries" for Lua.


#### kahlua.prototype

Lua isn't an object-oriented language, and objects are traditionally implemented
via prototypes. The straightforward way of creating them isn't too cumbersome,
and can easily be turned into a snippet in any text editor worth its salt, but
why not create a simple method that does it automatically and doesn't clutter
the code?

To create a "class" (a prototype), use this notation:

```lua
MagicBeing = kahlua.prototype () {
    knows_about = "magic";
    talk = function (self)
        print("I can tell you about " .. self.knows_about)
    end;
}
```

This will create a prototype called `MagicBeing`. Apart from the fields and
methods that are explicitly defined, it will also create a method `new(self)`
that can spawn "descendant" objects.

Inheritance is also straightforward:

```lua
Ogre = kahlua.prototype (MagicBeing) {
    knows_about = "onions";
}
shrek = Ogre:new()
shrek:talk()
```

When shrek talks, naturally, it says `"I can tell you about onions"`.


#### kahlua.global

`kahlua.global(some_table, fields)` imports specified fields from a table
into the global namespace (`_G`).
Often, modules are implemented as tables, so you might use this as a counterpart
to Python's `from some_module import some_method`:

```lua
kahlua.global(math, {"sin", "cos"})
print(sin(0.42)^2 + cos(0.42)^2)
```

If this doesn't look compelling enough, let me show you how I use this method
almost exclusively:

```lua
require "kahlua": global "prototype"
```

`require` imports kahlua and returns it as a table, which allows me to use its
method (`global`) immediately and pass it itself as the first argument via a
colon.


#### kahlua.lambda, kahlua.la

A very simplistic unnamed function generator.
Accepts a virtually unlimited number of arguments, which should be referenced
by their positional number.

```lua
require "kahlua": global "la"
F = la "#1 ^ #2"

print(F(25, 3)) --> 15625
```


#### kahlua.io.lines

This is a very simple extension to `io.lines`.
Sometimes it's useful to register EOF inside a loop, and `kahlua.io.lines`,
instead of silently finishing at EOF like `io.lines` does, returns one more
chunk which is a boolean `false`.

**NB!** it relies on the implementation of `io.lines`, so if you modified it in
some way, you're on your own.
