SwitchState_paste := 0  ; 初始关闭拖动复制模式

; 启用/关闭拖动复制模式
^!+c::  
SwitchState_paste := !SwitchState_paste  ; 切换开关状态
if (SwitchState_paste)  
    MsgBox, 启用 === drag复制模式 ===  
else  
    MsgBox, 关闭 === drag复制模式 ===  
return  

; 鼠标拖动检测及复制功能
~LButton::  
if (!SwitchState_paste)  ; 如果拖动复制模式未启用，直接返回
    return  

MouseGetPos, startX, startY  ; 记录鼠标按下时的位置
KeyWait, LButton  ; 等待鼠标左键释放
MouseGetPos, endX, endY  ; 获取鼠标释放时的位置

; 计算拖动的距离
deltaX := Abs(endX - startX)
deltaY := Abs(endY - startY)

if (deltaX > 10 || deltaY > 10)  ; 拖动超过10像素（X或Y轴）
{
    Send, ^c  ; 触发 Ctrl+C 复制操作
    ToolTip, 内容已复制！  ; 显示复制提示
    SetTimer, RemoveToolTip, -100  ; 2秒后清除提示
}
return  

; 清除ToolTip提示
RemoveToolTip:  
    ToolTip  
return  
