--- @class GoogleUtils
PlatformLoginUtils = {}

--- @return void
function PlatformLoginUtils.Login(onSuccess, onFailed)
    zg.playerData.waitingPauseAction = true
    local touchObject = TouchUtils.Spawn("PlatformLoginUtils.Login")
   U_PlatformLoginUtils.Login(function(status, message)
        if LogicCode.SUCCESS == status then
            onSuccess(message)
        else
            XDebug.Log(string.format("[Platform LOGIN FAILED] status[%d] message[%s]", status, tostring(message)))
            if onFailed ~= nil then
                onFailed()
            end
        end
        touchObject:Enable()
    end)

end