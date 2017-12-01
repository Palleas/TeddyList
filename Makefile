# Shamelessly inspired from https://github.com/JohnSundell/Marathon/blob/master/Makefile
.PHONY: build
PREFIX?=/usr/local
INSTALL_NAME = tdl

install: release install_bin

build:
	swift build

release:
	swift package update
	swift build --enable-prefetching -c release -Xswiftc -static-stdlib

install_bin: build
	mkdir -p $(PREFIX)/bin
	mv .build/Release/TeddyList .build/Release/$(INSTALL_NAME)
	install .build/Release/$(INSTALL_NAME) $(PREFIX)/bin

test:
	@swift test

bootstrap:
	@echo "Installing Sourcery"
	@brew install sourcery || true
	@echo "Generating code"
	@sourcery --templates Templates --sources Sources/TeddyListCore --output Sources/TeddyListCore
	@echo "Generating Xcodeproj"
	@swift package generate-xcodeproj
