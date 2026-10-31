--- @class FactionBonus_DamageSkillHelper : DamageSkillHelper
FactionBonus_DamageSkillHelper = Class(FactionBonus_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function FactionBonus_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type HeroFactionType
    self.factionType = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param factionType HeroFactionType
--- @param skillBonusDamage number
function FactionBonus_DamageSkillHelper:SetBonusSkillDamage(factionType, skillBonusDamage)
    self.factionType = factionType
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function FactionBonus_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.originInfo.faction == self.factionType then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end