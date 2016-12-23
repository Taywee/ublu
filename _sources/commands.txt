Commands
========

Commands are the verbs of Ublu. Some have only language meaning, but
the most important commands operate directly upon a host system
affecting its data and operation. Be sure you understand what you are
doing when you use an Ublu command!

Access to i Series hosts is provided through IBM's open source `JTOpen
library <http://jt400.sourceforge.net/>`__.

Access to z/VM SMAPI is provided through the author's open source `PigIron
library <http://pigiron.sourceforge.net/>`__.

Command Structure
-----------------

Commands are conceptually structured in three parts

#. command
#. dash-commands
#. arguments

Not all commands have dash-commands. Not all commands take arguments.  Usually
they take one or the other. The general order of the three parts is as follows:

    * command [dash-command dash-command-argument [dash-command-argument
    dash-command-argument ...] ] command-argument [command-argument ...]*

Where :ref:`dash-commands  <Dash Command>` are give in square brackets, e.g.,
``[-foo ~@{bazz}]`` the dash-command is optional and not required.

In this documentation, square brackets and ellipses are used to describe the
command structure. Those square brackets and ellipses are not part of the
syntax of Ublu, merely documentation notation. See the examples given in the
documentation and in the ``examples`` directory in the distribution.

In this documentation, where multiple dash-commands are enclosed
collectively in a outer pair of square brackets and individually
enclosed in square brackets and the bracketed dash-commands separated by
the .OR. bar ( \| ), e.g., then the dash-commands are a set of mutually
exclusive optional dash-commands, e.g.,
``[[-foo ~@{bazz}] | [-arf   ~@{woof}]]``

Where square brackets are missing from a dash-command description, the
dash-command, or one of the alternative of a series of dash-commands separated
in the description by the .OR. bar ( \| ) is required.

Some dash-commands are required in some contexts, and not in others.  Such
cases are explained in the explanatory text for the command.

Command
~~~~~~~

A *command* is a one-word command name. It is the first element of any Ublu
command invocation.

Dash Command
~~~~~~~~~~~~

A *dash-command* is a modifier to the command, itself often possessing an
argument or string of arguments.

All dash-commands to a command must appear on the same line with the command,
except that a :ref:`quoted string  <Quoted_strings>` once started may span line
breaks, thus extending a command over two or more lines.

If dash-commands specify conflicting operations, the last dash-command
encountered in command processing is the operative choice.

Often one dash-command is actually the default operation for the
command, so that if no dash-command is provided, this default provides
the operation of the command anyway. These defaults are noted in the
command descriptions.

.. _Eponymous dash-command:

Eponymous dash-command ( ``--`` )
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Many commands are used to create objects of various kinds and store them in
:ref:`tuple variables  <Tuple_Variables>`. Later, these same command operate on
these same objects which they themselves have created. This sort of command
references the tuple containing such an object via an eponymous dash-command,
e.g, ``job -job @some_job`` etc.  This eponymous dash-command can generally be
replaced by ``--`` instead, so the example just given could equally be written
``job -- @some_job`` etc.

Order of Dash Commands
^^^^^^^^^^^^^^^^^^^^^^

Often the order in which dash-commands appear on a line does not matter, but
sometimes it does. To be safe, dash commands should generally follow the
command in this order:

#. the :ref:`eponymous dash-command  <Eponymous dash-command>` or the
   one representing the object being operated upon
#. the two :ref:`data sink  <Datasinks>` dash-commands, ``-from`` and
   ``-to`` , if used
#. any other dash-commands

There are exceptions to this ordering, e.g, the eponymous dash-command
must come *last* for the :ref:`dbug <dbug>` command.

Argument
~~~~~~~~

An *argument* is the object or, for multiple arguments, list of objects
necessary for command execution.

Commands may have arguments, and their dash-commands may also have their
own arguments.

All arguments to a command or dash-command must appear on the same line as the
command or dash-command and cannot span a line-break, except that a
:ref:`quoted string  <Quoted_strings>` once started may span line breaks, thus
extending a command over two or more lines.

In command descriptions:

-  When an argument is decorated with the :ref:`tuple  <Tuple_Variables>`
   character ``@`` , as in ``-somedashcommand @tuple`` this signifies
   that a tuple name is expected.
