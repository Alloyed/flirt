Flirt
=====

Flirt is a small script for picking the appropriate version of LOVE to
use for any given LOVE game. To run flirt, you'll need a Unix-like environment
with the following commands:

* lua 5.1
* unzip
* which
* test
* mkdir

This means no Windows, sorry.

Using
-----

Flirt can be installed using luarocks:

```
# luarocks install flirt
```

Or you can use a compiled, single-file version if you prefer:

```
$ wget https://raw.githubusercontent.com/Alloyed/flirt/master/flirt_script -O ~/bin/flirt && chmod +x ~/bin/flirt
```

Then, we need to tell flirt where our LOVE installs are:

```
$ flirt --autoconf # will look for common names
$ flirt --add-exe `which love` # You can also manually specify paths
```

Then, we can just use flirt instead of using our love binaries directly:

```
$ flirt my_game.love
$ alias love=flirt
$ love my_game_dir
```

If a game does not specify a version, flirt will use the most recently
released version of LOVE you have told it about, ignoring pre-release
builds. If you do not have an appropriate version of LOVE installed,
flirt will tell you what version the game expects and fail.

Tests
-----

None yet ;^)

Contributions
-------------

Please do ;^)

License
-------

Flirt is Copyright (c) 2015 Kyle Mclamb, under the zlib license.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source
distribution.


