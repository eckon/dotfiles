if exists("current_compiler")
  finish
endif
let current_compiler = "tsc"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=tsc

CompilerSet errorformat=%f(%l\\,%c):\ error\ TS%n:\ %m
