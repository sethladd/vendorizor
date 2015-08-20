# vendorizor

EXPERIMENTAL.

Attempts to help answer the question: Can we live without symlinks?

WARNING: this overwrites your .packages file and deletes your packages/ dir.

This simple script:

* opens a .packages file
* finds all packages that came from pub.dartlang.org and live in your pub cache
* copies the contents into your app's packages/ directory
* writes a new .packages file (pointing into your local packages/ directory)

## Usage

* pub global activate vendorizor
* cd to your Dart app
* run: vendorizor
