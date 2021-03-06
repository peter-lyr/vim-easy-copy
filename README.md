## 介绍
此插件可以帮你快速复制、剪切或删除若干行，而不需要来回移动。

## 依赖
如果希望可以快速复制代码块，可以在安装此插件前安装我的另一个插件vim-get-blocks。

## 安装
我更倾向于使用vim-plug( https://github.com/junegunn/vim-plug/ )管理器来安装：
```vim
call plug#begin('~/.vim/bundle')
"如果你喜欢:
"Plug 'peter-lyr/vim-get-blocks'
Plug 'peter-lyr/vim-easy-copy'
call plug#end()
```

## 用法
当我们需要往上移动8行，然后复制5行，返回原来的位置，粘贴时，我们只需要敲入四个字符：`-8p5`。
类似的，除了实现原地复制，我们还可以实现原地删除、移动。

1. `-`表示往上移动，`=`表示往下移动。
2. 移动的行数取决于你是否做如下设置：

```vim
"如下36是默认的值（你可以往上或往下移动1~35行）：
"注意该值越大，开始启动neovim时会耗费越多时间。
"因此超过100时会被重置为100。
let g:easy_copy_max_range = 36
```

3. 实现的动作：`p`代表复制，`m`代表移动，`d`代表删除。
4. 你可以复制（移动或删除）的行数为1~9，如果第四个字符是数字的话。
但是当第四个字符是`b`或`p`时，你可以复制（移动或删除）代码块内的所有行，或者当前行所在的整个段落。
当然`b`的这个功能需要安装我的`vim-get-blocks`这个插件。
