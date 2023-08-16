!a::
CoordMode, Mouse, Screen
MouseGetPos, xpos, ypos
if (xpos <= A_ScreenWidth) and (ypos <= A_ScreenHeight)
{
    MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
}else {
	MouseMove, (A_ScreenWidth + 1920), 1080
}
return