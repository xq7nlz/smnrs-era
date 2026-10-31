--- @class Summoner4_Skill4_1 : BaseSkill Assassin
Summoner4_Skill4_1 = Class(Summoner4_Skill4_1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil

    --- @type List<StatChangerEffect>
    self.statChangerEffects = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_1:CreateInstance(id, hero)
    return Summoner4_Skill4_1(id, hero)
end

--- @return void
function Summoner4_Skill4_1:Init()
    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)

    self.statChangerSkillHelper:SetInfo(true, self.data.duration)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_SKILL_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Summoner4_Skill4_1:OnTakeDamage(eventData)
    if eventData.isCrit == true then
        if self.myHero:IsAlly(eventData.initiator) then
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
            local i = 1
            while i <= targetList:Count() do
                local target = targetList:Get(i)

                local numberStackedEffect = self:CountNumberEffect(target)
                if numberStackedEffect < self.data.maxStack then
                    local effect = self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, target)
                    self.statChangerEffects:Add(effect)
                end

                i = i + 1
            end
        end
    end
end

--- @return number
--- @param target BaseHero
function Summoner4_Skill4_1:CountNumberEffect(target)
    local result = 0

    local effectList = target.effectController:GetEffectWithType(EffectType.STAT_CHANGER)
    local i = 1
    while i <= effectList:Count() do
        local effect = effectList:Get(i)
        if effect.initiator == self.myHero and self.statChangerEffects:IsContainValue(effect) == true then
            result = result + 1
        end
        i = i + 1
    end

    return result
end

return Summoner4_Skill4_1