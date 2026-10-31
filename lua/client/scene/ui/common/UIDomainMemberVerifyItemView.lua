--- @class UIDomainMemberVerifyItemView : IconView
UIDomainMemberVerifyItemView = Class(UIDomainMemberVerifyItemView, IconView)

--- @return void
function UIDomainMemberVerifyItemView:Ctor()
    --- @type List
    self.listHero = List()
    IconView.Ctor(self)
end

--- @return void
function UIDomainMemberVerifyItemView:SetPrefabName()
    self.prefabName = 'domain_member_verify_item'
    self.uiPoolType = UIPoolType.UIDomainMemberVerifyItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIDomainMemberVerifyItemView:SetConfig(transform)
    assert(transform)
    ---@type UIDomainMemberVerifyItemConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonDelete.onClick:AddListener(function()
        self:OnClickDelete()
    end)
    self.config.buttonApply.onClick:AddListener(function()
        self:OnCLickAccept()
    end)
end

--- @return void
function UIDomainMemberVerifyItemView:SetData(data, callbackDelete, callbackAccept, callbackFailed)
    ---@type CrewApplication
    self.data = data
    self.callbackDelete = callbackDelete
    self.callbackAccept = callbackAccept
    self.callbackFailed = callbackFailed
    self.config.textUserName.text = self.data.playerName
    self:UpdateTeam()
end

function UIDomainMemberVerifyItemView:UpdateTeam()
    self:ReturnPoolListHero()
    ---@param v HeroResource
    for i, v in ipairs(self.data.listHero:GetItems()) do
        ---@type HeroIconView
        local heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconHero)
        ---@type HeroIconData
        local heroIconData = HeroIconData.CreateInstance(ResourceType.Hero, v.heroId, v.heroStar,
                v.heroLevel, ClientConfigUtils.GetFactionIdByHeroId(v.heroId), nil)
        heroIconView:SetIconData(heroIconData)
        heroIconView:SetSize(150, 150)
        self.listHero:Add(heroIconView)

        heroIconView:AddListener(function()
            local overrideStatDict = ClientConfigUtils.GetStatHero(v)
            PopupUtils.ShowPreviewHeroInfo(v, overrideStatDict)
        end)
    end
end

function UIDomainMemberVerifyItemView:OnClickDelete()
    local onSuccess = function()
        if self.callbackDelete ~= nil then
            self.callbackDelete(self.data.playerId)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if self.callbackFailed then
            self.callbackFailed()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_MANAGE,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.data.playerId, PutMethod.Bool, false),
            onSuccess, onFailed)
end

function UIDomainMemberVerifyItemView:OnCLickAccept()
    local onSuccess = function()
        if self.callbackAccept ~= nil then
            self.callbackAccept(self.data.playerId)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if self.callbackFailed then
            self.callbackFailed()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_MANAGE,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.data.playerId, PutMethod.Bool, true),
            onSuccess, onFailed)
end

function UIDomainMemberVerifyItemView:ReturnPoolListHero()
    if self.listHero ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listHero:GetItems()) do
            v:ReturnPool()
        end
        self.listHero:Clear()
    end
end

--- @return void
function UIDomainMemberVerifyItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolListHero()
end

return UIDomainMemberVerifyItemView