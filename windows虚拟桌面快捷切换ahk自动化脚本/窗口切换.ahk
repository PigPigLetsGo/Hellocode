#Persistent
SetTimer, Alert1, 500
WindowList:=[]
return
 
Alert1:
	Value := WindowList.Pop()
	if (Value=WinExist("A"))
	{
		WindowList.push(WinExist("A"))
	}
	else
	{
		if (value!="")
			WindowList.push(Value)
		WindowList.push(WinExist("A"))
	}
return
 
;最近两个窗口切换！！好用
!z::
Value:=WindowList[WindowList.Length()-1]
IfWinNotExist,ahk_id  %Value%
{
	WindowList.RemoveAt(WindowList.Length()-1)
}
 
WinActivate,ahk_id  %Value%
 
return