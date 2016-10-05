#####################################################################
# ECEn 425 Lab 3 Makefile

lab3.bin:	lab3final.s
		nasm lab3final.s -o lab3.bin -l lab3.lst

lab3final.s:	clib.s lab3isr.s lab3inth.s primes.s
		cat clib.s lab3isr.s lab3inth.s primes.s > lab3final.s

lab3inth.s:	lab3inth.c
		cpp lab3inth.c lab3inth.i
		c86 -g lab3inth.i lab3inth.s

primes.s:	primes.c
		cpp primes.c primes.i
		c86 -g primes.i primes.s

clean:
		rm lab3.bin lab3.lst lab3final.s lab3inth.s lab3inth.i \
		primes.s primes.i