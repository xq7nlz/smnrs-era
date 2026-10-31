--- @class Hero10017_Skill4 Glugrgly
Hero10017_Skill4 = Class(Hero10017_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10017_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffChance = 0

    --- @type EffectType
    self.statBuffType = 0

    --- @type number
    self.statBuffDuration = 0

    --- @type number
    self.statBuffAmount = 0

    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10017_Skill4:CreateInstance(id, hero)
    return Hero10017_Skill4(id, hero)
end

--- @return void
function Hero10017_Skill4:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero,
            self.data.statBuffTargetPosition, TargetTeamType.ALLY, self.data.statBuffTargetNumber)

    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10017_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        local targetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)

        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            local effectBuffStat = StatChangerEffect(self.myHero, target, true)
            effectBuffStat:SetDuration(self.statBuffDuration)

            local effectBuff = StatChanger(true)
            effectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)
            effectBuffStat:AddStatChanger(effectBuff)

            target.effectController:AddEffect(effectBuffStat)

            i = i + 1
        end
    end
end

return Hero10017_Skill4