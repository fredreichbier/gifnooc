gifnooc
=======

gifnooc is a configuration framework for ooc. At the moment, you can use it to manage command line (using Optparse) and
INI options (using oocini) under a unified interface. You are supposed to organize your configuration in a "stack-like"
structure. Everytime you need a configuration value, you ask the top entity for it. If it doesn't have
any information about this value, it asks the next entity, and so it goes on recursively until
an answer is found. If an entity knows a value, it is returned immediately.
The bottom entity should always be a "fixed" entity that provides with default values.
This way, top entities override bottom entities.

Some Art
~~~~~~~~

A drawing showing a typical approach:

(top) 

+--------------+
| Optparse     |
+--------------+
| INI (user)   |
+--------------+
| INI (system) |
+--------------+
| Fixed        |
+--------------+

(bottom)

Also, gifnooc provides with a generic extensible serializer in ``gifnooc/Serialize``.

Crowbar disclaimer
~~~~~~~~~~~~~~~~~~

If you have any questions or a need for better documentation or surprise cakes please join #ooc-lang
on freenode and ping fredreichbier.
