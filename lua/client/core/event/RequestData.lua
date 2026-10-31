--- @class RequestData
RequestData = Class(RequestData)
--- @return void
function RequestData:Ctor(opCode, outBound, callback, showWaiting)
    --- @type OpCode
    self.opCode = opCode
    --- @type OutBound
    self.outBound = outBound
    --- @type function
    self.callback = callback
    --- @type boolean
    self.showWaiting = showWaiting
end

--- @return void
function RequestData:Request()
    --XDebug.Log(string.format("opCode: %d, show: %s", self.opCode, tostring(self.showWaiting)))
    NetworkUtils.Request(self.opCode, self.outBound, self.callback, self.showWaiting)
end