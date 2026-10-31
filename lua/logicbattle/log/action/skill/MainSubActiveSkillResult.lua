--- @class MainSubActiveSkillResult : BaseActionResult
MainSubActiveSkillResult = Class(MainSubActiveSkillResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param skillName string
function MainSubActiveSkillResult:Ctor(initiator, target, skillName)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.MAIN_SUB_ACTIVE_DAMAGE_SKILL)

    --- @type string
    self.skillName = skillName

    --- @type boolean
    self.isBlock = false

    --- @type number
    self.damage = 0
end

--- @return void
--- @param damage number
--- @param isBlock boolean
function MainSubActiveSkillResult:SetDamage(damage, isBlock)
    self.damage = damage
    self.isBlock = isBlock
    self:RefreshHeroStatus()
end

--- @return MainSubActiveSkillResult
function MainSubActiveSkillResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.skillName = self.skillName

    data.isBlock = self.isBlock

    data.damage = self.damage

    return data
end

--- @return string
function MainSubActiveSkillResult:ToString()
    local result = string.format("%s, TAKE %s damage (name = %s)\n",
            BaseActionResult.GetPrefix(self, "MAIN_SUB_ACTIVE_SKILL"), self.damage, self.skillName)

    if self.isBlock then
        result = result .. string.format("%s BLOCK MAIN_SUB_ACTIVE_SKILL\n", self.target:ToString())
    end

    return result
end