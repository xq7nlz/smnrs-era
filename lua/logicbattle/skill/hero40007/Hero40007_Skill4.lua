--- @class Hero40007_Skill4 Noroth
Hero40007_Skill4 = Class(Hero40007_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero40007_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.buffTargetSelector = nil

    --- @type number
    self.healthTrigger = nil
    --- @type number
    self.effectChance = 0
    --- @type EffectType
    self.effectType = 0
    --- @type number
    self.effectDuration = 0

    --- @type boolean
    self.isActive = false
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40007_Skill4:CreateInstance(id, hero)
    return Hero40007_Skill4(id, hero)
end

--- @return void
function Hero40007_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero40007_Skill4:TakeDamage(eventData)
    local target = eventData.target
    if target == self.myHero and self.myHero:IsDead() == false then
        if self.isActive == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
            self:BuffAllyEffect()
            self.isActive = true
        end
    end
end

--- @return void
function Hero40007_Skill4:BuffAllyEffect()
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            EffectUtils.CreateBlessEffect(self.myHero, target, EffectType.BLESS_MARK, self.effectDuration)

            i = i + 1
        end
    end
end

return Hero40007_Skill4
