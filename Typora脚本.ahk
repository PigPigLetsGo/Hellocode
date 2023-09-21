#IfWinActive ahk_exe Typora.exe
{
    ^!0::addFontColor("black")
    ^!1::addFontColor("red")
    ^!2::addFontColor("blue") 
    ^!3::addFontColor("yellow")
    ^!4::addFontColor("green")
    ^!5::addFontColor("gray")

    ^!r::addFontColor2("red")
    ^!b::addFontColor2("blue") 
    ^!y::addFontColor2("yellow")
    ^!g::addFontColor2("green")

    !b::addFontColor1("blink")
    !s::addFontColor1("solid")
    !w::addFontColor1("wavy")
    !d::addBlock("danger")
}
addFontColor(color){
    clipboard := "" 
    Send {ctrl down}c{ctrl up} 
    ; SendInput {Text} 
    SendInput {TEXT}<font title='%color%'>
    SendInput {ctrl down}v{ctrl up}
    If(clipboard = ""){
        SendInput {TEXT}</font>
    }else{
        SendInput {TEXT}</ 
    }
}
addFontColor1(color){
    clipboard := "" 
    Send {ctrl down}c{ctrl up} 
    ; SendInput {Text} 
    SendInput {TEXT}<span alt='%color%'>
    SendInput {ctrl down}v{ctrl up}
    If(clipboard = ""){
        SendInput {TEXT}</span>
    }else{
        SendInput {TEXT}</ 
    }
}
addFontColor2(color){
    clipboard := "" 
    Send {ctrl down}c{ctrl up} 
    ; SendInput {Text} 
    SendInput {TEXT}<font color='%color%'>
    SendInput {ctrl down}v{ctrl up}
    If(clipboard = ""){
        SendInput {TEXT}</font>
    }else{
        SendInput {TEXT}</ 
    }
}
addBlock(color){
    clipboard := "" 
    Send {ctrl down}c{ctrl up} 
    ; SendInput {Text} 
    SendInput {TEXT}<blockquote alt='%color%'>
    SendInput {ctrl down}v{ctrl up}
    If(clipboard = ""){
        SendInput {TEXT}</blockquote>
    }else{
        SendInput {TEXT}</ 
    }
}
