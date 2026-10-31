--- @class UIChatModel : UIBaseModel
UIChatModel = Class(UIChatModel, UIBaseModel)

--- @return void
function UIChatModel:Ctor()
    ---@type List
    self.chatData = nil
    UIBaseModel.Ctor(self, UIPopupName.UIChat, "ui_chat")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
end

--- @return ChatChanel
function UIChatModel.GetLastTimeReadChannel(channel)
    local remoteConfig = zg.playerData.remoteConfig
    if remoteConfig.lastTimeReadChatChannel == nil then
        remoteConfig.lastTimeReadChatChannel = {}
    end
    local time = remoteConfig.lastTimeReadChatChannel[tostring(channel)]
    if time == nil then
        time = zg.timeMgr:GetServerTime()
        remoteConfig.lastTimeReadChatChannel[tostring(channel)] = time
        zg.playerData:SaveRemoteConfig()
    end
    return time
end

--- @param channel ChatChanel
--- @param svTime number
function UIChatModel.SetLastTimeReadChannel(channel, svTime)
    local remoteConfig = zg.playerData.remoteConfig
    if remoteConfig.lastTimeReadChatChannel == nil then
        remoteConfig.lastTimeReadChatChannel = {}
    end
    remoteConfig.lastTimeReadChatChannel[tostring(channel)] = svTime
    zg.playerData:SaveRemoteConfig()
end
