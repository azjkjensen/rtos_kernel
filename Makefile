#####################################################################
# ECEn 425 Lab 4b Makefile

lab4b.bin: lab4bfinal.s
	nasm lab4bfinal.s -o lab4b.bin -l lab4b.lst

lab4bfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4bapp.s
	cat clib.s myisr.s myinth.s yaks.s yakc.s lab4bapp.s > lab4bfinal.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s
              
yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
        
lab4bapp.s: lab4bapp.c yakk.h yaku.h clib.h
	cpp lab4bapp.c lab4bapp.i
	c86 -g lab4bapp.i lab4bapp.s

clean:
	rm lab4b.bin lab4b.lst lab4bfinal.s myinth.s yakc.s lab4bapp.s myinth.i 