" ============================================================
" mytools.vim
" Vim 9.2 Cross-platform Tool Manager
" 请将此文件存放至C:\Users\18516\vimfiles\autoload目录下 配合_vimrc使用
"
" Managed tools:
"   fzf
"   ripgrep
"
" Windows:
"   Scoop
"
" Linux:
"   apt
"   pacman
"   dnf
"   yum
"   zypper
"   apk
"
" Commands:
"   :CheckTools
"   :InstallTools
" ============================================================


" ============================================================
" 防止重复加载
" ============================================================

if exists('g:loaded_mytools')
    finish
endif

let g:loaded_mytools = 1


" ============================================================
" 工具列表
" ============================================================

function! s:ToolList() abort
    return [
                \ {'name': 'fzf', 'command': 'fzf'},
                \ {'name': 'ripgrep', 'command': 'rg'},
                \ ]
endfunction


" ============================================================
" 系统判断
" ============================================================

function! s:IsWindows() abort
    return has('win32') || has('win64')
endfunction


function! s:IsLinux() abort
    return has('unix') && !has('macunix')
endfunction


" ============================================================
" 获取工具状态
" ============================================================

function! s:GetToolStatus(tool) abort

    if executable(a:tool.command)
        return 'OK'
    endif

    return 'MISS'

endfunction


" ============================================================
" 获取工具路径
" ============================================================

function! s:GetToolPath(tool) abort

    if executable(a:tool.command)
        return exepath(a:tool.command)
    endif

    return '未找到'

endfunction


" ============================================================
" 检查工具
" ============================================================

function! mytools#Check() abort

    echo ''
    echo '========== Vim Tools =========='
    echo ''

    echo printf(
                \ '%-12s %-10s %s',
                \ 'Tool',
                \ 'Status',
                \ 'Path'
                \ )

    echo '-----------------------------------------------'

    for tool in s:ToolList()

        let l:status = s:GetToolStatus(tool)
        let l:path = s:GetToolPath(tool)

        echo printf(
                    \ '%-12s %-10s %s',
                    \ tool.name,
                    \ l:status,
                    \ l:path
                    \ )

    endfor

    echo ''
    echo '==============================================='
    echo ''

endfunction


" ============================================================
" Windows：Scoop
" ============================================================

function! s:InstallWindows() abort

    " --------------------------------------------------------
    " 检查 Scoop
    " --------------------------------------------------------

    if !executable('scoop')

        echoerr
                    \ '未找到 Scoop，请先安装 Scoop。'

        return 0

    endif


    echo '包管理器：Scoop'
    echo ''


    " --------------------------------------------------------
    " 安装 fzf
    " --------------------------------------------------------

    if !executable('fzf')

        echo '正在安装 fzf...'

        let l:result = system(
                    \ 'scoop install fzf'
                    \ )

        if v:shell_error != 0

            echoerr 'fzf 安装失败。'
            echo l:result

            return 0

        endif

    else

        echo '[OK] fzf 已安装'

    endif


    " --------------------------------------------------------
    " 安装 ripgrep
    " --------------------------------------------------------

    if !executable('rg')

        echo '正在安装 ripgrep...'

        let l:result = system(
                    \ 'scoop install ripgrep'
                    \ )

        if v:shell_error != 0

            echoerr 'ripgrep 安装失败。'
            echo l:result

            return 0

        endif

    else

        echo '[OK] ripgrep 已安装'

    endif


    return 1

endfunction


" ============================================================
" Linux：包管理器检测
" ============================================================

function! s:GetLinuxPackageManager() abort

    " Debian / Ubuntu
    if executable('apt')
        return 'apt'

    " Arch Linux
    elseif executable('pacman')
        return 'pacman'

    " Fedora / RHEL 新版本
    elseif executable('dnf')
        return 'dnf'

    " RHEL / CentOS 旧版本
    elseif executable('yum')
        return 'yum'

    " openSUSE
    elseif executable('zypper')
        return 'zypper'

    " Alpine Linux
    elseif executable('apk')
        return 'apk'

    endif

    return ''

endfunction


" ============================================================
" Linux：安装单个工具
" ============================================================

function! s:InstallLinuxTool(package_manager, package_name) abort

    if a:package_manager ==# 'apt'

        return system(
                    \ 'sudo apt install -y ' .
                    \ a:package_name
                    \ )


    elseif a:package_manager ==# 'pacman'

        return system(
                    \ 'sudo pacman -S --noconfirm ' .
                    \ a:package_name
                    \ )


    elseif a:package_manager ==# 'dnf'

        return system(
                    \ 'sudo dnf install -y ' .
                    \ a:package_name
                    \ )


    elseif a:package_manager ==# 'yum'

        return system(
                    \ 'sudo yum install -y ' .
                    \ a:package_name
                    \ )


    elseif a:package_manager ==# 'zypper'

        return system(
                    \ 'sudo zypper --non-interactive install ' .
                    \ a:package_name
                    \ )


    elseif a:package_manager ==# 'apk'

        return system(
                    \ 'sudo apk add ' .
                    \ a:package_name
                    \ )

    endif

    return ''

endfunction


" ============================================================
" Linux：安装工具
" ============================================================

function! s:InstallLinux() abort

    let l:package_manager = s:GetLinuxPackageManager()


    " --------------------------------------------------------
    " 没有找到包管理器
    " --------------------------------------------------------

    if empty(l:package_manager)

        echoerr
                    \ '未找到支持的 Linux 包管理器。' .
                    \ '支持：apt / pacman / dnf / yum / zypper / apk'

        return 0

    endif


    echo '系统：Linux'
    echo '包管理器：' . l:package_manager
    echo ''


    " --------------------------------------------------------
    " fzf
    " --------------------------------------------------------

    if !executable('fzf')

        echo '正在安装 fzf...'

        call s:InstallLinuxTool(
                    \ l:package_manager,
                    \ 'fzf'
                    \ )

        if v:shell_error != 0

            echoerr 'fzf 安装失败。'

            return 0

        endif

    else

        echo '[OK] fzf 已安装'

    endif


    " --------------------------------------------------------
    " ripgrep
    " --------------------------------------------------------

    if !executable('rg')

        echo '正在安装 ripgrep...'

        call s:InstallLinuxTool(
                    \ l:package_manager,
                    \ 'ripgrep'
                    \ )

        if v:shell_error != 0

            echoerr 'ripgrep 安装失败。'

            return 0

        endif

    else

        echo '[OK] ripgrep 已安装'

    endif


    return 1

endfunction


" ============================================================
" 安装工具入口
" ============================================================

function! mytools#Install() abort

    echo ''
    echo '==============================================='
    echo '           Vim Tools Installer'
    echo '==============================================='
    echo ''


    let l:success = 0


    " --------------------------------------------------------
    " Windows
    " --------------------------------------------------------

    if s:IsWindows()

        echo '系统：Windows'
        echo ''

        let l:success = s:InstallWindows()


    " --------------------------------------------------------
    " Linux
    " --------------------------------------------------------

    elseif s:IsLinux()

        let l:success = s:InstallLinux()


    " --------------------------------------------------------
    " 不支持的系统
    " --------------------------------------------------------

    else

        echoerr '当前系统暂不支持。'

        return

    endif


    " --------------------------------------------------------
    " 安装结果
    " --------------------------------------------------------

    echo ''

    if l:success

        echo '安装操作完成。-由于网络问题可能会下载失败请多尝试'

    else

        echo '安装操作失败，请检查上面的错误信息。'

    endif

    echo ''


    " --------------------------------------------------------
    " 重新检查
    " --------------------------------------------------------

    call mytools#Check()

endfunction

