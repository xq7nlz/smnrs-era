--- @class ListSkillView
ListSkillView = Class(ListSkillView)

--- @return void
---@param transform UnityEngine_Transform
---@param anchor UnityEngine_Vector2
---@param posPreview UnityEngine_Transform
function ListSkillView:Ctor(transform, anchor, posPreview)
    ---@type List --SkillHeroView[]
    self.listSkill = List()
    ---@type UnityEngine_Transform
    self.transform = transform
    ---@type UnityEngine_Vector2
    self.anchor = anchor
    ---@type UnityEngine_Transform
    self.posPreview = posPreview
    ---@type boolean
    self.isSummoner = false
end

--- @return void
---@param count number
function ListSkillView:InitSkillCount(count)
    local countSkill = count
    local countSkillView = self.listSkill:Count()
    if countSkill < countSkillView then
        for i = countSkill + 1, countSkillView do
            ---@type SkillHeroView
            local skill = self.listSkill:Get(i)
            skill.config.gameObject:SetActive(false)
        end
    elseif countSkill > countSkillView then
        for i = countSkillView + 1, countSkill do
            ---@type SkillHeroView
            local skill = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillHeroIconView, self.transform)
            self.listSkill:Add(skill)
            local onPointEnter = function()
                if self.isSummoner == true then
                    self:OnSelectSkillSummoner(skill)
                else
                    self:OnSelectSkillHero(skill)
                end
            end

            skill:AddListener(onPointEnter)
            --local onPointExit = function()
            --    PopupMgr.HidePopup(UIPopupName.UISkillPreview)
            --end
            --skill:InitTrigger(onPointEnter, onPointExit)
        end
    end
end

--- @return void
---@param summonerId number
---@param star number
---@param activeEffectUnlock boolean
function ListSkillView:SetDataSummoner(summonerId, star, activeEffectUnlock, activeEffectUpgrade)
    self.isSummoner = true
    ---@type SummonerDataEntry
    local heroDataEntry = ResourceMgr.GetServiceConfig():GetHeroes():GetSummonerDataEntry(summonerId)
    if heroDataEntry == nil then
        XDebug.Error("heroDataEntry == nil   class:" .. summonerId)
    end
    self:InitSkillCount(heroDataEntry.allSkillDataDict:Count())
    local index = 1
    for i, v in pairs(heroDataEntry.allSkillDataDict:GetItems()) do
        ---@type Dictionary
        local skillLevels = v.skillLevels
        if skillLevels:IsContainKey(star) then
            ---@type SkillHeroView
            local skill = self.listSkill:Get(index)
            skill:SetDataSkillMain(summonerId, i, star, activeEffectUnlock, activeEffectUpgrade)
            index = index + 1
        end
    end
end

--- @return void
---@param heroResource HeroResource
function ListSkillView:SetDataHero(heroResource, activeEffectUnlock, activeEffectUpgrade)
    self.isSummoner = false
    local heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
    local heroSkillLevel = heroDataService:GetHeroSkillLevelData(heroResource.heroStar)
    local heroDataEntry = heroDataService:GetHeroDataEntry(heroResource.heroId)
    if heroDataEntry == nil then
        XDebug.Error("heroDataEntry == nil   id:" .. heroResource.heroId)
    end
    if heroSkillLevel ~= nil then
        self:InitSkillCount(4)

        for i = 1, 4 do
            ---@type SkillHeroView
            local skill = self.listSkill:Get(i)
            if heroDataEntry.allSkillDataDict:IsContainKey(i) then
                local lvSkill = heroSkillLevel.skillLevels:Get(i)
                skill:SetData(heroResource.heroId, i, lvSkill, activeEffectUnlock, activeEffectUpgrade)
            else
                skill:SetData(heroResource.heroId)
            end
        end
    else
        self:InitSkillCount(0)
    end
end

--- @return void
---@param heroResource HeroResource
---@param star number
function ListSkillView:SetDataHeroEvolve(heroResource, star, activeEffectUnlock, activeEffectUpgrade)
    self.isSummoner = false
    local heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
    local heroLevelData1 = heroDataService:GetHeroSkillLevelData(star)
    local heroLevelData2 = heroDataService:GetHeroSkillLevelData(star + 1)
    local heroDataEntry = heroDataService:GetHeroDataEntry(heroResource.heroId)
    ---@type Dictionary
    local skillDict = Dictionary()
    if heroLevelData1 ~= nil and heroLevelData2 ~= nil then
        local isUnlock = false
        for i, v in pairs(heroDataEntry.allSkillDataDict:GetItems()) do
            local lv1 = heroLevelData1.skillLevels:Get(i)
            local lv2 = heroLevelData2.skillLevels:Get(i)
            if heroDataEntry.allSkillDataDict:IsContainKey(i) and lv1 ~= lv2 then
                skillDict:Add(i, lv2)
                if lv2 > 1 then
                    isUnlock = false
                else
                    isUnlock = true
                end
            end
        end
    end
    self:InitSkillCount(skillDict:Count())
    local index = 1
    for i, v in pairs(skillDict:GetItems()) do
        ---@type SkillHeroView
        local skill = self.listSkill:Get(index)
        skill:SetData(heroResource.heroId, i, v, activeEffectUnlock, activeEffectUpgrade)
        index = index + 1
    end
end

--- @return void
--- @param skillView SkillHeroView
function ListSkillView:OnSelectSkillSummoner(skillView)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    PopupMgr.ShowPopup(UIPopupName.UISkillPreview, { ["class"] = skillView.class, ["skillId"] = skillView.skillId, ["star"] = skillView.star,
                                                     ["position"] = self:GetPossPreview(skillView), ["anchor"] = self.anchor })

end

--- @return void
--- @param skillView SkillHeroView
function ListSkillView:OnSelectSkillHero(skillView)
    local skillId = skillView.skillId
    local unlock
    if skillView.lv == 0 then
        --if heroSkillLevel.skillLevels:Get(skillId) == 0 then
        for i, heroLevelDataTarget in ipairs(ResourceMgr.GetServiceConfig():GetHeroes().heroSkillLevelDataEntries:GetItems()) do
            if heroLevelDataTarget.skillLevels:Get(skillView.skillId) > 0 then
                unlock = i
                break
            end
        end
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    PopupMgr.ShowPopup(UIPopupName.UISkillPreview,
            { ["heroId"] = skillView.heroId,
              ["skillId"] = skillId,
              ["level"] = skillView.lv,
              ["position"] = self:GetPossPreview(skillView),
              ["anchor"] = self.anchor,
              ["unlock"] = unlock })

end

--- @return UnityEngine_Vector3
--- @param skillView SkillHeroView
function ListSkillView:GetPossPreview(skillView)
    local pos
    if self.posPreview ~= nil then
        pos = self.posPreview.position
    else
        pos = skillView.config.transform.position
    end
    return pos
end

--- @return void
function ListSkillView:ReturnPool()
    ---@param v SkillHeroView
    for _, v in pairs(self.listSkill:GetItems()) do
        v:ReturnPool()
    end
    self.listSkill:Clear()
    ResourceLoadUtils.UnloadFolderAtlas()
end