--- @class Summoner4_Skill4_2 : BaseSkill Assassin
Summoner4_Skill4_2 = Class(Summoner4_Skill4_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type Dictionary
    --- key: BaseHero, value: effect
    self.buffedEffects = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_2:CreateInstance(id, hero)
    return Summoner4_Skill4_2(id, hero)
end

--- @return void
function Summoner4_Skill4_2:Init()
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    local listener = EventListener(self.myHero, self, self.OnDealBasicAttackDamage)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData
function Summoner4_Skill4_2:OnDealBasicAttackDamage(eventData)
    local target = eventData.target
    if eventData.dodgeType == DodgeType.MISS and self.myHero:IsAlly(target) then
        local effect = self.buffedEffects:Get(target)
        if effect ~= nil then
            effect:SetDuration(self.statBuffDuration)
            if target.effectController:IsContainEffect(effect) == false then
                effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
                target.effectController:AddEffect(effect)
            end
        else
            local statChanger = StatChanger(true)
            statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

            effect = StatChangerEffect(self.myHero, target, true)
            effect:SetDuration(self.statBuffDuration)
            effect:AddStatChanger(statChanger)
            effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

            target.effectController:AddEffect(effect)

            self.buffedEffects:Add(target, effect)
        end
    end
end

return Summoner4_Skill4_2