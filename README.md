# Micro C-Boost (no relation)

This is a family of amalgamated products from [SACK](https://www.github.com/d3x0r/sack).  
Tried to host this as a gist; but that didn't work out so well.  

Other Amalgamations
 - [Minimal; just types](https://github.com/d3x0r/micro-C-Boost-Types)

# FileSystem

This includes all of sack_ucb_typelib plus filesystem and system utility abstractions.



This is a C file, but if the .h is included as C++ then namespaces will
be used, and the .c file should be renamed as .cc/.cpp/... or compiler option
otherwise forced to C++.

## External Dependencies

on Windows
 - winmm  - for timeGetTime() (millisecond accurate clock)
 - psapi   - system process info
 - ntdll   - system dll info
 - ole32   - file system utility initialization (CoInitialize)
 - ws2_32  - systemlog UDP logging to a syslog receiver uses sockets.

on Linux
 - m
 - dl
 - pthread


## Rough Source List / Build Script

```
@set SRCS= %SRCS%   ../../src/typelib/typecode.c 
@set SRCS= %SRCS%   ../../src/typelib/text.c 
@set SRCS= %SRCS%   ../../src/typelib/input.c
@set SRCS= %SRCS%   ../../src/typelib/sets.c
@set SRCS= %SRCS%   ../../src/typelib/binarylist.c 
@set SRCS= %SRCS%   ../../src/typelib/url.c
@set SRCS= %SRCS%   ../../src/fractionlib/fractions.c
@set SRCS= %SRCS%   ../../src/memlib/sharemem.c 
@set SRCS= %SRCS%   ../../src/memlib/memory_operations.c 
@set SRCS= %SRCS%   ../../src/deadstart/deadstart_core.c 

@set SRCS= %SRCS%   ../../src/vectlib/vectlib.c


: Timers and threads (and idle callback registration)
@set SRCS= %SRCS%   ../../src/timerlib/timers.c 
@set SRCS= %SRCS%   ../../src/idlelib/idle.c 

: File system unifications
@set SRCS= %SRCS%   ../../src/filesyslib/pathops.c
@set SRCS= %SRCS%   ../../src/filesyslib/winfiles.c
@set SRCS= %SRCS%   ../../src/filesyslib/filescan.c

: debug logging
@set SRCS= %SRCS%   ../../src/sysloglib/syslog.c

: plain text configuration reader.
@set SRCS= %SRCS%   ../../src/configlib/configscript.c

: system abstraction (launch process, parse arguments, build arguments)
: Also includes environment utilities, and system file paths
:   (paths: CWD, dir of program, dir of this library)
@set SRCS= %SRCS%   ../../src/systemlib/args.c
@set SRCS= %SRCS%   ../../src/systemlib/system.c
@set SRCS= %SRCS%   ../../src/systemlib/spawntask.c
@set SRCS= %SRCS%   ../../src/systemlib/args.c
@set SRCS= %SRCS%   ../../src/systemlib/oswin.c

: Process extension; dynamic procedure registration.
: Reading the system configuration brings module support
: which requires this.
@set SRCS= %SRCS%   ../../src/procreglib/names.c


```

An old build of the documentation (there haven't been a LOT of updates)
http://sack.sf.net

- [File System](http://sack.sourceforge.net/sack__filesys.html)
- [System](http://sack.sourceforge.net/sack__system.html)
- [App general](http://sack.sourceforge.net/sack__app.html)
- [Procedure Registry](http://sack.sourceforge.net/sack__app__registry.html)


[containers](http://sack.sourceforge.net/sack__containers.html)

- [General](http://sack.sourceforge.net/sack.html)
- [Memory](http://sack.sourceforge.net/sack__memory.html)
- [Deadstart](http://sack.sourceforge.net/sack__app__deadstart.html)

- [containers](http://sack.sourceforge.net/sack__containers.html) - threadsafe
  - [list](http://sack.sourceforge.net/sack__containers__list.html) - items tracked by dynamic sized array of pointers to userdata
  - [data list](http://sack.sourceforge.net/sack__containers__data_list.html) - Items are tracked by a dynamic sized array of structs
  - [Queue](http://sack.sourceforge.net/sack__containers__queue.html) - tracks a queue of pointers to userdata.
  - [Data QUeue](http://sack.sourceforge.net/sack__containers__data_queue.html) - Tracks a queue with a dynamic array of structures.
  - [Link Stack](http://sack.sourceforge.net/sack__containers__link_stack.html) - stack using a dynamic array of pointers to userdata
  - [Data Stack](http://sack.sourceforge.net/sack__containers__data_stack.html) - Stack using dynamic array of structs.
  - [sets](http://sack.sourceforge.net/sack__containers__sets.html) - A fixed length slab of data structure which are tracked by a bit field of allocated/free members in the set.
  - [Binary tree](http://sack.sourceforge.net/sack__containers__BinaryTree.html) - binary tree using 'set's of nodes that contain pointers to userdata and userkey information.
  - [Text](http://sack.sourceforge.net/sack__containers__text.html) - a type abstraction for tracking strings as linked list of segments... include language text parser for getting phrases and words from other text.
  - Url parsing and building (something like github.com/d3x0r/sack/include/url.h)
- [text](http://sack.sourceforge.net/sack__containers__text.html)
- [Math](http://sack.sourceforge.net/sack__math.html)
  - [Fraction](http://sack.sourceforge.net/sack__math__fraction.html)
  - [Vector](http://sack.sourceforge.net/sack__math__vector.html)
  
## Build Flags

Some platforms/permutations need flags defined to compile 'correctly'. The 
CMake build system for SACK takes care of these typically...

| Flag | Usage |
|-----|------|
| __LINUX__ | compile for posix type system.  This should be defaulted if not _WIN32 |
| _WIN32 | compile for windows platform |
| __ARM__ | compile targeting arm (some assembly otherwise available is replaced |
| __MAC__ | comppile targeting Mac; minor differences in SockAddr structure |
| __NO_LOGGING__ | Disable any internal logging; compiles to `(0);` |
| __64__ | This should have a good default set; but this sets 64 bit platform target |
| __ANDROID__ | certain changes for android system |


## Behavior

The default allocator is malloc/free.  There is, additionally, an option added to disable mmap.  There
is a custom allocator which offers additonal protection on blocks, including scanning all blocks for over/underflow.  A list
of all blocks may be dumped (see memory document above), options can be enabled either way to allow memory allocation logging.
This tracks back to the original sources' (if _DEBUG or _DEBUG_INFO are defined) file and line number.

This uses a single locking primitive that's a `lock: xchg`; if compiled with GCC prefers the comipler intrinsics for these 
operations.  Uses windows `InterlockedExchanged()` function.

PLIST, PLINKQUEUE are strongly threadsafe by default.  All other containers are also thread safe, but are not worthy of comment.
The actual point is that PLIST and PLINKQUEUE types are optimally thread safe even when interacting on the same list or queue.



## Compile Time Options 

To Be Documented.

The default options for the above are conservative, but there may be more suitable options available at the low levels.

