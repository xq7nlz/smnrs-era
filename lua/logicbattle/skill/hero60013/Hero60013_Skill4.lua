--- @class Hero60013_Skill4 DarkKnight
Hero60013_Skill4 = Class(Hero60013_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChanger
    self.statChanger = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil

    --- @type number
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil
    --- @type boolean
    self.isTriggerEffect = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill4:CreateInstance(id, hero)
    return Hero60013_Skill4(id, hero)
end

--- @return void
function Hero60013_Skill4:Init()
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    self.myHero.hp:BindingWithSkill_4(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero60013_Skill4:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        if self.myHero:IsAlly(eventData.target) then
            if self.isTriggerEffect then
                self.statChanger:SetAmount(self.statChanger.amount + self.statBuffAmount)
                self.statChangerEffect:Recalculate()
            else
                self.isTriggerEffect = true
                self.statChanger:SetAmount(self.statBuffAmount)
                self.myHero.effectController:AddEffect(self.statChangerEffect)
            end
        end
    end
end

--- return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero60013_Skill4:OnDead(initiator, reason)
    self.isTriggerEffect = false
end

return Hero60013_Skill4