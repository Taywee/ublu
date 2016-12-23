.. _Intro:

Intro
"""""

Overview
--------

`Ublu <https://github.com/jwoehr/ublu>`__ is a tool for ad-hoc process
automation primarily aimed at `IBM
i <http://www-03.ibm.com/systems/power/software/i/>`__ ®.

The Java command line ``java ublu.Ublu`` [args ...] invokes an
extensible object-disoriented interpretive language named Ublu
intended for interaction between any Java platform on the one hand,
and OS400 (IBM i Series OS ®) and IBM z/VM ® SMAPI operations
programming on the other. The language is :ref:`multithreaded <TASK>`
and offers a :ref:`client-server <Server_mode>` mode. It also possesses
a built-in single-step :ref:`debugger <Debugger>`.

-  Access to the i Series OS server is implemented via the `JTOpen
   library <http://jt400.sourceforge.net/>`__.
-  Access to z/VM SMAPI is provided via the
   `PigIron <http://pigiron.sourceforge.net/>`__ library (see the
   `smapi <#smapi>`__ command).
-  Interoperation between the DB2 for i Series database and
   `Postgresql <http://www.postgresql.org/>`__ open source database is
   provided (see the `db <#db>`__ command).
-  Terminal "screen-scraping" automation is provided via
   `tn5250j <https://github.com/tn5250j>`__ (see the
   `tn5250 <#tn5250>`__ command).

"\ **Object-disoriented**" means that Ublu is a procedural language with
function definitions which is implemented on top of object-oriented Java
libraries. Ublu manipulates objects constructed in the underlying environment
without forcing the user to know very much about the object architecture. By
way of analogy, consider how resources in a hierarchical network environment
are flattened out for ease of use by `LDAP
<https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol>`__.  In a
similar fashion, Ublu conceals many details while still providing complete
access should a program require it, e.g., via the :ref:`calljava <#calljava>`
command.

**Ublu** operates in four (4) modes:

#. as a command-line utility
#. as an interpreter
#. as a text file program executor via the ``include`` command
#. As a TCP/IP port listening server

In any mode, Ublu reads a line and then consumes one or more `commands
<#Command>`__ and their arguments and attempts to execute them. In certain
cases, text parsing crosses line boundaries, e.g., when a `quoted string
<#Quoted_strings>`__ or `execution block <#Execution_blocks>`__ extends for
multiple lines.

Ublu provides the command `FUNC <#FUNC>`__ to define functions with
argument lists which can later be invoked with appropriate arguments.

Commands and command features are steadily being added to the repertoire
of Ublu. Suggestions for added commands or extensions to extant commands
are welcome and should be made via whatever ticketing system is present
on the site where Ublu is distributed.

Installation
------------

Ublu is distributed as an archive containing

-  ``ublu.jar``

   -  the base system

-  the ``lib`` directory

   -  libraries Ublu depends on for execution

-  the ``examples`` directory

   -  examples of Ublu usage

-  the ``extensions`` directory

   -  extensions to the base Ublu system written in Ublu itself

-  documentation

   -  javadoc
   -  userdoc

-  edit modes
-  licenses
-  *miscellaneous*

Alternatively, you can `download the full source
<https://github.com/jwoehr/ublu>`__ or check it out via ``git`` or ``svn`` from
`the git repository <https://github.com/jwoehr/ublu.git>`__

The ``lib`` directory contains third-party .jar files containing classes
referenced by Ublu. The ``lib`` directory should be a subdirectory of
the directory containing ``ublu.jar`` .

We recommend the following layout:

* ``/opt/ublu/ublu.jar``
* ``/opt/ublu/lib``
* ``/opt/ublu/examples``
* ``/opt/ublu/extensions``

... etc.

Then define a function for your login shell:

-  bash

   -  ``function ublu () { java -jar /opt/ublu/ublu.jar $*; }``

-  ksh

   -  ``function ublu { java -jar /opt/ublu/ublu.jar $*; }``

.. _Invocation:

Invocation
----------

* ``java ublu.Ublu [args ...]`` *(set classpath first)*

*or*

* ``java -jar ublu.jar [args ...]`` *(for use if the lib directory containing
  open source support jars is a subdirectory of the directory containing
  ublu.jar)*

    * If the ``lib`` directory is a subdirectory of the directory in which
      ``ublu.jar`` resides, Ublu can be invoked via ``java -jar`` as shown.
      Otherwise, prior to invocation the CLASSPATH must be set to include each
      of the supporting .jar files found in the lib directory.

* Ublu commences by initializing the :ref:`main interpreter <Main_interpreter>`
  and processing the arguments to the invocation.

   -  Any initial arguments starting with the dash character (``-``)
      are taken to be switches to the Ublu invocation itself and are
      processed immediately.
   -  Any remaining arguments beginning with the first argument which
      does not start with a dash are passed as the initial input line to
      the interpreter.

-  When invoked with no non-switch command line arguments, Ublu prints
   to standard error information about the build including time/date
   stamp, open source usage and copyright before the main interpreter
   prompts. Then the main interpreter prompts and awaits interactive
   input.
-  The switches to Ublu invocation are as follows:

   -  ``-s`` by itself means "silent, no introductory greeting". When
      ``-include`` or ``-i`` is also present, it has another meaning
      (described below).

      -  Another way to avoid the introductory greeting message when invoking
        in interpret mode is to append the single command :ref:`interpret
        <interpret>` to the invocation command line.  This nests an interpreter
        and thus the main interpreter has not yet completed the initial command
        line.

   -  ``-include`` or ``-i`` means that the first non-switch item in the
     command line is the name of an Ublu source file to :ref:`include
     <include>`__. If ``-s`` is also one of the switches passed to Ublu, then
     the include will be a silent include. After the include, the rest of the
     command line will be parsed and executed as Ublu commands by the main
     interpreter, after which the main interpreter will take normal interactive
     input.

-  When invoked with non-switch arguments and none of the switches were
   ``-include``, Ublu will execute the arguments as if one line of
   commands were issued to the main interpreter and then exit.

   -  To continue in interpretive mode after invoking Ublu with a
      command line including arguments, make the last argument the
      command :ref:`interpret <interpret>`. This nests an interpreter
      and thus the main interpreter has not yet completed the initial
      command line.

-  Ublu upon exit returns a result code indicating the success of the
   last command that Ublu processed.

   -  0 is SUCCESS
   -  1 is FAILURE

::

    $ java -jar ublu.jar
    Ublu version 1.1.3+ build of 2016-10-16 09:30:57
    Author: Jack J. Woehr.
    Copyright 2015, Absolute Performance, Inc., http://www.absolute-performance.com
    Copyright 2016, Jack J. Woehr, http://www.softwoehr.com
    All Rights Reserved
    Ublu is Open Source Software under the BSD 2-clause license.
    THERE IS NO WARRANTY and NO GUARANTEE OF CORRECTNESS NOR APPLICABILITY.
    ***
    Ublu utilizes the following open source projects:
    IBM Toolbox for Java:
    Open Source Software, JTOpen 9.1, codebase 5770-SS1 V7R3M0.00 built=20160705 @RF
    Supports JDBC version 3.0
    Toolbox driver version 11.1
    ---
    Postgresql PostgreSQL 9.4.1208.jre6
    Copyright (c) 1997-2011, PostgreSQL Global Development Group
    All rights reserved http://www.postgresql.org
    ---
    tn5250j http://tn5250j.sourceforge.net/
    NO WARRANTY (GPL) see the file tn5250_LICENSE
    ---
    PigIron 0.9.7+ http://pigiron.sourceforge.net
    Copyright (c) 2008-2016 Jack J. Woehr, PO Box 51, Golden CO 80402 USA
    All Rights Reserved
    ---
    org.json
    Copyright (c) 2002 JSON.org
    ***
    Type help for help. Type license for license. Type bye to exit.

* To exit the system, type ``bye`` . Some minimal cleanup will be
  performed.
* ``[Ctrl-D]`` is effectively the same as ``bye`` .
* If you must force exit, type ``exit`` . No cleanup beyond that provided by
  Java itself will be performed.
* ``[Ctrl-C]`` is effectively the same as ``exit`` .

Memory requirements
~~~~~~~~~~~~~~~~~~~

Ublu ordinarily runs well with default Java memory values. However, in
performing database operations on large databases one may be forced to
boost the heap allocation considerably on invocation, e.g.::

    java -Xms4g -Xmx4g -jar /opt/ublu/ublu.jar ...

which allocates 4 gigabytes.
