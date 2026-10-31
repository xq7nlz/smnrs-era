--- @class Hero30005_Skill4 Jormungand
Hero30005_Skill4 = Class(Hero30005_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.subActiveSkillHelper = nil

    ---@type number
    self.venomStackDamage = nil

    --- @type number
    self.venomStackDuration = nil

    --- @type number
    self.numberStack = nil

    --- @type number
    self.damagePerVenomStack = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill4:CreateInstance(id, hero)
    return Hero30005_Skill4(id, hero)
end

--- @return void
function Hero30005_Skill4:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.subActiveSkillHelper = SubActiveSkillHelper(self)

    self.venomStackDamage = self.data.venomStackDamage
    self.venomStackDuration = self.data.venomStackDuration
    self.numberStack = self.data.numberStack

    self.damagePerVenomStack = self.data.damagePerVenomStack

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30005_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            if target:IsDead() == false then
                local venomStacks = target.effectController:GetEffectWithType(EffectType.VENOM_STACK)

                local multiplier = venomStacks:Count() * self.damagePerVenomStack

                self.subActiveSkillHelper:SetInfo(multiplier)
                self.subActiveSkillHelper:UseSubActiveSkillOnTarget(target)
            end
            i = i + 1
        end
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30005_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    Hero30005_Utils.InflictVenomStack(self.myHero, enemyAttacker,
            self.venomStackDamage, self.venomStackDuration, self.numberStack)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30005_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    Hero30005_Utils.InflictVenomStack(self.myHero, enemy,
            self.venomStackDamage, self.venomStackDuration, self.numberStack)
end

return Hero30005_Skill4