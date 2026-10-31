--- @class Hero60002_Skill2 Bloodseeker
Hero60002_Skill2 = Class(Hero60002_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChanger
    self.statChanger1 = nil
    --- @type StatChanger
    self.statChanger2 = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil

    --- @type number
    self.bonus1 = nil
    --- @type number
    self.bonus2 = nil

    --- @type boolean
    self.isTriggerEffect = false

    --- @type number
    self.hpLower = nil

    --- @type List<BaseHero>
    self.heroTriggerList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill2:CreateInstance(id, hero)
    return Hero60002_Skill2(id, hero)
end

--- @return void
function Hero60002_Skill2:Init()
    self.hpLower = self.data.hpLower

    self.bonus1 = self.data.bonus_1
    self.bonus2 = self.data.bonus_2

    self.statChanger1 = StatChanger(true)
    self.statChanger1:SetInfo(self.data.stat_1, self.data.calculation_type_1, self.data.bonus_1)

    self.statChanger2 = StatChanger(true)
    self.statChanger2:SetInfo(self.data.stat_2, self.data.calculation_type_2, self.data.bonus_2)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.statChangerEffect:AddStatChanger(self.statChanger1)
    self.statChangerEffect:AddStatChanger(self.statChanger2)

    self.myHero.hp:BindingWithSkill_2(self)

    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero60002_Skill2:OnHeroTakeDamage(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if self.myHero:IsAlly(target) == false then
            if target:IsDead() == false and target.hp:GetStatPercent() < self.hpLower then
                if self.heroTriggerList:IsContainValue(target) == false then
                    if self.isTriggerEffect then
                        self.statChanger1:SetAmount(self.statChanger1.amount + self.bonus1)
                        self.statChanger2:SetAmount(self.statChanger2.amount + self.bonus2)
                        self.statChangerEffect:Recalculate()
                    else
                        self.isTriggerEffect = true
                        self.statChanger1:SetAmount(self.bonus1)
                        self.statChanger2:SetAmount(self.bonus2)
                        self.myHero.effectController:AddEffect(self.statChangerEffect)
                    end
                    self.heroTriggerList:Add(target)
                end
            end
        end
    end
end

--- return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero60002_Skill2:OnDead(initiator, reason)
    isTriggerEffect = false
    self.heroTriggerList:Clear()
    self.isTriggerEffect = false
end

return Hero60002_Skill2