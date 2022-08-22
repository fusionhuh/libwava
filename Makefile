PREFIX = /usr/local
CC = gcc
CFLAGS = -std=c++17 -Wno-conversion-null -O3 -pthread `pkg-config --cflags libpulse-simple` `pkg-config --cflags fftw3`
LIBS = -lm -lstdc++ `pkg-config --libs libpulse-simple` `pkg-config --libs fftw3`
INCLUDES = includes/
DEPS = $(INCLUDES)/*.h
DEPS := $(INCLUDES)/*.hpp
OBJ = input/common.so input/pulse.so transform/wavatransform.so 

%.so: %.c $(DEPS)
	$(CC) -I$(INCLUDES) $(CFLAGS) -fPIC -shared -c $< -o $@ $(LIBS)

%.so: %.cpp $(DEPS)
	$(CC) -I$(INCLUDES) $(CFLAGS) -fPIC -shared -c $< -o $@ $(LIBS)

libwava.so: $(OBJ)
	ld -r $^ -o $@ 

install: libwava.so
	chmod 0755 libwava.so 
	mkdir -p $(PREFIX)/include/libwava
	cp -rf includes/ $(PREFIX)/include/libwava
	mv $(PREFIX)/include/libwava/includes/* $(PREFIX)/include/libwava/
	rm -rf $(PREFIX)/include/libwava/includes/
	cp -f libwava.so $(PREFIX)/lib/libwava.so

.PHONY: clean

uninstall:
	rm $(PREFIX)/lib/libwava.*
	rm -rf $(PREFIX)/include/libwava
clean:
	rm -f $(OBJ) libwava.so libwava.a
