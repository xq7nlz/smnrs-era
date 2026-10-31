--- @class Hero40006_Skill3 Oropher
Hero40006_Skill3 = Class(Hero40006_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil

    --- @type number
    self.numberStack = 0

    --- @type number
    self.stackLimit = nil

    --- @type BaseSkill
    self.skill_3 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill3:CreateInstance(id, hero)
    return Hero40006_Skill3(id, hero)
end

--- @return void
function Hero40006_Skill3:Init()
    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    self.stackLimit = self.data.stackLimit

    local skill_2 = self.myHero.skillController:GetPassiveSkill(2)
    if skill_2 ~= nil then
        skill_2:BindingWithSkill_3(self)
    end

    local skill_4 = self.myHero.skillController:GetPassiveSkill(4)
    if skill_4 ~= nil then
        skill_4:BindingWithSkill_3(self)
    end

    self.myHero.hp:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero40006_Skill3:OnDead(initiator, reason)
    self.numberStack = 0
end

--- @return boolean, number isHealOrNot, healAmount
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero40006_Skill3:OnHeal(initiator, reason, healAmount)
    if self.numberStack < self.stackLimit then
        self.numberStack = self.numberStack + 1
        self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
    end
end

return Hero40006_Skill3