if ! command -v ppc &> /dev/null
then
  echo "ppc is not installed...; ppc is sack/src/makefiles/prog/ppc"
  exit
fi

#:::
#:   
#:   ../../src/typelib/typecode.c 
#:   ../../src/typelib/text.c 
#:   ../../src/typelib/sets.c
#:   ../../src/typelib/binarylist.c 
#:   ../../src/memlib/sharemem.c 
#:   ../../src/memlib/memory_operations.c 
#:   ../../src/deadstart/deadstart_core.c 
#:   
#:   

SRCS=""
SRCS="$SRCS   ../../src/typelib/typecode.c "
SRCS="$SRCS   ../../src/typelib/text.c "
SRCS="$SRCS   ../../src/typelib/sets.c"
SRCS="$SRCS   ../../src/typelib/binarylist.c "
SRCS="$SRCS   ../../src/typelib/url.c"
SRCS="$SRCS   ../../src/typelib/familytree.c"
SRCS="$SRCS   ../../src/fractionlib/fractions.c"
SRCS="$SRCS   ../../src/vectlib/vectlib.c"

SRCS="$SRCS   ../../src/memlib/sharemem.c "
SRCS="$SRCS   ../../src/memlib/memory_operations.c"

#: Timers and threads (and idle callback registration)
SRCS="$SRCS   ../../src/timerlib/timers.c "
SRCS="$SRCS   ../../src/idlelib/idle.c "

#: File system unifications
SRCS="$SRCS   ../../src/filesyslib/pathops.c"
SRCS="$SRCS   ../../src/filesyslib/winfiles.c"
SRCS="$SRCS   ../../src/filesyslib/filescan.c"

#: debug logging
SRCS="$SRCS   ../../src/sysloglib/syslog.c"

#: plain text configuration reader."
SRCS="$SRCS   ../../src/configlib/configscript.c"

#: system abstraction (launch process, parse arguments, build arguments)
#: Also includes environment utilities, and system file paths
#:   (paths: CWD, dir of program, dir of this library)SRCS="$SRCS   ../../src/systemlib/args.c
SRCS="$SRCS   ../../src/systemlib/system.c"
SRCS="$SRCS   ../../src/systemlib/spawntask.c"
SRCS="$SRCS   ../../src/systemlib/args.c"
SRCS="$SRCS   ../../src/systemlib/oswin.c"

#: Process extension; dynamic procedure registration.
#: Reading the system configuration brings module support
#: which requires this.
SRCS="$SRCS   ../../src/procreglib/names.c"


SRCS="$SRCS   ../../src/utils/virtual_file_system/vfs.c"
SRCS="$SRCS   ../../src/utils/virtual_file_system/vfs_fs.c"
SRCS="$SRCS   ../../src/utils/virtual_file_system/vfs_os.c"
SRCS="$SRCS   ../../src/contrib/md5lib/md5c.c"
SRCS="$SRCS   ../../src/contrib/sha1lib/sha1.c"
SRCS="$SRCS   ../../src/contrib/sha2lib/sha2.c"
SRCS="$SRCS   ../../src/contrib/sha3lib/sha3.c"
SRCS="$SRCS   ../../src/contrib/K12/lib/KangarooTwelve.c"
SRCS="$SRCS   ../../src/salty_random_generator/salty_generator.c"
SRCS="$SRCS   ../../src/salty_random_generator/crypt_util.c"
SRCS="$SRCS   ../../src/salty_random_generator/block_shuffle.c"


SRCS="$SRCS   ../../src/deadstart/deadstart_core.c "
 

rm sack_ucb_filelib.c"
rm sack_ucb_filelib.h"

ppc -c -K -once -ssio -sd -I../../include -p -osack_ucb_filelib.c -DINCLUDE_LOGGING $SRCS

mkdir h
cp config.ppc.h h\config.ppc
cd h

HDRS=""
HDRS="$HDRS ../../../include/stdhdrs.h"
HDRS="$HDRS ../../../include/network.h"
HDRS="$HDRS ../../../include/html5.websocket.h"
HDRS="$HDRS ../../../include/html5.websocket.client.h"
HDRS="$HDRS ../../../include/json_emitter.h"
HDRS="$HDRS ../../../include/jsox_parser.h"
HDRS="$HDRS ../../../include/configscript.h"
HDRS="$HDRS ../../../include/filesys.h"
HDRS="$HDRS ../../../include/procreg.h"
HDRS="$HDRS ../../../include/http.h"
HDRS="$HDRS ../../../include/sack_vfs.h"
HDRS="$HDRS ../../../include/md5.h"
HDRS="$HDRS ../../../include/sha1.h"
HDRS="$HDRS ../../../include/sha2.h"
HDRS="$HDRS ../../../src/contrib/sha3lib/sha.h"
HDRS="$HDRS ../../../include/salty_generator.h"


ppc -c -K -once -ssio -sd -I../../../include -p -o../sack_ucb_filelib.h $HDRS
cd ..

LD_CFLAGS="-DTARGETNAME=NULL"

gcc -c -g -o a.o $LD_CFLAGS sack_ucb_filelib.c
gcc -c -O3 -o a-opt.o $LD_CFLAGS sack_ucb_filelib.c

#: - ws2_32 
#: - iphlpapi 
#: - crypt32
#: - rpcrt4 
#: - odbc32 
#: - ole32

LIBS=""
LIBS="${LIBS} -lm"
LIBS="${LIBS} -lpthread"
LIBS="${LIBS} -ldl"
LIBS="${LIBS} -lodbc"
LIBS="${LIBS} -luuid"

CFLAGS="-DTARGETNAME=NULL"

gcc -g -o a.exe $CFLAGS sack_ucb_filelib.c test.c $LIBS
gcc -O3 -o a-opt.exe $CFLAGS sack_ucb_filelib.c test.c $LIBS

gcc -g -o a.exe a.o $CFLAGS test.c $LIBS
gcc -O3 -o a-opt.exe a-opt.o $CFLAGS test.c $LIBS

#:_CRT_NONSTDC_NO_DEPRECATE;NO_OPEN_MACRO;_DEBUG;NO_OPEN_MACRO;__STATIC__;USE_SQLITE;USE_SQLITE_INTERFACE;FORCE_COLOR_MACROS;NO_OPEN_MACRO;__STATIC__;NO_FILEOP_ALIAS;_CRT_SECURE_NO_WARNINGS;NEED_SHLAPI;NEED_SHLOBJ;JSON_PARSER_MAIN_SOURCE;SQLITE_ENABLE_LOCKING_STYLE=0;MINIMAL_JSON_PARSE_ALLOCATE