function! DoSthHere(dir, start, action, lines)
    "1.记录当前行的行号
    let [current_line_number] = getpos('.')[1:1]
    "2.移动到指定行并开始选择
    if a:dir == '-'
        exec ':normal ' .a:start .'kV'
    elseif a:dir == '='
        exec ':normal ' .a:start .'jV'
    endif
    "3.向下移动若干行
    if a:lines == 'p'
        exec ':normal ip'
    elseif a:lines == 'b'
        exec ':normal Vvib'
    elseif a:lines != 1
        exec ':normal ' .(a:lines - 1) .'j'
    endif
    "4.执行动作
    if a:action == 'copy'
        "复制到当前行
        exec ':normal y|' .current_line_number .'ggp'
    else
        "删除它们
        exec ':normal d'
        "回到原来的位置
        if a:dir == '-' && a:lines != 'p' && a:lines != 'b'
            let line_number = current_line_number - a:lines
        elseif a:dir == '-' && (a:lines == 'p' || a:lines != 'b')
            let line_number = current_line_number - len(split(getreg('"'), '\n'))
        else
            let line_number = current_line_number
        endif
        exec ':normal ' .line_number .'gg'
        "移动
        if a:action == 'move'
            exec ':normal p'
        endif
    endif
endfunction


function! Easy_copy()
    if exists('b:easycopy_loaded')
        ec "[EasyCopy] Wouldn't load twice! Max lines you can reach: " .(g:line_nums_to_move - 1)
        return
    end
    let b:easycopy_loaded  = 1

    if exists('g:easy_copy_max_range')
        let g:line_nums_to_move = g:easy_copy_max_range <= 100 ? g:easy_copy_max_range : 100
    else
        let g:line_nums_to_move = 36
    endif

    python3 << EOF
import vim
dirs = ['-', '=']
line_nums_to_move = int(vim.eval('g:line_nums_to_move'))
actions = [('delete', 'd'), ('copy', 'p'), ('move', 'm')]
for dir in dirs:
    for start in range(1, line_nums_to_move):
        for action in actions:
            for lines_to_do in list(range(1, 10))+['b', 'p']:
                cmd = f"nnoremap {dir}{start}{action[1]}{lines_to_do} :silent call DoSthHere('{dir}', '{start}', '{action[0]}', '{lines_to_do}')<cr>"
                vim.command(cmd)
EOF
    if !exists('g:loadeasy_atonce')
        ec '[EasyCopy] Loaded! Max lines you can reach: ' .(g:line_nums_to_move - 1)
    endif
endfunction

if exists('g:loadeasy_atonce')
    autocmd BufWinEnter * :call Easy_copy()
else
    command! EasyCopy call Easy_copy()
endif
