# Makefile for TinyMatrix

NAME	   = TinyMatrix
OBJECTS    = $(NAME).o
DEVICE     = attiny4313
CLOCK      = 4000000
FUSES      = -U hfuse:w:0xDF:m -U lfuse:w:0xE2:m -F
PROGRAMMER = avrispmkII -P usb
# mit buspiratkabel:
# IC pin 20 = rot
# IC pin 19 = violett
# IC pin 18 = weiß
# IC pin 17 = braun
# IC pin 10 = schwarz
# IC pin  1 = grün

#PROGRAMMER = usbasp
#PROGRAMMER = stk500 -P /dev/ttyACM0
#PROGRAMMER = buspirate -P /dev/ttyUSB0

AVRDUDE = avrdude -c $(PROGRAMMER) -p t4313
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

# symbolic targets:
all:	$(NAME).bin $(NAME).hex

.c.o:
	$(COMPILE) -c $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:$(NAME).hex:i

test:	
	$(AVRDUDE) -t

fuse:
	$(AVRDUDE) $(FUSES)

clean:
	rm -f $(NAME).hex $(NAME).elf $(OBJECTS)

# file targets:
$(NAME).bin: $(NAME).elf
	avr-objcopy -j .text -j .data -O binary -R .eeprom $(NAME).elf $(NAME).bin

$(NAME).elf: $(OBJECTS)
	$(COMPILE) -o $(NAME).elf $(OBJECTS)

$(NAME).hex: $(NAME).elf
	rm -f $(NAME).hex
	avr-objcopy -j .text -j .data -O ihex $(NAME).elf $(NAME).hex


