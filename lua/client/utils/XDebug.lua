--- @class XDebug
XDebug = {}

--- @return string
--- @param content
function XDebug.Log(content)
    if zgUnity.IsTest or IS_EDITOR_PLATFORM then
        print(string.format("[INFO]%s \n\t%s", content, debug.traceback()))
    end
end

--- @return string
--- @param content
function XDebug.Warning(content)
    if zgUnity.IsTest or IS_EDITOR_PLATFORM then
        print(string.format("[WARNING]%s \n\t%s", content, debug.traceback()))
    end
end

--- @return string
--- @param content
function XDebug.Error(content)
    if zgUnity.IsTest or IS_EDITOR_PLATFORM then
        print(string.format("[ERROR]%s \n\t%s", content, debug.traceback()))
    end
    if serverLog ~= nil then
        serverLog:OnReceiveLog(content, debug.traceback(), U_LogType.Error)
    end
end

--- @return string
--- @param func function
function XDebug.ErrorFunction(func)
    local result, message = pcall(func)
    if result == false then
        print(string.format("[ERROR FUNCTION]%s", message))
    end
end