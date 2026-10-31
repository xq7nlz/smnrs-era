---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.SkillHeroConfig"

--- @class SkillHeroView : IconView
SkillHeroView = Class(SkillHeroView, IconView)

--- @return void
function SkillHeroView:Ctor(component)
    IconView.Ctor(self)
    ---@type number
    self.heroId = nil
    ---@type number
    self.skillId = nil
    ---@type number
    self.lv = nil
    ---@type number
    self.class = nil
    ---@type number
    self.star = nil
    ---@type number
    self.tier = nil
end

--- @return void
function SkillHeroView:InitTrigger(onPointEnter, onPointExit)
    --XDebug.Log("SkillHeroView:SetConfig")
    UIUtils.SetTrigger(self.config.eventTrigger, onPointEnter, onPointExit, onPointExit, onPointExit, onPointExit)
end

--- @return void
function SkillHeroView:RemoveTrigger()
    self.config.eventTrigger.triggers:Clear()
end

--- @return void
function SkillHeroView:SetPrefabName()
    self.prefabName = 'skill_info'
    self.uiPoolType = UIPoolType.SkillHeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function SkillHeroView:SetConfig(transform)
    if transform ~= nil then
        --- @type SkillHeroConfig
        ---@type SkillHeroConfig
        self.config = UIBaseConfig(transform)
    else
        XDebug.Error("transform is nil")

    end
end

--- @return void
--- @param heroId number
--- @param skillId number
function SkillHeroView:SetData(heroId, skillId, lv, activeEffectUnlock, activeEffectUpgrade)
    self.heroId = heroId
    self.skillId = skillId
    self.lv = lv
    self.config.gameObject:SetActive(true)
    if self.skillId ~= nil then
        self.config.frameEmpty.gameObject:SetActive(false)
        if self.skillId == 1 then
            self.config.frame.gameObject:SetActive(false)
            self.config.frameActive.gameObject:SetActive(true)
        else
            self.config.frame.gameObject:SetActive(true)
            self.config.frameActive.gameObject:SetActive(false)
        end
        self.config.txtLv.text = tostring(lv)
        self.config.skillIcon.gameObject:SetActive(true)
        self.config.skillIcon.sprite = ResourceLoadUtils.LoadSkillIcon(heroId, skillId)
        self:ShowLevel(lv, activeEffectUnlock, activeEffectUpgrade)
        if lv == 0 then
            self:SetActiveColor(false)
        else
            self:SetActiveColor(true)
        end
    else
        self.config.skillIcon.gameObject:SetActive(false)
        self.config.frame.gameObject:SetActive(false)
        self.config.frameActive.gameObject:SetActive(false)
        self.config.frameEmpty.gameObject:SetActive(true)
        self:ShowLevel()
    end
end

--- @return void
--- @param class number
--- @param skillId number
--- @param star number
function SkillHeroView:SetDataSkillMain(class, skillId, star, activeEffectUnlock, activeEffectUpgrade)
    self.class = class
    self.skillId = skillId
    self.star = star
    local baseLevel
    if star == 3 then
        self.tier = 1
        baseLevel = 3
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_1 then
        self.tier = 1
        baseLevel = 3
    elseif star <= HeroConstants.SUMMONER_SKILL_TIER_2 then
        self.tier = 2
        baseLevel = HeroConstants.SUMMONER_SKILL_TIER_1
    else
        self.tier = 3
        baseLevel = HeroConstants.SUMMONER_SKILL_TIER_2
    end
    self.lv = star - baseLevel
    self.config.skillIcon.sprite = ResourceLoadUtils.LoadSkillMainIcon(class, self.tier, skillId)
    self.config.frameEmpty.gameObject:SetActive(false)
    if self.skillId == 1 then
        self.config.frame.gameObject:SetActive(false)
        self.config.frameActive.gameObject:SetActive(true)
    else
        self.config.frame.gameObject:SetActive(true)
        self.config.frameActive.gameObject:SetActive(false)
    end
    self.config.skillIcon.gameObject:SetActive(true)

    self:ShowLevel(self.lv, activeEffectUnlock, activeEffectUpgrade)
end

--- @return void
function SkillHeroView:ShowLevel(lv, activeEffectUnlock, activeEffectUpgrade)
    if activeEffectUnlock == true then
        self:ActiveEffectUnlock(true)
    else
        self:ActiveEffectUnlock(false)
    end
    if lv ~= nil and lv > 1 then
        self.config.bgLv.gameObject:SetActive(true)
        self.config.txtLv.text = tostring(lv)
        if activeEffectUpgrade == true then
            self:ActiveEffectUpgrade(true)
        else
            self:ActiveEffectUpgrade(false)
        end
    else
        self.config.bgLv.gameObject:SetActive(false)
        self:ActiveEffectUpgrade(false)
    end
end

--- @return void
function SkillHeroView:AddListener(callback)
    self:RemoveAllListeners()
    self.config.button.onClick:AddListener(callback)
end

--- @return void
function SkillHeroView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function SkillHeroView:ReturnPool()
    self:RemoveTrigger()
    self:RemoveAllListeners()
    IconView.ReturnPool(self)
    self.config.rectTransform.sizeDelta = U_Vector2.zero
end

return SkillHeroView