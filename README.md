# Steam Fix

> Fixes issues with Steam and games on Ubuntu/Linux by removing libstdc++ and
> libgcc libraries from the Steam folder.

<p align='center'>
<img src='https://raw.githubusercontent.com/MaximDevoir/steam-fix/gh-assets/usage.gif' width='600' alt='./entrypoint.sh'>
</p>

## Getting Started

Begin by downloading the latest release from
[releases][releases], or by `git
cloning` the repository.

### Usage

Open a terminal at the directory you placed the software at and and run
`./entrypoint.sh`. Follow the instructions provided by the software.

**Reminder:** Whenever Steam updates, a game in your library is
updated/installed, or an integrity check is ran on either Steam or a game, the
`libstdc++` and `libgcc` files might be re-added. You must run the software each
time those files are re-added.

### Updating

The software will inform you if you are running an outdated version of the
software.

When an update is available, you can update via Git or by downloading the latest
release. If you attained the software via `git`; read `via Git`. Otherwise, you
probably downloaded the software; read `via Download`.

#### via Download

Download the latest [release][releases]
and replace your old files with the new files.

#### via Git

From the project directory, run `git pull`.

## License

[MIT](LICENSE)

[releases]: https://github.com/MaximDevoir/steam-fix/releases
