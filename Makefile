PREFIX?=/usr
BINDIR?=$(PREFIX)/bin
SHAREDIR?=$(PREFIX)/share

default: run

build:
	shards build

docs:
	crystal docs

lint:
	./bin/ameba

test:
	crystal spec

run:
	shards run
