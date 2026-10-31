--- @class HealPercentMaxSkillHelper : HealSkillHelper
HealPercentMaxSkillHelper = Class(HealPercentMaxSkillHelper, HealSkillHelper)

--- @return number
--- @param target BaseHero
function HealPercentMaxSkillHelper:GetHealAmount(target)
    return self.healPercent * target.hp:GetMax()
end