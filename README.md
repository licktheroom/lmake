# lmake 0.1

lmake is a Lua project creation tool like make and cmake. It's meant to be smart and percise. Please see [Contributing](./CONTRIBUTING.md) for details on how to help.

## Table of contents

- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [License](#license)

## Requirements

- Lua <= 5.2

## Quick Start

For detailed information see the [wiki](https://github.com/licktheroom/lmake/wiki).
### Example
Currently the only way to use lmake is through the commandline. An example command would be:

```lmake --files main.c otherfile.c --compiler gcc --flags -O2 --build-dir build/```
### Explained

 * ```lmake```

The lmake command.
 * ```--files main.c otherfile.c```

```--files``` tells lmake what files we want to compile. In this case we want to compile ```main.c``` and ```otherfile.c```. You can add any number of files as long as you seperate them with a space.
 * ```--compiler gcc```
 
 ```--compiler``` says which compiler we should be using. We tell it to use ```gcc```, but it can be anything.
 * ```--flags -O2```

```--flags``` tells lmake what flags we should run the compiler with. Here we tell it to use ```-O2``` when compiling. This would use the command ```gcc -O2``` when compiling files.
 * ```--build-dir build/```
 
 ```--build-dir``` defines were we want the final executable to be put. Passing ```build/``` will put the executable in a directory called ```build```.



## License

MIT License

Copyright (c) 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the Software), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
