#IfWinActive ahk_class CabinetWClass
$MButton::
WinGetClass,sClass,A
;;MsgBox $%sClass%$
if (sClass="CabinetWClass") {
Send, {BS}
}
return
#IfWinActive