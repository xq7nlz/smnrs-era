--- @class TouchObject
TouchObject = Class(TouchObject)

function TouchObject:Ctor()
    --- @type string
    self.key = nil
    --- @type boolean
    self.state = false
end

--- @param key string
function TouchObject:SetKey(key)
    assert(key)
    self.key = key
end

function TouchObject:Disable()
    if self.state == true then
        XDebug.Warning(string.format("%s => disabled"))
        return
    end
    self.state = true
    TouchUtils.Disable(self)
    --XDebug.Log(string.format("disable: (%d)%s", TouchUtils.GetNumberWaiting(), tostring(self.key)))
end

function TouchObject:Enable()
    if self.state == false then
        XDebug.Warning(string.format("%s => enabled", self.key))
        return
    end
    self.state = false
    TouchUtils.Enable(self)
    --XDebug.Log(string.format("enable: (%d)%s", TouchUtils.GetNumberWaiting(), tostring(self.key)))
end
