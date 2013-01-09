.PHONY: all iso box package clean

all: iso box package

iso:
	sudo ./bin/make_iso.sh

box:
	./bin/make_vbox.sh

package:
	./bin/make_package.sh

clean:
	./bin/clean.sh

