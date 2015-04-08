Kahlua
======

A small library to simplify common tasks.
An eventual goal is "batteries" for Lua.

### Prototype

Lua isn't an object-oriented language, and objects are traditionally implemented
via prototypes. The straightforward way of creating them isn't too cumbersome,
and can easily be turned into a snippet in any text editor worth its salt, but
why not create a simple method that does it automatically and doesn't clutter
the code?

To create a "class" (a prototype), use this notation:

```lua
MagicBeing = prototype() {
    knows_about = "magic";
    talk = function (self)
        print("I can tell you about " .. self.knows_about)
    end;
}
```

This will create a prototype called `MagicBeing`. Apart from the fields and
methods in this constructor, it will also create a method `new (self)` that can
spawn "descendant" objects.

Inheritance is also straightforward:

```lua
Ogre = prototype(MagicBeing) {
    knows_about = "onions";
}
shrek = Ogre:new()
shrek:talk()
```

When shrek talks, naturally, it says `"I can tell you about onions"`.
