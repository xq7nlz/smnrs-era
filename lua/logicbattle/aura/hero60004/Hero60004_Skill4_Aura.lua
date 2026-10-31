--- @class Hero60004_Skill4_Aura : BaseAura
Hero60004_Skill4_Aura = Class(Hero60004_Skill4_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Hero60004_Skill4_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)

    --- @type ReflectDamageHelper
    self.reflectDamageHelper = nil

    local listener = EventListener(self.initiator, self, self.OnHeroTakeDamage)
    self.initiator.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

--- @return void
--- @param reflectDamageHelper
function Hero60004_Skill4_Aura:SetReflectDamageHelper(reflectDamageHelper)
    self.reflectDamageHelper = reflectDamageHelper
end

--- @return void
--- @param eventData table
function Hero60004_Skill4_Aura:OnHeroTakeDamage(eventData)
    if self.auraState == AuraState.RUNNING then
        local initiator = eventData.initiator
        local target = eventData.target
        local reason = eventData.reason
        local totalDamage = eventData.damage

        if self.initiator:IsAlly(target) ~= true then
            return
        end

        if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
            self.reflectDamageHelper:ReflectDamageFromOther(target, initiator, totalDamage)
        end
    end
end