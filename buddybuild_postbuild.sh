#!/bin/bash

bundle install

mkdir -p buddybuild_artifacts/SwiftTests
swift test 2>&1 | bundle exec xcpretty -r junit -o buddybuild_artifacts/SwiftTests/output.xml
