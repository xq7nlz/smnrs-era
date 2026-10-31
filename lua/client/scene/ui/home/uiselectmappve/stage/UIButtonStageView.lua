---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSelectMapPVE.stage.UIButtonStageConfig"

--- @class UIButtonStageView : IconView
UIButtonStageView = Class(UIButtonStageView, IconView)

--- @return void
function UIButtonStageView:Ctor()
    --- @type UIButtonStageConfig
    self.config = nil
    ---@type number
    self.stageId = nil
    ---@type number
    self.difficult = nil
    ---@type number
    self.map = nil
    ---@type number
    self.stage = nil
    ---@type HeroIconView
    self.heroIconView = nil
    --- @type string
    self.textColor = UIUtils.white
    IconView.Ctor(self)
end

--- @return void
function UIButtonStageView:SetPrefabName()
    self.prefabName = 'stage_icon_info'
    self.uiPoolType = UIPoolType.UIButtonStageView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIButtonStageView:SetConfig(transform)
    assert(transform)
    --- @type UIButtonStageConfig
    ---@type UIButtonStageConfig
    self.config = UIBaseConfig(transform)
end

function UIButtonStageView:InitLocalization()
    self.config.textClear.text = LanguageUtils.LocalizeCommon("map_cleared")
end

--- @return void
--- @param stageId number
function UIButtonStageView:SetStageId(stageId)
    self.stageId = stageId
    self.difficult, self.map, self.stage = ClientConfigUtils.GetIdFromStageId(self.stageId)
    self:_ShowHeroFragmentStage(stageId)
    self:DetectStageBoss()
end

--- @return void
function UIButtonStageView:DetectStageBoss()
    ---@type DefenderTeamData
    local dataStage = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfigById(self.stageId)
    self.config.bgBoss:SetActive(dataStage:HasBoss())
end

--- @return void
function UIButtonStageView:_ShowHeroFragmentStage(stage)
    ---@type List
    local reward = ResourceMgr.GetCampaignDataConfig():GetCampaignRewardById(stage)
    local itemHeroFragment = nil
    ---@param v ItemIconData
    for _, v in pairs(reward:GetItems()) do
        if v.type == ResourceType.HeroFragment then
            itemHeroFragment = v
            break
        end
    end
    if itemHeroFragment ~= nil then
        if self.heroIconView == nil then
            self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.heroIcon)
        end
        self.heroIconView:SetIconData(itemHeroFragment)
        self.heroIconView:EnableRaycast(false)
        self.config.hero:SetActive(true)
    else
        self.config.hero:SetActive(false)
    end
end

--- @return void
---@param func function
function UIButtonStageView:AddListener(func)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function UIButtonStageView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function UIButtonStageView:SetEnabled(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
end

--- @return void
function UIButtonStageView:SetState()
    local campaignData = zg.playerData:GetCampaignData()
    self.config.textClear.gameObject:SetActive(false)
    self.config.text.gameObject:SetActive(true)
    self.textColor = UIUtils.white
    if self.stageId > campaignData.stageNext then
        self.config.lock:SetActive(true)
        self.config.current:SetActive(false)
        self.config.stageNew:SetActive(false)
        UIUtils.SetInteractableButton(self.config.button, false)
        self.config.text.gameObject:SetActive(false)
    elseif self.stageId == campaignData.stageIdle then
        self.config.lock:SetActive(false)
        self.config.current:SetActive(true)
        self.config.stageNew:SetActive(false)
        UIUtils.SetInteractableButton(self.config.button, true)
        self.config.textClear.gameObject:SetActive(true)
    elseif self.stageId == campaignData.stageNext then
        self.config.lock:SetActive(false)
        UIUtils.SetInteractableButton(self.config.button, true)
        local levelRequired = ResourceMgr.GetCampaignDataConfig():GetLevelRequired(self.stageId)
        if levelRequired == nil or zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level >= levelRequired then
            self.config.lock:SetActive(false)
            self.config.current:SetActive(false)
            self.config.stageNew:SetActive(false) -- bo noti
            self:ActiveEffectNextStage(true)
        else
            self.config.lock:SetActive(true)
            self.config.current:SetActive(false)
            self.config.stageNew:SetActive(false)
            self.config.text.gameObject:SetActive(false)
        end
    else
        self.config.lock:SetActive(false)
        self.config.current:SetActive(false)
        self.config.stageNew:SetActive(false)
        UIUtils.SetInteractableButton(self.config.button, false)
        self.config.textClear.gameObject:SetActive(true)
        self.textColor = UIUtils.color3
    end
    self.config.text.text = string.format("<color=#%s>%s-%s</color>", self.textColor, self.map, self.stage)
end

--- @return void
--- @param isActive boolean
function UIButtonStageView:ActiveEffectNextStage(isActive)
    if isActive == true then
        if self.effectIdle == nil then
            ---@type UnityEngine_GameObject
            self.effectIdle = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.StageIdle, self.config.effectNewStage)
            self.effectIdle.transform.localEulerAngles = U_Vector3.zero
            self.effectIdle.gameObject:SetActive(true)
        end
        self.effectIdle.transform:SetAsFirstSibling()
    elseif isActive == false then
        if self.effectIdle ~= nil then
            SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.StageIdle, self.effectIdle)
            self.effectIdle = nil
        end
    end
end

--- @return void
function UIButtonStageView:ReturnPool()
    IconView.ReturnPool(self)
    self:ActiveEffectNextStage(false)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

return UIButtonStageView