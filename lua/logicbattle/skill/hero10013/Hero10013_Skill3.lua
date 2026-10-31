--- @class Hero10013_Skill3 Oceanee
Hero10013_Skill3 = Class(Hero10013_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statDebuffAmount = nil
    --- @type StatType
    self.statDebuffType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill3:CreateInstance(id, hero)
    return Hero10013_Skill3(id, hero)
end

--- @return void
function Hero10013_Skill3:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10013_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:InflictEffect(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero10013_Skill3:InflictEffect(target)
    if target.effectController:IsContainEffectType(EffectType.OCEANEE_MARK) == false then
        local oceaneeMark = OceaneeMark(self.myHero, target)

        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)

        oceaneeMark:SetDebuffEffect(effect, self.statDebuffAmount)
        target.effectController:AddEffect(oceaneeMark)
    end
end

return Hero10013_Skill3