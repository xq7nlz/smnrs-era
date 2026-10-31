--- @class Hero50010_Skill3 Sephion
Hero50010_Skill3 = Class(Hero50010_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.numberBuff = nil
    --- @type number
    self.statBuffChance = nil
    --- @type EffectType
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil
    --- @type number
    self.statBuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill3:CreateInstance(id, hero)
    return Hero50010_Skill3(id, hero)
end

--- @return void
function Hero50010_Skill3:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount
    self.numberBuff = self.data.numberBuff

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50010_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        for _ = 1, self.numberBuff do
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
            for j = 1, targetList:Count() do
                local target = targetList:Get(j)

                local statChangerEffect = StatChanger(true)
                statChangerEffect:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

                local effect = StatChangerEffect(self.myHero, target, true)
                effect:SetDuration(self.statBuffDuration)
                effect:AddStatChanger(statChangerEffect)
                target.effectController:AddEffect(effect)
            end
        end
    end
end

return Hero50010_Skill3