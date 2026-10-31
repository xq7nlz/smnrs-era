--- @class Hero50002_Skill4 HolyKnight
Hero50002_Skill4 = Class(Hero50002_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<StatBonus>
    self.bonuses = List()

    --- @type number
    self.duration = nil

    --- @type Dictionary<BaseHero, BaseEffect>
    self.triggerDictionary = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill4:CreateInstance(id, hero)
    return Hero50002_Skill4(id, hero)
end

--- @return void
function Hero50002_Skill4:Init()
    self.duration = self.data.duration

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50002_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:TriggerEffect(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50002_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:TriggerEffect(enemy)
end

--- @return void
--- @param enemy BaseHero
function Hero50002_Skill4:TriggerEffect(enemy)
    if enemy.effectController:IsContainEffectType(EffectType.HOLY_MARK) then
        local currentEffect = self.triggerDictionary:Get(enemy)
        if currentEffect == nil then
            self:AddStatChangerEffect(enemy)
        else
            -- Check if myHero already had effect corresponds to enemy
            if self.myHero.effectController:IsContainEffect(currentEffect) == false then
                self:AddStatChangerEffect(enemy)
            end
        end
    end
end

--- @return void
--- @param enemy BaseHero
function Hero50002_Skill4:AddStatChangerEffect(enemy)
    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetDuration(self.duration)

    local i = 1
    while i <= self.data.bonuses:Count() do
        local bonus = self.data.bonuses:Get(i)
        local statChanger = StatChanger(true)
        statChanger:SetInfo(bonus.statType, bonus.calculationType, bonus.amount)

        self.statChangerEffect:AddStatChanger(statChanger)
        i = i + 1
    end

    self.myHero.effectController:AddEffect(self.statChangerEffect)
    self.triggerDictionary:Add(enemy, self.statChangerEffect)
end

return Hero50002_Skill4