CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = IMPL_REF
OBJS = main.o arcfour.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS)

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)
	

clean:
	rm $(OBJS) $(TARGET)
