--- @class Hero40027_SkillController : SkillController
Hero40027_SkillController = Class(Hero40027_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero40027_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    ---@type Hero40027_Skill2
    self.skill_2 = nil

    ---@type Hero40027_Skill3
    self.skill_3 = nil

    ---@type Hero40027_Skill4
    self.skill_4 = nil
end

--- @return boolean
function Hero40027_SkillController:CanUseActiveSkill()
    return self.myHero.power:IsMax()
end

--- @return number
--- @param skill BaseSkill
function Hero40027_SkillController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero40027_SkillController:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero40027_SkillController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param isDragonForm boolean
function Hero40027_SkillController:OnTransform(isDragonForm)
    if self.skill_2 ~= nil then
        self.skill_2:OnTransform(isDragonForm)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnTransform(isDragonForm)
    end
end

--- @return void
function Hero40027_SkillController:OnAddBondEffect(targetBondageList)
    if self.skill_3 ~= nil then
        self.skill_3:OnAddBondEffect(targetBondageList)
    end
end