--- @class Hero10020_Skill3 Sniper
Hero10020_Skill3 = Class(Hero10020_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10020_Skill3:CreateInstance(id, hero)
    return Hero10020_Skill3(id, hero)
end

--- @return void
function Hero10020_Skill3:Init()
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

--- @return void
function Hero10020_Skill3:AddBuff()
end

return Hero10020_Skill3