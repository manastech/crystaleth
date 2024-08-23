## Requiriements

A recent version of [Crystal](https://crystal-lang.org/install) and [Rust](https://www.rust-lang.org/tools/install).

## Building

Instruction for building crystal project and the `verke_crypto` rust library it depends on.

```sh
$ (cd verkle_crypto; cargo build --release)
$ shards install
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH crystal build src/main.cr -o pampero
```

## Show block details

Block at latest slot

```sh
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH crystal run src/dump_block.cr
```

Block at slot 831627

```sh
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH crystal run src/dump_block.cr  -- 831627
```

## Unit tests

To run all the tests

```sh
$ LIBRARY_PATH=$(PWD)/verkle_crypto/target/debug:$LIBRARY_PATH crystal spec
```

