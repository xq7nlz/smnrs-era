--- @class UIGuildChangeLeaderInGameView : UIBaseView
UIGuildChangeLeaderInGameView = Class(UIGuildChangeLeaderInGameView, UIBaseView)

--- @param model UIGuildChangeLeaderInGameModel
function UIGuildChangeLeaderInGameView:Ctor(model)
    --- @type UIGuildChangeLeaderInGameConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildChangeLeaderInGameModel
    self.model = model
    ---@type List -- CrewMemberSearchInfo
    self.listSearch = List()
    ---@type DomainInBound
    self.domainInBound = nil
end

function UIGuildChangeLeaderInGameView:InitButtons()
    self.config.backGround.onClick:AddListener(function ()
    self:OnClickBackOrClose()
    end)
end

function UIGuildChangeLeaderInGameView:InitLocalization()
 self.config.title.text = LanguageUtils.LocalizeCommon("change_crew")
end


--- @param data {callbackClose : function}
function UIGuildChangeLeaderInGameView:OnReadyShow(data)

    UIBaseView.OnReadyShow(self, data)
    self:ShowGuild()
end

function UIGuildChangeLeaderInGameView:OnReadyCreate()
    XDebug.Log("ON READY CREATE")
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()
    --- @param obj UIGuildMembersItemView
    --- @param index number
    local callBackClose = function()
        self:Hide()
    end
    local onCreateItem = function(obj, index)
        ---@type DomainsCrewMember
        local domainsCrewMember = self.listSearch:Get(index + 1)
        local data = { ["callbackCloseThis"] = callBackClose, ["domainsCrewMember"] = domainsCrewMember }
        obj:SetData(data)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIMembersItemView , onCreateItem, onCreateItem)
end



function UIGuildChangeLeaderInGameView:ShowGuild()
    ---@type DomainInBound
    self.domainInBound = zg.playerData:GetDomainInBound()
    --- @type List -- DomainsCrewMember
        self.listSearch = List()

    for _, v in pairs(self.domainInBound.domainCrewInBound.listMember:GetItems()) do
        if (v.playerId ~= PlayerSettingData.playerId) then
            self.listSearch:Add(v)
        end
    end
    self:UpdateListMember()

end

function UIGuildChangeLeaderInGameView:UpdateListMember()
    self.uiScroll.scroll.gameObject:SetActive(true)
    if self.listSearch:Count() > 0 then
        self.uiScroll:Resize(self.listSearch:Count())
       -- self.config.empty:SetActive(false)
    else
        self.uiScroll:Hide()
        --self.config.scroll.empty:SetActive(true)
    end
end
