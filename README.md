# Guide

generally I recommend you (me) symlink the configs into the appropriate location

```
ln -s {location_of_config} {location_of_symlink}
```

## setting up
### set a symlink from .config/nvim -> here

```
ln -s $(pwd)/nvim ~/.config/nvim
ln -s $(pwd)/tmux/tmux.conf ~/.tmux.conf
```

## adding dedicated binary location
create a dedicated binary location for your user, for example:
```
/home/{username}/bin
```

then add it to your PATH in your shell configuration file (bashrc/zshrc), for example:
```
export PATH="$PATH:$HOME/bin"
```

symlink or copy binaries to dedicated location

