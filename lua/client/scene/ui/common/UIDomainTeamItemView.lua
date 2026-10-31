--- @class UIDomainTeamItemView : IconView
UIDomainTeamItemView = Class(UIDomainTeamItemView, IconView)

--- @return void
function UIDomainTeamItemView:Ctor()
    self:Init()
    --- @type List
    self.listHero = List()
    IconView.Ctor(self)
end

--- @return void
function UIDomainTeamItemView:Init()
    ---@type OtherPlayerInfoInBound
    self.data = nil
    self.callbackUnblock = nil
end

--- @return void
function UIDomainTeamItemView:SetPrefabName()
    self.prefabName = 'domain_team_item'
    self.uiPoolType = UIPoolType.UIDomainTeamItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIDomainTeamItemView:SetConfig(transform)
    assert(transform)
    ---@type UIDomainTeamItemConfig
    self.config = UIBaseConfig(transform)

    self.config.iconButtonX.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickKick()
    end)

    self.config.iconButtonSwapLeader.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeLeader()
    end)

    self.config.iconButtonChangeTeam.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeTeam()
    end)
end

--- @return void
function UIDomainTeamItemView:SetData(data, callbackKick, callbackChangeLeader, callbackChangeTeam)
    self.config.iconButtonSwapLeader.gameObject:SetActive(false)
    self.config.iconButtonX.gameObject:SetActive(false)
    self.config.iconButtonChangeTeam.gameObject:SetActive(data.playerId == PlayerSettingData.playerId)

    ---@type DomainsCrewMember
    self.domainsCrewMember = data

    self.callbackKick = callbackKick
    self.callbackChangeLeader = callbackChangeLeader
    self.callbackChangeTeam = callbackChangeTeam
    self.config.textUserName.text = data.playerName
    self:UpdateTeam()

    local leaderId = zg.playerData:GetDomainInBound().domainCrewInBound.leaderId
    self.config.iconGuildLeader.gameObject:SetActive(leaderId == data.playerId)
    if leaderId == PlayerSettingData.playerId then
        if PlayerSettingData.playerId ~= data.playerId then
            self.config.iconButtonSwapLeader.gameObject:SetActive(true)
            self.config.iconButtonX.gameObject:SetActive(true)
        end
    end
end

function UIDomainTeamItemView:UpdateTeam()
    self:ReturnPoolListHero()
    --- @param heroResource HeroResource
    for i, heroResource in ipairs(self.domainsCrewMember.listHero:GetItems()) do
        ---@type HeroIconView
        local heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.heroDemo)
        ---@type HeroIconData
        local heroIconData = HeroIconData.CreateByHeroResource(heroResource)
        heroIconView:SetIconData(heroIconData)
        heroIconView:SetSize(150, 150)
        heroIconView:AddListener(function ()
            local overrideStatDict = ClientConfigUtils.GetStatHero(heroResource)
            PopupUtils.ShowPreviewHeroInfo(heroResource, overrideStatDict)
        end)
        self.listHero:Add(heroIconView)
    end
end

function UIDomainTeamItemView:ReturnPoolListHero()
    if self.listHero ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listHero:GetItems()) do
            v:ReturnPool()
        end
        self.listHero:Clear()
    end
end

--- @return void
function UIDomainTeamItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolListHero()
end

--- @return void
function UIDomainTeamItemView:OnClickKick()
    if self.callbackKick ~= nil then
        self.callbackKick(self.domainsCrewMember)
    end
end

--- @return void
function UIDomainTeamItemView:OnClickChangeLeader()
    if self.callbackChangeLeader ~= nil then
        self.callbackChangeLeader(self.domainsCrewMember)
    end
end

--- @return void
function UIDomainTeamItemView:OnClickChangeTeam()
    if self.callbackChangeTeam ~= nil then
        self.callbackChangeTeam(self.domainsCrewMember)
    end
end

return UIDomainTeamItemView