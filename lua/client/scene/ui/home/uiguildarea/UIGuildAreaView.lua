require "lua.client.scene.ui.home.uiGuildArea.GuildAreaWorld"

--- @class UIGuildAreaView : UIBaseView
UIGuildAreaView = Class(UIGuildAreaView, UIBaseView)

--- @return void
--- @param model UIGuildAreaModel
function UIGuildAreaView:Ctor(model)
    --- @type UIGuildAreaConfig
    self.config = nil
    --- @type GuildAreaWorld
    self.guildAreaWorld = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildAreaModel
    self.model = model
end

--- @return void
function UIGuildAreaView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.guildAreaWorld = GuildAreaWorld(self.config.guildAreaWorld, self)

    self:InitButtonListener()
end

function UIGuildAreaView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIGuildAreaView:InitLocalization()
    if self.guildAreaWorld ~= nil then
        self.guildAreaWorld:InitLocalization()
    end
end

--- @return void
function UIGuildAreaView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    PopupMgr.ShowPopup(UIPopupName.UIMainArea)
end

--- @return void
function UIGuildAreaView:OnReadyShow(result)
    self.guildAreaWorld:OnShow()
    self.serverNotificationListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotification))
end

--- @return void
function UIGuildAreaView:Hide()
    UIBaseView.Hide(self)
    self.guildAreaWorld:OnHide()

    if self.serverNotificationListener ~= nil then
        self.serverNotificationListener:Unsubscribe()
        self.serverNotificationListener = nil
    end
end

function UIGuildAreaView:OnDestroy()
    self.guildAreaWorld:OnDestroy()
end

function UIGuildAreaView:OnClickGuildHall()
    self:OnReadyHide()
    PopupMgr.ShowPopup(UIPopupName.UIGuildMain)
end

function UIGuildAreaView:OnClickGuildDailyBoss()
    self:OnReadyHide()
    PopupMgr.ShowPopup(UIPopupName.UIGuildDailyBoss)
end

function UIGuildAreaView:OnClickGuildDungeon()
    local guildDungeonModel = zg.playerData:GetEvents():GetEvent(EventTimeType.GUILD_DUNGEON)
    if guildDungeonModel ~= nil and guildDungeonModel:IsOpening() then
        self:OnReadyHide()
        PopupMgr.ShowPopup(UIPopupName.UIGuildDungeon)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
    end
end

function UIGuildAreaView:OnClickGuildShop()
    self:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMarket,
            { ["marketType"] = MarketType.GUILD_MARKET,
              ["callbackClose"] = function()
                  PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIMarket)
              end
            }, self.model.uiName)
end

function UIGuildAreaView:OnServerNotification()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_was_kicked"))
    self:OnReadyHide()
    PopupMgr.ShowPopup(UIPopupName.UIMainArea)
end

function UIGuildAreaView:OnClickChangeFormation()

end