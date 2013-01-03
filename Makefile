.PHONY: all iso box package clean

all: iso box package

iso:
	sudo ./make_iso.sh

box:
	./make_vbox.sh

package:
	./make_package.sh

clean:
	./make_clean.sh

