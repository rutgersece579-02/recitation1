# Copyright (c) 2012 MIT License by 6.172 Staff 1

CC := gcc

ifeq ($(DEBUG),1)
	CFLAGS := -Wall -O0 -g
else
	CFLAGS := -Wall -O3 -DNDEBUG
endif

LDFLAGS := -lrt

ifeq ($(PROFILE),1)
	CFLAGS := $(CFLAGS) -pg
	LDFLAGS := $(LDFLAGS) -pg
endif

all: rollingsum
ifeq ($(PROFILE),1)
	./rollingsum > /dev/null
	mv gmon.out gmon.sum
	./rollingsum > /dev/null
	gprof -s ./rollingsum gmon.out gmon.sum
	gprof ./rollingsum gmon.sum > gprof-output
endif

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

ktiming.o: ktiming.c
	$(CC) $(CFLAGS) -c ktiming.c

sum.o: sum.c
	$(CC) $(CFLAGS) -c sum.c

rollingsum: main.o ktiming.o sum.o
	$(CC) -o rollingsum main.o ktiming.o sum.o $(LDFLAGS)

clean:
	rm -f rollingsum *.o
