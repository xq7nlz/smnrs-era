--- @class Hero50004 GuardianOfLight
Hero50004 = Class(Hero50004, BaseHero)

function Hero50004:Ctor()
    BaseHero.Ctor(self)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return Hero50002
function Hero50004:CreateInstance()
    return Hero50004()
end

--- @return HeroInitializer
function Hero50004:CreateInitializer()
    return Hero50004_Initializer(self)
end

--- @return void
--- @param skill BaseSkill
function Hero50004:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Battle actions ----------------------------------------
--- @return List<BaseActionResult>, boolean
--- @param actionType ActionType
function Hero50004:DoAction(actionType)
    return BaseHero.DoAction(self, actionType)
end

return Hero50004