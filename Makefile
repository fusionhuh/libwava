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
	cp -f libwava.so /usr/local/lib/libwava.so

.PHONY: clean

uninstall:
	rm /usr/local/lib/libwava.so
clean:
	rm -f $(OBJ) libwava.so
