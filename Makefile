.PHONY: all iso box clean

all: iso box

iso:
	sudo ./make_iso.sh

box:
	./make_vbox.sh

clean:
	./make_clean.sh

