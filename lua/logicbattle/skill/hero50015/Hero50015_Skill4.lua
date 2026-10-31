--- @class Hero50015_Skill4 Navro
Hero50015_Skill4 = Class(Hero50015_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50015_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    self.isActive = false

    --- @type number
    self.healthTrigger = 0
    --------------------- EFFECT 1 ------------------------

    --- @type StatType
    self.statBuffType = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type number
    self.statBuffDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50015_Skill4:CreateInstance(id, hero)
    return Hero50015_Skill4(id, hero)
end

---- @return void
function Hero50015_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionBuff,
            TargetTeamType.ALLY, self.data.targetNumberBuff)

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero50015_Skill4:TakeDamage(eventData)
    local target = eventData.target
    if target == self.myHero and self.isActive == false and self.myHero:IsDead() == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
        self:BuffHeal()
        self.isActive = true
    end
end

--- @return void
function Hero50015_Skill4:BuffHeal()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        local effectBuffPassive = StatChangerEffect(self.myHero, target, true)
        effectBuffPassive:SetDuration(self.statBuffDuration)

        local effectBuff = StatChanger(true)
        effectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        effectBuffPassive:AddStatChanger(effectBuff)
        target.effectController:AddEffect(effectBuffPassive)
        i = i + 1
    end
end

return Hero50015_Skill4