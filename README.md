# Steam Fix

> Fixes issues with Steam on Ubuntu/Linux by removing libstdc++ and libgcc
> libraries from the Steam folder.

## Getting Started

Begin by downloading the latest release from [releases](./releases), or by `git
cloning` the repository.

### Usage

To use the software, open a terminal and run `./entrypoint.sh`. Follow the
instructions provided by the software.

**Notice:** Whenever Steam updates or a game in your library is
updated/integrity checked, the `libstdc++` and `libgcc` files may be re-added.
You must re-run this software to remove those new files.

### Updating

Several methods exist for updating the software. If you attained the software
via `git` read that section. Otherwise, you likely `downloaded` the software.

#### via Git

If you downloaded the software via `git`, you may update by using `git pull`
(`master` branch recommended).

#### via Download

Download the latest [release](./releases) and replace your old files with the
new files.

## License

[MIT](LICENSE)
