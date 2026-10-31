require "lua.client.core.network.handShake.HandShakeOutBound"

--- @class HandShake
HandShake = Class(HandShake)

local SHARED_SECRET_DATA = {
    "Ag6MeZ7QNn2wG8xF",
    "Res5gBQu46qnAZK2",
    "tPkpGdxCjAZ2hzrU",
    "A7FWzSE2ucTQjNxV",
    "bzVuBgaE6r3Kytpv",
    "vRhuA7N8CKjaSy6E",
    "vq4QyG8YcFRbU63d",
    "qXzxfA3Q2gKw5E9p",
    "UnedHpxCrfFQ9y8L",
    "QfzpD9T6jbSdx5hN",
}

function HandShake:Ctor()
    --- @type string
    self.sharedSecret = nil
    --- @type string
    self.sessionSecret = nil
    --- @type function
    self.onComplete = nil
    --- @type LogicCode
    self.logicCode = LogicCode.SUCCESS
end

function HandShake:InitListener()
    zg.netDispatcherMgr:AddListener(OpCode.HAND_SHAKE, EventDispatcherListener(nil, function(buffer)
        self:DoPhase0(buffer)
    end))
end

--- @param buffer UnifiedNetwork_ByteBuf
function HandShake:DoPhase0(buffer)
    assert(buffer:GetByte() == 0)
    self.sharedSecret = SHARED_SECRET_DATA[buffer:GetShort()] -- secret number
    NetworkUtils.Request(OpCode.HAND_SHAKE, HandShakeOutBound(self.sharedSecret), function(buffer)
        self:DoPhase2(buffer)
    end)
end

--- @param buffer UnifiedNetwork_ByteBuf
function HandShake:DoPhase2(buffer)
    assert(buffer:GetByte() == 2)
    self.logicCode = buffer:GetShort()
    if self.logicCode == LogicCode.SUCCESS then
        self.sessionSecret = buffer:GetString(false)
        zg.timeMgr:SetServerTime(buffer:GetLong()) -- server time
        RxMgr.handShakeComplete:Next()
    else
        XDebug.Warning(string.format("Logic code failed: %d", self.logicCode))
        if self.logicCode == LogicCode.HANDSHAKE_CSV_HASH_MISMATCHED
                or self.logicCode == LogicCode.HANDSHAKE_NUMBER_CSV_FILE_MISMATCHED then
            NetworkUtils.ResetAllSetUp()
            PopupUtils.ShowPopupMaintenance(nil)
        else
            PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeLogicCode(self.logicCode), function()
                U_Application.Quit()
            end, nil, false, function()
            end)
        end
    end
end

--- @return boolean
function HandShake:IsComplete()
    return self.sessionSecret ~= nil
end