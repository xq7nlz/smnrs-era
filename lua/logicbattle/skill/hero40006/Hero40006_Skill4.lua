--- @class Hero40006_Skill4 Oropher
Hero40006_Skill4 = Class(Hero40006_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil
    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type number
    self.healPercent = nil
    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type BaseTargetSelector
    self.buffTargetSelector = nil

    --- @type number
    self.buffStat = nil
    --- @type number
    self.buffBonus = nil

    --- @type number
    self.buffPower = nil
    --- @type number
    self.buffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill4:CreateInstance(id, hero)
    return Hero40006_Skill4(id, hero)
end

--- @return void
function Hero40006_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit

    self.healPercent = self.data.healPercent

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    self.buffStat = self.data.buffStat
    self.buffBonus = self.data.buffBonus

    self.buffPower = self.data.buffPower
    self.buffDuration = self.data.buffDuration

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero40006_Skill4:TakeDamage(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if target == self.myHero and self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
            self.triggerNumber = self.triggerNumber + 1

            self:Heal()
            self:Buff()
        end
    end
end

--- @return void
--- @param skill BaseSkill
function Hero40006_Skill4:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
function Hero40006_Skill4:Heal()
    local healAmount = self.healPercent * self.myHero.attack:GetValue()

    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= allyTargetList:Count() do
        local target = allyTargetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)

        if self.skill_3 ~= nil then
            self.skill_3:OnHeal(self.myHero, HealReason.HEAL_SKILL, healAmount)
        end
        i = i + 1
    end
end

--- @return void
function Hero40006_Skill4:Buff()
    local buffTargetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= buffTargetList:Count() do
        local target = buffTargetList:Get(i)
        PowerUtils.GainPower(self.myHero, target, self.buffPower, false)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.buffStat, StatChangerCalculationType.PERCENT_ADD, self.buffBonus)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.buffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40006_Skill4