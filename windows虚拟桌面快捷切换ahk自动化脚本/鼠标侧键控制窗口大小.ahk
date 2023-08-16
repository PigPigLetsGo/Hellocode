
xbutton2::
    ToolTip,
    ;设置鼠标坐标模式为相对屏幕
    CoordMode, Mouse, Screen
    MouseGetPos, mX0, mY0 , hwnd
    IfWinExist, ahk_id %hwnd%
    {
        ;获取初始窗口位置
        WinGetPos, wX0, wY0
        WinActivate, ahk_id %hwnd%
    }
    Else
        Return
    Loop{
        GetKeyState, mState, xbutton2, P 
        if mState = U        
         {
            ToolTip 
            break
        }

        ;获取当前鼠标位置
        MouseGetPos, mX, mY
        SetWinDelay, -1
        WinMove, ahk_id %hwnd%,  , wX0+mX-mX0, wY0+mY-mY0
    }
Return

;========================================================

xbutton1::
setWinDelay,0
CoordMode,mouse,Screen

MouseGetPos,mx1,my1
WinGetPos,winx,winy,winw,winh,A
	loop{
	
		;GetKeyState,vstate,LAlt,p
		GetKeyState,vstate,xbutton1,p
		
		if vstate=U
			break		
		
		MouseGetPos,mx2,my2
		
		xx=% winw + mx2 - mx1
		yy=% winh + my2 - my1
		winmove,A,,%winx%,%winy%,%xx%,%yy%
		sleep,30
	}
Return


;========================================================



