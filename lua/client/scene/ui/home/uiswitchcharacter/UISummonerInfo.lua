---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSwitchCharacter.UISummonerInfoConfig"

--- @class UISummonerInfo
UISummonerInfo = Class(UISummonerInfo)

--- @return void
--- @param transform UnityEngine_Transform
function UISummonerInfo:Ctor(transform)
    ---@type UISummonerInfoConfig
    self.config = UIBaseConfig(transform)
    self.config.bgSelect.onClick:AddListener(function ()
        self:HideSkillSelect()
    end)
    ---@type List
    self.listSkill = List()
    ---@type List
    self.listSkillSelect = nil
end

--- @return void
function UISummonerInfo:Show(summonerId, summonerStar)
    self.config.textContent.text = LanguageUtils.LocalizeSummonerInfo(summonerId)
    self.config.textClass.text = LanguageUtils.LocalizeSummonerName(summonerId)
    self:SetClass(summonerId)
    self:SetSkillSummoner(summonerId)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    local statDict = ClientConfigUtils.GetStatSummoner(summonerId,
            summonerStar,
            basicInfoInBound.level)
    self.config.attack.text = ClientConfigUtils.GetValueStringStat(statDict, StatType.ATTACK)
end

--- @param summonerId
function UISummonerInfo:SetClass(summonerId)
    if summonerId ~= HeroConstants.SUMMONER_NOVICE_ID then
        self.config.iconClass.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassSummoner, summonerId)
    end
end

--- @return void
function UISummonerInfo:Hide()

end

--- @return void
---@param summonerId number
function UISummonerInfo:SetSkillSummoner(summonerId)
    ---@type SummonerDataEntry
    local heroDataEntry = ResourceMgr.GetServiceConfig():GetHeroes():GetSummonerDataEntry(summonerId)
    if heroDataEntry == nil then
        XDebug.Log("heroDataEntry == nil   class:" .. summonerId)
    end
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    ---@type List
    local listSkill = summonerInBound:GetListSkillBySummonerId(summonerId)
    for i, v in ipairs(listSkill:GetItems()) do
        ---@type SkillSummonerView
        local skill
        if self.listSkill:Count() >= i then
            skill = self.listSkill:Get(i)
        else
            skill = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillSummonerIconView, self.config.skill)
            self.listSkill:Add(skill)
        end
        skill:SetDataSkillMain(summonerId, i, v)
        skill:AddCallbackSelect(function ()
            self:OnChangeSkillSummoner(summonerId, i)
        end)
        local onPointEnter = function()
            self:OnSelectSkillSummoner(skill.skillView)
        end
        skill.skillView:AddListener(onPointEnter)
    end

    while self.listSkill:Count() > listSkill:Count() do
        ---@type SkillSummonerView
        local skill = self.listSkill:Get(self.listSkill:Count())
        skill:ReturnPool()
        self.listSkill:RemoveByIndex(self.listSkill:Count())
    end

end

--- @return void
--- @param skillView SkillHeroView
function UISummonerInfo:OnSelectSkillSummoner(skillView)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    PopupMgr.ShowPopup(UIPopupName.UISkillPreview, { ["class"] = skillView.class, ["skillId"] = skillView.skillId, ["star"] = skillView.star,
                                                     ["position"] = self.config.transform.position })
end

--- @return void
function UISummonerInfo:HideSkillSelect()
    self.config.skillSelect.gameObject:SetActive(false)
    if self.listSkillSelect ~= nil then
        ---@param v SkillHeroView
        for i, v in ipairs(self.listSkillSelect:GetItems()) do
            v:ReturnPool()
        end
    end
    self.listSkillSelect = nil
end

--- @return void
--- @param skillView SkillHeroView
function UISummonerInfo:OnChangeSkillSummoner(summonerId, skillId)
    ---@type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.config.skillSelect.gameObject:SetActive(true)
    self.config.skillSelect.position = self.config.skill:GetChild(skillId - 1).position
    if self.listSkillSelect == nil then
        self.listSkillSelect = List()
        ---@type HeroEvolveConfig
        local heroEvolveConfig = ResourceMgr.GetHeroMenuConfig():GetHeroEvolveConfig()
        local numberSkill = 2
        if heroEvolveConfig.summonerMaxStar >= HeroConstants.SUMMONER_SKILL_TIER_3 then
            numberSkill = 3
        end
        for i = 1, numberSkill do
            local skillView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillHeroIconView, self.config.contentSkillSelect)
            self.listSkillSelect:Add(skillView)
        end
    end
    ---@param v SkillHeroView
    for i, v in ipairs(self.listSkillSelect:GetItems()) do
        local star = ClientConfigUtils.GetMinStarByTier(i)
        local unlockStar = nil

        local callbackUse = nil
        local equip = nil

        if ClientConfigUtils.GetMinStarByTier(i) <= summonerInBound.star then
            v:SetActiveColor(true)
            star = summonerInBound.star
            local tier = summonerInBound:GetTierBySkillId(summonerId, skillId)
            if tier == i then
                equip = true
                v:ActiveSkillSelect(true)
            else
                callbackUse = function()
                    summonerInBound:SetSkillSummoner(summonerId, skillId, i, function ()
                        self:HideSkillSelect()
                        self:SetSkillSummoner(summonerId)
                    end)
                end
            end
        else
            v:SetActiveColor(false)
            unlockStar = star
        end
        star = ClientConfigUtils.GetStarByTier(i, star)
        v:SetDataSkillMain(summonerId, skillId, star, false, false)
        v:AddListener(function ()
            PopupMgr.ShowPopup(UIPopupName.UISkillPreview, {["class"] = summonerId, ["skillId"] = skillId, ["star"] = star, ["unlock"] = unlockStar,
                                                            ["position"] = v.config.transform.position + U_Vector3.up * 0.6, ["anchor"] = U_Vector2(0.5, 0),
                                                            ["callbackUse"] = callbackUse, ["equip"] = equip})
        end)
    end
end