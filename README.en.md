## Intro
By using vim-easy-copy plugin, you can quickly copy, cut, or delete several rows without having to move back and forth.

## Reliance
If you want to copy the code block quickly, you can install another of my plug-ins, vim-get-blocks(https://github.com/peter-lyr/vim-get-blocks), before installing this one.

## Install
I prefer to use the plug-vim( https://github.com/junegunn/vim-plug/ ) manager to install:
```vim
call plug#begin('~/.vim/bundle')
"if you like:
"Plug 'peter-lyr/vim-get-blocks'
Plug 'peter-lyr/vim-easy-copy'
call plug#end()
```

## Usage
When we need to move up 8 lines, then copy 5 lines, return to the original position, paste, we just need to type in four characters: `-8p5`.
Similarly, in addition to implementing in-place replication, we can also achieve in-place deletion, movement.

1. `-` means moving up, `=` means moving down.
2. The number of rows you move depends on whether you set up the following:

```vim
"The following 36 is the default value(You can move 1 to 35 lines up or down):
"Note that the higher the value, the more time it takes to start neovim.
"So more than 100 will be reset to 100.
let g:easy_copy_max_range = 36
```

3. Realized actions: `p` for copy, `m` for movement, `d` for deletion.
4. The number of lines you can copy(move or delete) is 1 to 9, if the fourth character is a number.
But when the fourth character is `b` or `p`, you can copy (move or delete) all the lines in the block of code, or the entire paragraph in which the current line is located.
Of course `b` this feature requires installing my `vim-get-blocks` plug-in.
