LOVE_FILE = $(shell basename `pwd`).love
LOVE_LIB = lib

main:
	make clean
	mkdir build
	cp README.md build
	cp main.lua build
	cp conf.lua build
	cp -R resources build/
	rm -rf resources/design
	cp -R src build
	cp -R $(LOVE_LIB)/lib build
	cd build; zip -r ../$(LOVE_FILE) .
	rm -rf build/*
	mv $(LOVE_FILE) build

run: build/$(LOVE_FILE)
	cd build; love $(LOVE_FILE)

build/$(LOVE_FILE) :
	make

love:
	$(shell LUA_PATH=$LUA_PATH\;$(LOVE_LIB)/?.lua love .)

clean:
	rm -rf build
