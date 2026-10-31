--- @class Hero10007_BondSkillHelper : BondSkillHelper
Hero10007_BondSkillHelper = Class(Hero10007_BondSkillHelper, BondSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero10007_BondSkillHelper:Ctor(skill)
    BondSkillHelper.Ctor(self, skill)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10007_BondSkillHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
--- @param bond BaseBond
function Hero10007_BondSkillHelper:CreateBondEffect(initiator, target, isBuff, bond)
    ---@type Hero10007_BondEffect
    local bondEffect = Hero10007_BondEffect(initiator, target, isBuff)

    if self.skill_3 ~= nil then
        local effect = self.skill_3:OnCreateBondEffect(target)
        bondEffect:SetStatChangerEffect(effect)
    end

    return bondEffect
end