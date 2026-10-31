--- @class UIGuildLogView : UIBaseView
UIGuildLogView = Class(UIGuildLogView, UIBaseView)

--- @return void
--- @param model UIGuildLogModel
function UIGuildLogView:Ctor(model)
    --- @type UIGuildLogConfig
    self.config = nil
    --- @type UnityEngine_UI_VerticalLayoutGroup
    self.scrollLog = nil
    --- @type GuildLogDataInBound
    self.guildLogDataInBound = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildLogModel
    self.model = model
end

function UIGuildLogView:OnReadyCreate()
    ---@type UIGuildLogConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
    self:_InitScrollLog()
end

--- @return void
function UIGuildLogView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_log")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UIGuildLogView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIGuildLogView:_InitScrollLog()
    --- @param obj UIGuildLogItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        obj:SetData(self.config.rectContent, self.guildLogDataInBound.listGuildLog:Get(dataIndex))
    end
    self.scrollLog = UILoopScroll(self.config.scrollLog, UIPoolType.GuildLogItem, onCreateItem)
end

function UIGuildLogView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
    self.scrollLog:Resize(self.guildLogDataInBound.listGuildLog:Count())
    if self.guildLogDataInBound.listGuildLog:Count() > 0 then
        self.config.empty:SetActive(false)
    else
        self.config.empty:SetActive(true)
    end
end

function UIGuildLogView:Hide()
    UIBaseView.Hide(self)
    self.scrollLog:Hide()
end