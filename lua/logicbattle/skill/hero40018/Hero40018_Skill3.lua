--- @class Hero40018_Skill3 Oakroot
Hero40018_Skill3 = Class(Hero40018_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40018_Skill3:CreateInstance(id, hero)
    return Hero40018_Skill3(id, hero)
end

--- @return void
function Hero40018_Skill3:Init()
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

return Hero40018_Skill3