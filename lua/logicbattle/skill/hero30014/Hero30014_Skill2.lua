--- @class Hero30014_Skill2 Kargoth
Hero30014_Skill2 = Class(Hero30014_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30014_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bloodMarkChance = nil
    --- @type number
    self.bloodMarkDuration = nil

    --- @type number
    self.healthTrigger = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type number
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil

    --- @type boolean
    self.isActive = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30014_Skill2:CreateInstance(id, hero)
    return Hero30014_Skill2(id, hero)
end

--- @return void
function Hero30014_Skill2:Init()
    self.bloodMarkChance = self.data.bloodMarkChance
    self.bloodMarkDuration = self.data.bloodMarkDuration

    self.healthTrigger = self.data.healthTrigger
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30014_Skill2:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.myHero:IsDead() == false then
            if self.isActive == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
                self:BuffStat()
                self.isActive = true
            end
        end
    end
end

--- @return void
function Hero30014_Skill2:BuffStat()
    local effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    effectBuffPassive:SetDuration(self.statBuffDuration)
    local effectBuff = StatChanger(true)
    effectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    effectBuffPassive:AddStatChanger(effectBuff)
    self.myHero.effectController:AddEffect(effectBuffPassive)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30014_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30014_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemy)
    end
end

--- @return void
--- @param target BaseHero
function Hero30014_Skill2:InflictEffect(target)
    --- check can inflict effect
    if self.myHero.randomHelper:RandomRate(self.bloodMarkChance) then
        local effect = BloodMark(self.myHero, target, self.bloodMarkDuration)
        target.effectController:AddEffect(effect)
    end
end

return Hero30014_Skill2