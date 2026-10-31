---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiTrainingTeam.UISlotTrainingTeamConfig"

--- @class UISlotTrainingTeamView
UISlotTrainingTeamView = Class(UISlotTrainingTeamView)

--- @return void
--- @param transform UnityEngine_Transform
function UISlotTrainingTeamView:Ctor(transform, slot)
    ---@type UISlotTrainingTeamConfig
    ---@type UISlotTrainingTeamConfig
    self.config = UIBaseConfig(transform)
    self.config.button.onClick:AddListener(function ()
        self:OnClickSlot()
    end)
    ---@type HeroResource
    self.heroResource = nil
    ---@type HeroIconView
    self.heroIconView = nil
    ---@type function
    self.callbackClickSlot = nil
    ---@type number
    self.slot = slot
end

--- @return void
--- @param isLock boolean
function UISlotTrainingTeamView:SetLock(isLock)
    self.config.iconBlock:SetActive(isLock)
    self.config.progressParent:SetActive(false)
    self.config.textLeveling.gameObject:SetActive(false)
end

--- @return void
--- @param isActive boolean
function UISlotTrainingTeamView:SetActiveProgress(isActive)
    if isActive == true then
        self.config.progressParent:SetActive(true)
    else
        self.config.progressParent:SetActive(false)
        self.config.textLeveling.gameObject:SetActive(false)
    end
end

--- @return void
--- @param heroResource HeroResource
function UISlotTrainingTeamView:SetHeroResource(heroResource)
    self.heroResource = heroResource
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconHero)
        self.heroIconView:EnableRaycast(false)
    end
    self.heroIconView:SetIconData(HeroIconData.CreateByHeroResource(heroResource))
end

--- @return void
--- @param level number
function UISlotTrainingTeamView:SetLevel(level)
    if level > 0 then
        self.config.textLeveling.gameObject:SetActive(true)
        self.config.textLeveling.text = string.format("+%s", level)
    else
        self.config.textLeveling.gameObject:SetActive(false)
    end
end

--- @return void
--- @param active boolean
function UISlotTrainingTeamView:ActiveEffectTraining(active)
    if self.heroIconView ~= nil then
        self.heroIconView:ActiveEffectHeroTraining(active)
    end
end

--- @return void
--- @param maxTime number
--- @param time number
function UISlotTrainingTeamView:SetProgress(maxTime, time)
    local progress = MathUtils.Clamp((maxTime - time)/ maxTime, 0, 1)
    self.config.progressParent:SetActive(true)
    if progress < 1 then
        self.config.progress.fillAmount = progress
        self.config.textTime.gameObject:SetActive(true)
        self.config.progressFull:SetActive(false)
        self.config.textTime.text = TimeUtils.SecondsToClock(time)
    elseif time == 0 then
        self.config.progressParent:SetActive(false)
        --self.config.textTime.gameObject:SetActive(false)
        --self.config.progressFull:SetActive(true)
    end
end

--- @return void
function UISlotTrainingTeamView:ReturnPool()
    self.heroResource = nil
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

--- @return void
function UISlotTrainingTeamView:OnClickSlot()
    if self.callbackClickSlot ~= nil then
        self.callbackClickSlot(self)
    end
end