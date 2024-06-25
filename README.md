## Building

```sh
$ (cd verkle_crypto; cargo build)
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH crystal build src/main.cr -o pampero
```
