 # Copyright (C) 2019, David PHAM-VAN <dev.nfet.net@gmail.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.

 DART_SRC=$(shell find . -name '*.dart')
 COV_PORT=9292

all: format

format: format-dart

format-dart: $(DART_SRC)
	dartfmt -w --fix $^

format-clang: $(CLNG_SRC)
	clang-format -style=Chromium -i $^

format-swift: $(SWFT_SRC)
	swiftformat --swiftversion 4.2 $^

.coverage:
	pub global activate coverage
	touch $@

node_modules:
	npm install lcov-summary

test/readme_test.dart: test/extract_readme.dart README.md
	flutter packages get
	dart test/extract_readme.dart

test: .coverage test/readme_test.dart node_modules
	flutter test --coverage --coverage-path lcov.info
	cat lcov.info | node_modules/.bin/lcov-summary

clean:
	git clean -fdx -e .vscode

publish: format clean
	test -z "$(shell git status --porcelain)"
	find . -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	pub publish -f
	find . -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'
	git tag $(shell grep version pubspec.yaml | sed 's/version\s*:\s*/about-/g')

.pana:
	pub global activate pana
	touch $@

analyze: .pana
	@find . -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	@pub global run pana --no-warning --source path . 2> /dev/null | python pana_report.py
	@find . -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'

.dartfix:
	pub global activate dartfix
	touch $@

fix: .dartfix
	flutter packages get
	pub global run dartfix:fix --overwrite .

.PHONY: test format format-dart format-clang clean publish analyze
