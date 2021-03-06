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
# lab4d.bin: lab4dfinal.s
# 	nasm lab4dfinal.s -o lab4d.bin -l lab4d.lst

# lab4dfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4d_app.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab4d_app.s > lab4dfinal.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab4d_app.s: lab4d_app.c yakk.h yaku.h clib.h
# 	cpp lab4d_app.c lab4d_app.i
# 	c86 -g lab4d_app.i lab4d_app.s

# clean:
# 	rm lab4d.bin lab4d.lst lab4dfinal.s myinth.s yakc.s lab4d_app.s lab4d_app.i myinth.i

#####################################################################
# ECEn 425 Lab 5 Makefile
# lab5.bin: lab5final.s
# 	nasm lab5final.s -o lab5.bin -l lab5.lst

# lab5final.s: clib.s myisr.s myinth.s yaks.s yakc.s lab5app.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab5app.s > lab5final.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab5app.s: lab5app.c yakk.h yaku.h clib.h
# 	cpp lab5app.c lab5app.i
# 	c86 -g lab5app.i lab5app.s

# clean:
# 	rm lab5.bin lab5.lst lab5final.s myinth.i myinth.s yakc.i yakc.s lab5app.s lab5app.i myinth.i

#####################################################################
# ECEn 425 Lab 6 Makefile
# lab6.bin: lab6final.s
# 	nasm lab6final.s -o lab6.bin -l lab6.lst

# lab6final.s: clib.s myisr.s myinth.s yaks.s yakc.s lab6app.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab6app.s > lab6final.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab6app.s: lab6app.c yakk.h yaku.h clib.h
# 	cpp lab6app.c lab6app.i
# 	c86 -g lab6app.i lab6app.s

# clean:
# 	rm lab4c.bin lab4c.lst lab4cfinal.s myinth.s yakc.s lab4c_app.s lab4c_app.i myinth.i\
# 		yakc.i 

# #####################################################################
# # ECEn 425 Lab 7 Makefile
# lab7.bin: lab7final.s
# 	nasm lab7final.s -o lab7.bin -l lab7.lst

# lab7final.s: clib.s myisr.s myinth.s yaks.s yakc.s lab7app.s
# 	cat clib.s myisr.s myinth.s yaks.s yakc.s lab7app.s > lab7final.s

# myinth.s: myinth.c
# 	cpp myinth.c myinth.i
# 	c86 -g myinth.i myinth.s
              
# yakc.s: yakc.c
# 	cpp yakc.c yakc.i
# 	c86 -g yakc.i yakc.s
        
# lab7app.s: lab7app.c yakk.h yaku.h clib.h
# 	cpp lab7app.c lab7app.i
# 	c86 -g lab7app.i lab7app.s

# clean:
# 	rm lab4c.bin lab4c.lst lab7final.s myinth.s yakc.s lab7app.s lab7app.i myinth.i\
# 		yakc.i 


#####################################################################
# ECEn 425 Lab 8 Makefile
lab8.bin: lab8final.s
	nasm lab8final.s -o lab8.bin -l lab8.lst

lab8final.s: clib.s myisr.s myinth.s yaks.s yakc.s simptrisApp.s
	cat clib.s myisr.s myinth.s yaks.s yakc.s simptrisApp.s simptris.s > lab8final.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s
              
yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
        
simptrisApp.s: simptrisApp.c yakk.h yaku.h clib.h
	cpp simptrisApp.c simptrisApp.i
	c86 -g simptrisApp.i simptrisApp.s

clean:
	rm lab4c.bin lab4c.lst lab8final.s myinth.s yakc.s simptrisApp.s simptrisApp.i myinth.i\
		yakc.i 