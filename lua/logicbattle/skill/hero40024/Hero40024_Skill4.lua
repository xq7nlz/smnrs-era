--- @class Hero40024_Skill4 Wugushi
Hero40024_Skill4 = Class(Hero40024_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero40024_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil
    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type BaseTargetSelector
    self.buffTargetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40024_Skill4:CreateInstance(id, hero)
    return Hero40024_Skill4(id, hero)
end

--- @return void
function Hero40024_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

--- @return number
--- @param eventData table
function Hero40024_Skill4:TakeDamage(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if target == self.myHero and self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
            self.triggerNumber = self.triggerNumber + 1

            self:Buff()
        end
    end
end

--- @return void
function Hero40024_Skill4:Buff()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.data.buffType, StatChangerCalculationType.PERCENT_ADD, self.data.buffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
        effect:SetDuration(self.data.buffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40024_Skill4