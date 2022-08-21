PREFIX = /usr/local
CC = gcc
CFLAGS = -std=c++17 -Wno-conversion-null -O3 -pthread `pkg-config --cflags libpulse-simple` `pkg-config --cflags fftw3`
LIBS = -lm -lstdc++ `pkg-config --libs libpulse-simple` `pkg-config --libs fftw3`
INCLUDES = includes/
DEPS = $(INCLUDES)/*.h
DEPS := $(INCLUDES)/*.hpp
OBJ = input/pulse.so input/common.so transform/wavatransform.so

%.so: %.c $(DEPS)
	$(CC) -I$(INCLUDES) $(CFLAGS) -fPIC -shared -c $< -o $@ $(LIBS)

%.so: %.cpp $(DEPS)
	$(CC) -I$(INCLUDES) $(CFLAGS) -fPIC -shared -c $< -o $@ $(LIBS)

libwava.so: $(OBJ)
	ld -r $^ -o $@ 

install: libwava.so 
	mkdir -p $(PREFIX)/include/libwava
	cp -rf includes/ $(PREFIX)/include/libwava
	mv $(PREFIX)/include/libwava/includes/* $(PREFIX)/include/libwava/
	rm -rf $(PREFIX)/include/libwava/includes/
	cp -f libwava.so $(PREFIX)/lib/libwava.so

.PHONY: clean

uninstall:
	rm $(PREFIX)/lib/libwava.so
	rm -rf $(PREFIX)/include/libwava
clean:
	rm -f $(OBJ) libwava.so
