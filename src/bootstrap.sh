#!/bin/sh

set -e
cd $(dirname "$0") # Change to this directory

gerbil_opt="-O"
if [ ! -z "$GERBIL_BUILD_NOOPT" ]; then
    gerbil_opt=""
fi

rm -rf bootstrap/*
mkdir -p bootstrap/gerbil
cp gerbil/builtin.ssxi.ss bootstrap/gerbil
gxc $gerbil_opt -d bootstrap -s -S gerbil/core/{runtime,expander,sugar,mop,macro-object,match,more-sugar,more-syntax-sugar,module-sugar}.ss gerbil/core.ss gerbil/runtime/{gambit,util,table,control,system,c3,mop,error,interface,hash,thread,syntax,eval,repl,loader,init}.ss gerbil/runtime.ss gerbil/expander/{common,stx,core,top,module,compile,root,stxcase}.ss gerbil/expander.ss gerbil/compiler/{base,method,compile,optimize-base,optimize-xform,optimize-top,optimize-spec,optimize-ann,optimize-call,optimize,driver,ssxi}.ss gerbil/compiler.ss gerbil/gambit.ss
