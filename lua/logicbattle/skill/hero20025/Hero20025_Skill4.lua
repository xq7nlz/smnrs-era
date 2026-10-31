--- @class Hero20025_Skill4 Yirlal
Hero20025_Skill4 = Class(Hero20025_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20025_Skill4:CreateInstance(id, hero)
    return Hero20025_Skill4(id, hero)
end

--- @return void
function Hero20025_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20025_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:DebuffStat(enemyDefender)
    end

    self:BuffStat(self.myHero)
end

--- @return void
--- @param target BaseHero
function Hero20025_Skill4:BuffStat(target)
    local buff = self.data.debuffBonus

    local statChanger = StatChanger(true)
    statChanger:SetInfo(buff.statType, buff.calculationType, buff.amount)

    local effect = StatChangerEffect(self.myHero, target, true)
    effect:SetDuration(self.data.buffDuration)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)
end

--- @return void
--- @param target BaseHero
function Hero20025_Skill4:DebuffStat(target)
    local debuff = self.data.buffBonus

    local statChanger = StatChanger(false)
    statChanger:SetInfo(debuff.statType, debuff.calculationType, debuff.amount)

    local effect = StatChangerEffect(self.myHero, target, false)
    effect:SetDuration(self.data.debuffDuration)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)
end

return Hero20025_Skill4