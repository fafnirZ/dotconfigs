
run this command
```
ln -s $(pwd)/bashrc_extension ~/.bashrc_extension
```


load this additional file into bashrc

add the following code to bashrc

```
if [ -f $HOME/.bashrc_extension ]; then
    source $HOME/.bashrc_extension
    echo "extensions loaded from .bashrc_extension"
else
    echo "extensions failed to load from .bashrc_extension" 
fi
```
