; 热键Ctrl + Shift + C 可以用百度搜索选中的文字
^+c::
{
 Send, ^c
 Sleep 50
 Run, https://www.google.com.hk/search?q=%clipboard%
 Return
}