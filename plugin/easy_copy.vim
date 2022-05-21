function! DoSthHere(dir, start, action, lines)
    "1.记录当前行的行号
    let [current_line_number] = getpos('.')[1:1]
    "2.移动到指定行并开始选择
    if a:dir == '-'
        exec 'norm ' .a:start .'kV'
    elseif a:dir == '='
        exec 'norm ' .a:start .'jV'
    endif
    "3.向下移动若干行
    if a:lines == 'p'
        norm ip
    elseif a:lines == 'b'
        norm Vvib
    elseif a:lines != 1
        exec 'norm ' .(a:lines - 1) .'j'
    endif
    "4.执行动作
    if a:action == 'copy'
        "复制到当前行
        exec 'norm y|' .current_line_number .'ggp'
    else
        "删除它们
        norm d
        "回到原来的位置
        if a:dir == '-' && a:lines != 'p' && a:lines != 'b'
            let line_number = current_line_number - a:lines
        elseif a:dir == '-' && (a:lines == 'p' || a:lines != 'b')
            let line_number = current_line_number - len(split(getreg('"'), '\n'))
        else
            let line_number = current_line_number
        endif
        exec 'norm ' .line_number .'gg'
        "移动
        if a:action == 'move'
            norm p
        endif
    endif
endfunction


function! EasyCopy()
    if exists('g:easycopy_loaded')
        ec "[EasyCopy] Wouldn't load twice! Max lines you can reach: " .(s:line_nums_to_move - 1)
        return
    end
    let g:easycopy_loaded  = 1

    if exists('g:easycopy_maxrange')
        let s:line_nums_to_move = g:easycopy_maxrange <= 100 ? g:easycopy_maxrange : 100
    else
        let s:line_nums_to_move = 36
    endif

    python3 << EOF
import vim
import time
dirs = ['-', '=']
line_nums_to_move = int(vim.eval('s:line_nums_to_move'))
actions = [('delete', 'd'), ('copy', 'p'), ('move', 'm')]
s = time.time()
for dir in dirs:
    for start in range(1, line_nums_to_move):
        for action in actions:
            for lines_to_do in list(range(1, 10))+['b', 'p']:
                cmd = f"nnoremap {dir}{start}{action[1]}{lines_to_do} :silent call DoSthHere('{dir}', '{start}', '{action[0]}', '{lines_to_do}')<cr>"
                vim.command(cmd)
print('耗时:', time.time() - s)
EOF
    if !exists('g:easycopy_startupload')
        ec '[EasyCopy] Loaded! Max lines you can reach: ' .(s:line_nums_to_move - 1)
    endif
endfunction

if exists('g:easycopy_startupload') && g:easycopy_startupload == 1
    autocmd VimEnter * :call EasyCopy()
endif
command! EasyCopy call EasyCopy()
