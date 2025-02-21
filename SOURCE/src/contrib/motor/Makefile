# Standardwerte, falls keine Umgebungsvariablen gesetzt sind
CC ?= gcc
CFLAGS ?= -Wall -Wextra -O2
LDFLAGS ?=
TARGET ?= motor
SRCS = motor.c
OBJS = $(SRCS:.c=.o)

# Installationspfad (kann mit "make DESTDIR=/custom/path install" überschrieben werden)
PREFIX ?= /
BINDIR ?= $(PREFIX)/bin

# Standardziel
all: $(TARGET)

# Übersetzungsregel für .c-Dateien
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Linken der finalen ausführbaren Datei
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(TARGET)

# Aufräumen
clean:
	rm -f $(OBJS) $(TARGET)

# Neubaubereinigung (falls Artefakte hängen bleiben)
distclean: clean

# Installationsregel (mit DESTDIR für alternative Installationspfade)
install: $(TARGET)
	mkdir -p $(DESTDIR)$(BINDIR)
	cp $(TARGET) $(DESTDIR)$(BINDIR)/

# Falls Cross-Compiler verwendet wird:
# Beispiel: make CROSS_COMPILE=arm-linux-gnueabihf-
ifdef CROSS_COMPILE
	CC := $(CROSS_COMPILE)gcc
endif
