#!/usr/bin/env python3
from pwn import *

{bindings}
context.binary = {bin_name}

host, port = "addr", 1337
context.terminal = ["tmux", "splitw", "-h"]   
# context.terminal = ["kitty", "-e", "sh", "-c"]

gdbscript = """
b *main
c
""".strip()

def start():
    if args.GDB:
        return gdb.debug([exe.path], gdbscript=gdbscript)
    if args.REMOTE:
        return remote(host, port)
    return process([exe.path])


def run():
    io = start()

    # good luck pwning :)

    io.interactive()

run()
