require "lua.client.core.network.playerData.mail.MailData"

--- @class MailDataInBound
MailDataInBound = Class(MailDataInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MailDataInBound:ReadBuffer(buffer)
    ---@type boolean
    self.needRequest = true
    ---@type boolean
    self.isNotificationSystem = false
    ---@type boolean
    self.isNotificationPlayer = false

    self.isContainNewOrUnclaimedMail = buffer:GetBool()
end

--- @return List
function MailDataInBound:SetListMailJson(json)
    ---@type List
    self.listSystemMail = List()
    ---@type List
    self.listPlayerMail = List()
    self.isNotificationPlayer = false
    self.isNotificationSystem = false
    for _, jsonMail in pairs(json) do
        ---@type MailData
        local mailData = MailData.CreateByJson(jsonMail)
        if mailData:IsPlayerMail() then
            self.listPlayerMail:Add(mailData)
            if self.isNotificationPlayer == false and mailData:CanNotification() == true then
                self.isNotificationPlayer = true
            end
        else
            self.listSystemMail:Add(mailData)
            if self.isNotificationSystem == false and mailData:CanNotification() == true then
                self.isNotificationSystem = true
            end
        end
    end
end

--- @return List
function MailDataInBound:SetListTransactionMailJson(json)
    ---@type List
    self.listTransactionMail = List()
    self.isNotificationTransaction = false
    for _, jsonMail in pairs(json) do
        ---@type MailData
        local mailData = MailData.CreateByJson(jsonMail)
        self.listTransactionMail:Add(mailData)
        if self.isNotificationTransaction == false and mailData:CanNotification() == true then
            self.isNotificationTransaction = true
        end
    end
end

--- @return void
function MailDataInBound:RemoveMailFriend(friendId)
    ---@param mailData MailData
    for _, mailData in pairs(self.listPlayerMail:GetItems()) do
        if mailData.senderPlayerId == friendId then
            self.listPlayerMail:RemoveByReference(mailData)
        end
    end
end

--- @return void
function MailDataInBound:_CheckNotificationSystem()
    self.isNotificationSystem = false
    ---@param mailData MailData
    for _, mailData in pairs(self.listSystemMail:GetItems()) do
        if mailData:CanNotification() == true then
            self.isNotificationSystem = true
            break
        end
    end
end

--- @return void
function MailDataInBound:CheckEventNotificationSystem()
    self:_CheckNotificationSystem()
    RxMgr.notificationUiMail:Next()
    return self.isNotificationSystem
end

--- @return void
function MailDataInBound:_CheckNotificationPlayer()
    self.isNotificationPlayer = false
    if self.listPlayerMail ~= nil then
        ---@param mailData MailData
        for _, mailData in pairs(self.listPlayerMail:GetItems()) do
            if mailData:CanNotification() == true then
                self.isNotificationPlayer = true
                break
            end
        end
    end
end

--- @return void
function MailDataInBound:CheckEventNotificationPlayer()
    self:_CheckNotificationPlayer()
    RxMgr.notificationUiMail:Next()
    return self.isNotificationPlayer
end

--- @return boolean
function MailDataInBound:IsActiveNotification()
    return (self.isContainNewOrUnclaimedMail and
            not(self.needRequest == false and self.isNotificationSystem == false and self.isNotificationPlayer == false))
            or self.isNotificationSystem or self.isNotificationPlayer
end

--- @return boolean
function MailDataInBound:RequestMailData(callbackSuccess)
    local gzipData = nil
    local onBufferReading = function(buffer)
        gzipData = buffer:GetString(false)
    end
    local onSuccess = function()
        self.needRequest = false
        local jsonData = ClientConfigUtils.GetGunzipString(gzipData)
        self:SetListMailJson(json.decode(jsonData))
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.MAIL_GET, nil,  onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return boolean
function MailDataInBound:RequestTransactionMailData(callbackSuccess)
    local gzipData = nil
    local onBufferReading = function(buffer)
        gzipData = buffer:GetString(false)
    end
    local onSuccess = function()
        self.needRequest = false
        local jsonData = ClientConfigUtils.GetGunzipString(gzipData)
        self:SetListTransactionMailJson(json.decode(jsonData))
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.MAIL_TRANSACTION_GET, nil,  onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end