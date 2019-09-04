# genInterfaceOverride.hpp #
A small program to generate importable override signatures from a list of virtual
function prototypes  

[![License badge](https://img.shields.io/badge/license-GNU%20GPL%20V3+-brightgreen.svg?style=for-the-badge)](LICENSE)
[![Keep a Changelog badge](https://img.shields.io/badge/Keep%20a%20Changelog-1.0.0-orange.svg?style=for-the-badge)](http://keepachangelog.com)
[![Semantic Versioning badge](https://img.shields.io/badge/Semantic%20Versioning-2.0.0-orange.svg?style=for-the-badge)](http://semver.org)

## Usage ##

```sh
genInterfaceOverride <import_macro_name> <source_file> <output_file>
```

Given the 3 parameters above, a c++ header file will be generated in the
following form:

```c++
#define IMPORT_MACRO_NAME \
	SIGNATURE_1 \
	SIGNATURE_2 \
	SIGNATURE_3
```

## How to build ##

Just run ```make```, the executable will be generated in the ```build/dist/```
directory
