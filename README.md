## Building

Instruction for building crystal project and rust library

```sh
$ (cd verkle_crypto; cargo build) 
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH CRYSTAL_OPTS="--link-flags=-Wl,-ld_classic" GC_DONT_GC=1 crystal build src/main.cr -o pampero
```


## Unit tests

To run all the tests

```sh
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH CRYSTAL_OPTS="--link-flags=-Wl,-ld_classic" GC_DONT_GC=1 crystal spec
```

