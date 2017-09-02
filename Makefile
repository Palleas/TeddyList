build:
	@swift build

install:
	@swift build -c release -Xswiftc -static-stdlib
	@cp -f .build/release/TeddyList /usr/local/bin/teddyList

test:
	@swift test
