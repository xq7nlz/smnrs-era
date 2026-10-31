require "lua.client.log.QueuedLog"
require "lua.client.log.LogType"
require "lua.client.log.ServerLogMessage"

--- @class ServerLogger
ServerLogger = Class(ServerLogger)

function ServerLogger:Ctor()
    ---@type number
    self.DELAY_SEND_MESSAGE_TO_SERVER = 3
    --- @type List
    self.logCheckList = List()
    ---@type List
    self.logs = List()
    ---@type number
    self.lastLog = os.clock() - self.DELAY_SEND_MESSAGE_TO_SERVER
    ---@type boolean
    self.isDelayLog = false
    ---@type string
    self.route = "exception/log"
    ---@type string
    self.routeMulti = "exception/log-multi"
    ---@type string
    self.contentTypeKey = "Content-Type"
    ---@type string
    self.contentTypeValue = "application/json"
    ---@type string
    self.requestFormat = "http://%s:%d/%s "
    ---@type string
    self.url = string.format(self.requestFormat, NetConfig.logServerIP, NetConfig.logServerPort, self.route)
    self.urlMulti = string.format(self.requestFormat, NetConfig.logServerIP, NetConfig.logServerPort, self.routeMulti)
end

---@return void
function ServerLogger:InitListenLogMessage()
    local onReceiveLog = function(logString, stackTrace, type)
        self:OnReceiveLog(logString, stackTrace, type)
    end
    U_Application.logMessageReceived('+', onReceiveLog)
end

---@param logString string
---@param stackTrace string
---@param type UnityEngine_LogType
---@return void
function ServerLogger:OnReceiveLog(logString, stackTrace, type)
    if self.logCheckList:IsContainValue(logString) == false then
        self.logCheckList:Add(logString)
        self:OnReceiveLogFromUnity(logString, stackTrace, type)
    end
end

---@param logString string
---@param stackTrace string
---@param type UnityEngine_LogType
---@return void
function ServerLogger:OnReceiveLogFromUnity(logString, stackTrace, type)
    if type == U_LogType.Error or type == U_LogType.Exception then
        self:LogToServer(logString, stackTrace, type)
    end
end

---@param logString string
---@param stackTrace string
---@param type UnityEngine_LogType
---@return void
function ServerLogger:LogToServer(logString, stackTrace, type)
    if type == U_LogType.Error then
        type = LogType.Error
    elseif type == U_LogType.Exception then
        type = LogType.Exception
    end
    self:QueueLog(logString, stackTrace, type)
end

---@param logString string
---@param stackTrace string
---@param type UnityEngine_LogType
---@return void
function ServerLogger:QueueLog(logString, stackTrace, type)
    local queueLog = QueuedLog(logString, stackTrace, type)
    self.logs:Add(queueLog)
    if self:CheckCanLog() then
        self:LogExceptionToServer()
    elseif not self.isDelayLog then
            self:AutoLogToServer()
    end
end
---@return void
function ServerLogger:AutoLogToServer()
    Coroutine.start(function()
        coroutine.waitforseconds(self.DELAY_SEND_MESSAGE_TO_SERVER)
        self:LogMultiExceptionToServer()
        self.isDelayLog = false
    end)
end

function ServerLogger:CheckCanLog()
    if (os.time() - self.lastLog > self.DELAY_SEND_MESSAGE_TO_SERVER) then
        return true
    end
    return false
end

function ServerLogger:LogExceptionToServer()
    self.lastLog = os.clock()
    ---@type QueuedLog
    local logMessage = self.logs:Get(1)
    local serverLogMessage = ServerLogMessage(logMessage)
    local content = serverLogMessage:ToJson()
    U_GameUtils.PostRequest(self.url, content)
    self.logs:Clear()
end

function ServerLogger:LogMultiExceptionToServer()
    self.lastLog = os.clock()
    U_GameUtils.PostRequest(self.urlMulti, ServerLogMessage.ListToJson(self.logs))
    self.logs:Clear()
end

serverLog = ServerLogger()
