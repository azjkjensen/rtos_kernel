# #####################################################################
# # ECEn 425 Lab 4b Makefile

# lab4b.bin: lab4bfinal.s
# 	nasm lab4bfinal.s -o lab4b.bin -l lab4b.lst

# lab4bfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4bapp.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab4bapp.s > lab4bfinal.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab4bapp.s: lab4bapp.c yakk.h yaku.h clib.h
# 	cpp lab4bapp.c lab4bapp.i
# 	c86 -g lab4bapp.i lab4bapp.s

# clean:
# 	rm lab4b.bin lab4b.lst lab4bfinal.s myinth.s yakc.s lab4bapp.s lab4bapp.i myinth.i 

#####################################################################
# ECEn 425 Lab 4c Makefile

# lab4c.bin: lab4cfinal.s
# 	nasm lab4cfinal.s -o lab4c.bin -l lab4c.lst

# lab4cfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4c_app.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab4c_app.s > lab4cfinal.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab4c_app.s: lab4c_app.c yakk.h yaku.h clib.h
# 	cpp lab4c_app.c lab4c_app.i
# 	c86 -g lab4c_app.i lab4c_app.s

# clean:
# 	rm lab4c.bin lab4c.lst lab4cfinal.s myinth.s yakc.s lab4c_app.s lab4c_app.i myinth.i

#####################################################################
# ECEn 425 Lab 4d Makefile
lab4d.bin: lab4dfinal.s
	nasm lab4dfinal.s -o lab4d.bin -l lab4d.lst

lab4dfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4d_app.s
	cat clib.s myisr.s myinth.s yaks.s yakc.s lab4d_app.s > lab4dfinal.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s
              
yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
        
lab4d_app.s: lab4d_app.c yakk.h yaku.h clib.h
	cpp lab4d_app.c lab4d_app.i
	c86 -g lab4d_app.i lab4d_app.s

clean:
	rm lab4d.bin lab4d.lst lab4dfinal.s myinth.s yakc.s lab4d_app.s lab4d_app.i myinth.i  