-  When an argument is decorated with both the tuple character and the
   :ref:`stack-pop  <Tuple_stack>` indicator ``~`` , as in
   ``-somedashcommand ~@tuple`` this signifies that either a tuple name
   or the stack-pop indicator (popping an appropriate tuple previously
   pushed to the stack) is expected.
-  When an argument is decorated with the tuple character, the
   :ref:`stack-pop  <Tuple_stack>` indicator ``~`` and wrapped in curly
   braces, as in ``-somedashcommand ~@{some     string}`` , it signifies
   that the string argument may come from a named tuple, or a tuple
   pushed previously to the stack, or from an inline quoted string.
-  In any position where a quoted string is one of the allowed argument
   types, a simple undecorated inline lex
   (":ref:`plainword  <Plain_words>`\ ", no whitespace) is treated as a
   quoted string.
-  When the string in the description of the argument to a dash-command
   consists of alternatives separated by the .OR. bar ( ``|`` ) these
   are alternative values, usually literal, for the argument.

   -  An example is the description of the ``dpoint`` command's
      dash-command ``-type ~@{int|long|float}`` which means that
      ``-type`` expects an argument, either from a tuple or from a
      quoted string or :ref:`plainword  <Plainwords>` that is the literal
      string either ``int``, ``long``, or ``float``.

Command Example
~~~~~~~~~~~~~~~

An example of a command with dash-commands and arguments is the
following::

    job -job @j -to @subsys -get subsystem

-  ``job`` is the command.
-  ``-job @j`` is the ``job`` command's dash-command for providing the
   command with an already instanced tuple variable representing the
   server job the command is to operate upon.
-  ``-to @subsys`` is the ``job`` command's dash-command indicating the
   :ref:`data sink  <Datasinks>` (in this case, a tuple) to which the
   output of the ``job`` command is to go. Most commands know the
   ``-to`` *datasink* dash-command
-  ``-get subsystem`` is the ``job`` command's dash-command with single
   plainword argument indicating what aspect of the job represented by
   ``@j`` we wish to examine.

.. Note::

    the above example could equally have been written::

        job -- @j -to @subsys -get subsystem

    using the :ref:`eponymous dash-command  <Eponymous dash-command>`
    instead of ``-job``.

Datasinks
~~~~~~~~~

Command descriptions reference *datasinks*. A datasink is a data source or a
data destination.

Many commands offer the :ref:`dash-command  <Dash Command>` ``-to`` which
directs the output of the command (often an object) to the specified datasink.
Some commands offer the ``-from`` dash-command which assigns a source datasink
for input during the command, e.g., :ref:`include <include>` which reads and
interprets source code can have its input from a file or variable.

A datasink is currently one of these types:

#. Standard input and output
#. Error output
#. File
#. :ref:`Tuple variable  <Tuple_Variables>`
#. Null output (discard all data directed to this datasink).

A datasink's type is recognizable from its name.

-  ``STD:`` represents standard input and output and is the default
   destination datasink if none is explicitly provided via the ``-to``
   dash-command.\ ````
-  ``ERR:`` is the standard error output stream.
-  ``NULL:`` discards output.
-  A file can be any filename, relative or fully qualified pathname.

   -  File names are recognized in datasink assignment simply by their
      not matching one of the other name patterns for a datasink.

-  A named tuple variable is distinguished by starting with ``@`` as in
   ``@ThisIsAVar`` .

   -  The tuple variable thus named is created if it did not previously
      exist.

In the absence of the ``-to`` dash-command, the default destination
datasink of a commands is ``STD:`` (standard out).

When a command results in an object other than a string and the command's
destination datasink is File or Standard output the object's ``toString()``
method is called to provide the data.

System, Userid, Password and ``-as400``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to access the iSeries (AS400) server, many commands routinely require
in their argument string the following three items:

#. system (name or IP address)
#. userid
#. password

All such commands allow these three arguments to be omitted if instead the
``-as400`` dash-command is used to supply an extant server instance to the
command. See the :ref:`as400 <as400>` command to learn how create a server
instance to be used and re-used.

Of course, the execution of commands that require extended ownership, access
control or privilege level on the target system can only be executed via an
account with such privileges.

.. Note::

    Many of the oldest Ublu commands allow system/userid/password to be
    supplied as main command arguments as well as allowing the user to provide an
    as400 object via the -as400 dash-command. The older style of command is
    **deprecated** and **all code should use the -as400 style of providing an
    object created by the :ref:`as400 <as400>` command** rather than providing
    credentials as arguments to most commands.
