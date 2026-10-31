require "lua.client.scene.ui.common.SkillHeroView"

--- @class PrefabHeroInfo2View
PrefabHeroInfo2View = Class(PrefabHeroInfo2View)

--- @return void
--- @param transform UnityEngine_Transform
function PrefabHeroInfo2View:Ctor(transform)
    ---@type PrefabHeroInfo2Config
    self.config = UIBaseConfig(transform)
    ---@type HeroResource
    self.heroResource = nil
    ---@type StatInformationView
    self.statsInformation = nil
    ---@type number
    self.power = nil
    ---@type Dictionary
    self.statDict = nil
    ---@type ListSkillView
    self.listSkillView = ListSkillView(self.config.skillParent, U_Vector2(0, 0), self.config.previewSkill)

    self.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonInfo()
    end)
end

--- @return void
--- @param heroResource HeroResource
function PrefabHeroInfo2View:SetData(heroResource, power, statDict)
    self.heroResource = heroResource
    local starNumber = heroResource.heroStar % 6
    if starNumber == 0 then
        starNumber = 6
    end

    self.config.star.sprite = ResourceLoadUtils.LoadStarHeroInfo(heroResource.heroStar)
    UIUtils.SlideImageHorizontal(self.config.star, starNumber)
    local heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroResource.heroId)
    self.config.textLevelCharacter.text = "Lv." .. tostring(heroResource.heroLevel) .. "/" .. tostring(heroLevelCap.levelCap)
    self.config.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
    self.config.iconClass.sprite = ResourceLoadUtils.LoadCLassIcon(ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId))
    self.config.textHeroDetail.text = self:GetHeroTextDetail(heroResource.heroId)
    self:UpdateStat(power, statDict)

    self.listSkillView:SetDataHero(heroResource, false)
end

--- @return void
function PrefabHeroInfo2View:GetHeroTextDetail(heroId)
    local textDetail = ""
    ---@type Dictionary
    local heroDetailTextDict = ClientConfigUtils.GetHeroTextDetailConfig()
    if heroDetailTextDict == nil then
        return ""
    end
    ---@type List
    local textDetailList = heroDetailTextDict:Get(heroId)
    if textDetailList and textDetailList:Count() > 0 then
        for _, v in pairs(textDetailList:GetItems()) do
            local text = LanguageUtils.LocalizeHeroTextDetail(v)
            textDetail = textDetail .. text .. " / "
        end
        return string.sub(textDetail, 1, string.len(textDetail) - 3)
    end
    return ""
end

--- @return void
function PrefabHeroInfo2View:UpdateStat(power, statDict)
    self.power = power
    self.statDict = statDict
    if self.statDict == nil then
        self.statDict = ClientConfigUtils.GetStatHero(self.heroResource, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)
    end
    if self.power == nil then
        self.power = self.statDict:Get(StatType.POWER)
    end
    self.config.textAp.text = tostring(math.floor(self.power))
    self.config.textTim.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.HP)
    self.config.textAttack.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.ATTACK)
    self.config.textAmor.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.DEFENSE)
    self.config.textMovement.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.SPEED)
end

--- @return void
function PrefabHeroInfo2View:OnClickButtonInfo()
    if self.statsInformation == nil then
        self.statsInformation = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StatInformationView, self.config.statsInfomation)
    end
    self.statsInformation:SetData(self.statDict)
end

--- @return void
function PrefabHeroInfo2View:OnHide()
    self.listSkillView:ReturnPool()
    if self.statsInformation ~= nil then
        self.statsInformation:ReturnPool()
        self.statsInformation = nil
    end
end