--- @class Hero10003_HealSkillHelper : HealSkillHelper
Hero10003_HealSkillHelper = Class(Hero10003_HealSkillHelper, HealSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero10003_HealSkillHelper:Ctor(skill)
    HealSkillHelper.Ctor(self, skill)

    --- @type EffectType
    self.healMarkType = nil
    --- @type number
    self.healMarkBonusPercent = nil
end

--- @return void
--- @param healPercent number
--- @param healMarkType EffectType
--- @param healMarkBonusPercent number
function Hero10003_HealSkillHelper:SetHealData(healPercent, healMarkType, healMarkBonusPercent)
    HealSkillHelper.SetHealData(self, healPercent, 0)

    self.healMarkType = healMarkType
    self.healMarkBonusPercent = healMarkBonusPercent
end

---------------------------------------- Use Heal skill ----------------------------------------
--- @return number
--- @param target BaseHero
function Hero10003_HealSkillHelper:GetHealAmount(target)
    local totalHealPercent = self.healPercent
    if target.effectController:IsContainEffectType(self.healMarkType) then
        totalHealPercent = totalHealPercent + self.healMarkBonusPercent
    end

    return totalHealPercent * self.myHero.attack:GetValue()
end