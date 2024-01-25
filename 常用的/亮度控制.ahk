; ================= 亮度管理
class Config {
    static lightnessInitOnStart := true
}
 
class Constant {
    ; 屏幕亮度
    static lightness_low := 5
    static lightness_normal := 30
}
 
if Config.lightnessInitOnStart
    MonitorBrightness.cur := MonitorBrightness.GetBrightness()
 
^Home:: MonitorBrightness.BrightnessMgr(MonitorBrightness._Inc, 2)
^End:: MonitorBrightness.BrightnessMgr(MonitorBrightness._Desc, 2)
^SC046:: MonitorBrightness.BrightnessMgr(MonitorBrightness._Toggle) ; ^scrollock
 
; class-desc: tooltip manager
class Tip {
    ; debounce
    static timer := false
 
    ; display tooltip and clear after the specified seconds
    static ShowTip(raw, x := 100, y := 50, weight := 1, duration := 4000) {
        ToolTip raw, x, y, weight
        Tip.SetTimerRemoveToolTip(weight, duration)
    }
 
    ; remove the specified weight after some time
    static SetTimerRemoveToolTip(weight := 1, time := 4000) {
        if Tip.timer {
            ; clear prior timer
            SetTimer Tip.timer, 0
        }
        ; bind the timer
        Tip.timer := ObjBindMethod(this, 'RemoveToolTip', weight)
        ; start new timer
        SetTimer Tip.timer, -time
    }
 
    static RemoveToolTip(weight)
    {
        ToolTip , , , weight
    }
}
 
class MonitorBrightness {
    ; class-desc: 屏幕亮度获取及设置
    static cur := 0
 
    static Update(val) {
        this.cur := val
    }
 
    static GetBrightness() {
        fields := ShellRun.RunWaitOne('WMIC /NAMESPACE:\\root\wmi PATH WmiMonitorBrightness WHERE "Active=TRUE" GET /value')
        match := 'CurrentBrightness='
        curLight := SubStr(fields, InStr(fields, match) + StrLen(match), 2)
        res := +Rtrim(curLight, '`r`n')
        return res
    }
 
    static _Inc(val) {
        if this.cur + val > 100 {
            this._ShowLightTip()
            return this.cur
        }
        return this.cur + val
    }
 
    static _Desc(val) {
        if this.cur - val <= 0 {
            this._ShowLightTip()
            return this.cur
        }
        return this.cur - val
    }
 
    static _Toggle() {
        return this.cur < 15 ? Constant.lightness_normal : Constant.lightness_low
    }
 
    static BrightnessMgr(action, param := unset) {
        if !Config.lightnessInitOnStart and !this.cur
            this.GetBrightness()
        cur := action(this, IsSet(param) ? param : unset)
        Run(A_ComSpec ' /c "WMIC /NAMESPACE:\\root\wmi PATH WmiMonitorBrightnessMethods WHERE "Active=TRUE" CALL WmiSetBrightness Brightness=' cur ' Timeout=0"', , 'Hide')
        this.Update(cur)
        this._ShowLightTip()
    }
 
    static _ShowLightTip() {
        if this.cur >= 10
            dili := '  '
        else
            dili := '   '
        raw := '+===+`n'
            . ' |' dili this.cur dili '|`n'
            . '+===+`n'
        Tip.ShowTip(raw)
    }
}
 
class ShellRun {
    static RunWaitOne(command) {
        shell := ComObject("WScript.Shell")
        ; 通过 cmd.exe 执行单条命令
        exec := shell.Exec(A_ComSpec " /C " command)
        ; 读取并返回命令的输出
        return exec.StdOut.ReadAll()
    }
 
    static RunWaitMany(commands) {
        shell := ComObject("WScript.Shell")
        ; 打开 cmd.exe 禁用命令回显
        exec := shell.Exec(A_ComSpec " /Q /K echo off")
        ; 发送并执行命令, 使用新行分隔
        exec.StdIn.WriteLine(commands "`nexit")  ; 总是在最后退出!
        ; 读取并返回所有命令的输出
        return exec.StdOut.ReadAll()
    }
}