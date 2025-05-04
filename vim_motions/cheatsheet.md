## Commands I use

### Vim Commands
- `gd` - goto definition
- `ctrl+o` - undo a goto command?
- `yy` - yank line
- `dd` - delete line
- `shift+v` - select line
- `shift+``<` or `>` - in visual mode, indent/unindent

- `e` - end of word
- `w` - start of word
- `b` - go back 1 word (start)
- `ge` - back 1 word (end)


- `daw` - when inside a word delete the entire word
- `dw` - delete word starting from cursor
- `caw` - change a word when inside it
- `dawi` - delete a word then go into insert mode
- `daW` - delete a(round) Word (includes symbols)
- `caW` - change ^
- `dw` - delete word after cursor
- `yaw` - yank a word

- `10gg` - go line 10
- `:s/word/replace/g` - search for `word` replace with `replace` for all occurrences in line
- `:noh` - remove search highlights
- `:vsp` - vsplit current page 

#### macro
- `qa` - record macro for register `a`
- `q`  - when in record mode type q to end recording
- `@a` - play macro at register a
- `@@` - play last macro

### Non vanilla vim commands
leader = space
- `<leader> + hjkl` - change focused window 
- `shift+j|k` - 5 up|down


### Vscode commands
- `ctrl+/`     - comment highlighted
- `ctrl+alt+<up>/<down>`   - multiselect line
- `ctrl+shift+l` - select all occurrences of word at cursor in file
- `ctrl(hold)+k+2` - collapse symbols to level 2 (0-9)
- `ctrl(hold)+k+j` - undo all collapse
- `ctrl+t` - find symbol
- `ctrl+p` - open file
- `ctrl+j` - open terminal
- `ctrl+a` - select all
- `ctrl+w` - delete tab
- `ctrl+g` - go to line
- `ctrl+b` - collapse sidebar
- `ctrl+f` - find
- `ctrl+\` - split current page into new screen
