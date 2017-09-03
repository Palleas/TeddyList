build:
	@swift build

install:
	@swift build -c release -Xswiftc -static-stdlib
	@cp -f .build/release/TeddyList /usr/local/bin/teddyList

test:
	@swift test

bootstrap:
	@echo "Installing Sourcery"
	@brew install sourcery || true
	@echo "Generating code"
	@sourcery --templates Templates --sources Sources/TeddyListCore --output Sources/TeddyListCore
	@echo "Generating Xcodeproj"
	@swift package generate-xcodeproj
