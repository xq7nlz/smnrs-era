--- @class Hero20024_Skill4 Yasin
Hero20024_Skill4 = Class(Hero20024_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20024_Skill4:CreateInstance(id, hero)
    return Hero20024_Skill4(id, hero)
end

--- @return void
function Hero20024_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20024_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local statBonus = self.data.statBonus

        local statChanger = StatChanger(false)
        statChanger:SetInfo(statBonus.statType, statBonus.calculationType, statBonus.amount)

        local effect = StatChangerEffect(self.myHero, enemyDefender, false)
        effect:SetDuration(self.data.effectDuration)
        effect:AddStatChanger(statChanger)

        enemyDefender.effectController:AddEffect(effect)
    end
end

return Hero20024_Skill4