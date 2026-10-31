--- @class Hero40026_Skill2 Arason
Hero40026_Skill2 = Class(Hero40026_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40026_Skill2:CreateInstance(id, hero)
    return Hero40026_Skill2(id, hero)
end

--- @return void
function Hero40026_Skill2:Init()
    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.PERMANENT)
    self.statChangerEffect:SetDuration(EffectConstants.INFINITY_DURATION)

    if self.myHero.positionInfo.isFrontLine then
        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.data.frontStatType, StatChangerCalculationType.PERCENT_ADD, self.data.frontStatAmount)
        self.statChangerEffect:AddStatChanger(statChanger)
    else
        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.data.backStatType, StatChangerCalculationType.PERCENT_ADD, self.data.backStatAmount)
        self.statChangerEffect:AddStatChanger(statChanger)
    end
    self.myHero.effectController:AddEffect(self.statChangerEffect)
end


return Hero40026_Skill2