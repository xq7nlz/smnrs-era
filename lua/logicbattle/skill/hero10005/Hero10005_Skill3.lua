--- @class Hero10005_Skill3 Mist
Hero10005_Skill3 = Class(Hero10005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffChance = nil
    --- @type number
    self.statDebuffDuration = nil
    --- @type number
    self.statDebuffAmount = nil
    --- @type number
    self.statDebuffCalculationType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10005_Skill3:CreateInstance(id, hero)
    return Hero10005_Skill3(id, hero)
end

--- @return void
function Hero10005_Skill3:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffChance = self.data.statDebuffChance
    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffCalculationType = self.data.statDebuffCalculationType

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10005_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
            local statChanger = StatChanger(false)
            statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

            local effect = StatChangerEffect(self.myHero, enemyDefender, false)
            effect:SetDuration(self.statDebuffDuration)
            effect:AddStatChanger(statChanger)

            enemyDefender.effectController:AddEffect(effect)
        end
    end
end

return Hero10005_Skill3