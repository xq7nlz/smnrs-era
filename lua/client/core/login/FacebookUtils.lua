--- @class FacebookUtils
FacebookUtils = {}

--- @return void
function FacebookUtils.Login(onSuccess, onFailed)
    zg.playerData.waitingPauseAction = true
    local touchObject = TouchUtils.Spawn("FacebookUtils.Login")
    U_FacebookUtils.Login(function(status, message)
        if LogicCode.SUCCESS == status then
            onSuccess(message)
        else
            XDebug.Log(string.format("[FACEBOOK LOGIN FAILED] status[%d] message[%s]", status, tostring(message)))
            if onFailed ~= nil then
                onFailed()
            end
        end
        touchObject:Enable()
    end)

end