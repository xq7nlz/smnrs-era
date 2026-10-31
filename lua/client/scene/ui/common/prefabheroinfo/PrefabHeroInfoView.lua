---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfoConfig"
require "lua.client.scene.ui.common.SkillHeroView"

--- @class PrefabHeroInfoView
PrefabHeroInfoView = Class(PrefabHeroInfoView)

--- @return void
--- @param transform UnityEngine_Transform
function PrefabHeroInfoView:Ctor(transform)
    ---@type PrefabHeroInfoConfig
    ---@type PrefabHeroInfoConfig
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
    self.listSkillView = ListSkillView(self.config.skillParent, U_Vector2(0.5,0), self.config.previewSkill)

    self.config.buttonInfo.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonInfo()
    end)
end

--- @return void
--- @param heroResource HeroResource
function PrefabHeroInfoView:SetData(heroResource, power, statDict)
    self.heroResource = heroResource
    self.power = power
    self.statDict = statDict
    local starNumber = heroResource.heroStar % 6
    if starNumber == 0 then
        starNumber = 6
    end
    self.config.star.sprite = ResourceLoadUtils.LoadStarHeroInfo(heroResource.heroStar)
    UIUtils.SlideImageHorizontal(self.config.star, starNumber)

    local class = ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId)
    self.config.textFaction.text = LanguageUtils.LocalizeClass(class)

    if self.statDict == nil then
        self.statDict = ClientConfigUtils.GetStatHero(heroResource, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)
    end
    if self.power == nil then
        self.power = self.statDict:Get(StatType.POWER)
    end
    self.config.textAp.text = tostring(math.floor(self.power))
    self.config.textTim.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.HP)
    self.config.textAttack.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.ATTACK)
    self.config.textAmor.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.DEFENSE)
    self.config.textMovement.text = ClientConfigUtils.GetValueStringStat(self.statDict, StatType.SPEED)

    self.listSkillView:SetDataHero(heroResource, false)
end

--- @return void
function PrefabHeroInfoView:OnClickButtonInfo()
    if self.statsInformation == nil then
        self.statsInformation = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StatInformationView, self.config.statsInfomation)
    end
    self.statsInformation:SetData(self.statDict)
end

--- @return void
function PrefabHeroInfoView:OnDisable()
    self.listSkillView:ReturnPool()
    if self.statsInformation ~= nil then
        self.statsInformation:ReturnPool()
        self.statsInformation = nil
    end
end