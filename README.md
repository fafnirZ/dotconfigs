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
