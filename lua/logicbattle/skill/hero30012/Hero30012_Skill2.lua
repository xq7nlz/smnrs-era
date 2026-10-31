--- @class Hero30012_Skill2 Dzuteh
Hero30012_Skill2 = Class(Hero30012_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30012_Skill2:CreateInstance(id, hero)
    return Hero30012_Skill2(id, hero)
end

--- @return void
function Hero30012_Skill2:Init()
    local statChanger = StatChanger(true)
    if self.myHero.positionInfo.isFrontLine == true then
        statChanger:SetInfo(self.data.buffStatFrontLine, StatChangerCalculationType.PERCENT_ADD, self.data.buffAmountFrontLine)
    else
        statChanger:SetInfo(self.data.buffStatBackLine, StatChangerCalculationType.PERCENT_ADD, self.data.buffAmountBackLine)
    end

    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetPersistentType(EffectPersistentType.PERMANENT)
    effect:AddStatChanger(statChanger)

    self.myHero.effectController:AddEffect(effect)
end

return Hero30012_Skill2