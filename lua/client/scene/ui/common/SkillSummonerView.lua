---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.SkillSummonerConfig"

--- @class SkillSummonerView : IconView
SkillSummonerView = Class(SkillSummonerView, IconView)

--- @return void
function SkillSummonerView:Ctor(component)
    IconView.Ctor(self)
    ---@type SkillHeroView
    self.skillView = nil
end

--- @return void
function SkillSummonerView:SetPrefabName()
    self.prefabName = 'skill_and_text_view'
    self.uiPoolType = UIPoolType.SkillSummonerIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function SkillSummonerView:SetConfig(transform)
    assert(transform)
    ---@type SkillSummonerConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param heroId number
--- @param skillId number
function SkillSummonerView:SetData(heroId, skillId, lv, activeEffectUnlock, activeEffectUpgrade)
    if self.skillView == nil then
        self.skillView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillHeroIconView, self.config.icon)
    end
    self.skillView:SetData(heroId, skillId, lv, activeEffectUnlock, activeEffectUpgrade)
end

--- @return void
--- @param class number
--- @param skillId number
--- @param star number
function SkillSummonerView:SetDataSkillMain(class, skillId, star, activeEffectUnlock, activeEffectUpgrade)
    if self.skillView == nil then
        self.skillView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillHeroIconView, self.config.icon)
    end
    local tier = ClientConfigUtils.GetTierByStar(star)
    self.skillView:SetDataSkillMain(class, skillId, star, activeEffectUnlock, activeEffectUpgrade)
    self.config.textNameSkill.text = LanguageUtils.LocalizeSummonerSkillName(class,
            skillId, tier)
    if skillId == 1 then
        self.config.textActiveSkill.text = LanguageUtils.Localize("active_skill", LanguageUtils.Skill)
    else
        self.config.textActiveSkill.text = LanguageUtils.Localize("passive_skill", LanguageUtils.Skill)
    end
    self.config.buttonSelect.gameObject:SetActive(star > 3)
end

--- @return void
function SkillSummonerView:AddCallbackSelect(onClick)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function ()
        onClick()
    end)
end

--- @return void
function SkillSummonerView:ReturnPool()
    if self.skillView ~= nil then
        self.skillView:ReturnPool()
        self.skillView = nil
    end
    IconView.ReturnPool(self)
end

return SkillSummonerView