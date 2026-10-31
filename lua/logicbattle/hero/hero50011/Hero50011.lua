--- @class Hero50011 Ignatius
Hero50011 = Class(Hero50011, BaseHero)

--- @return void
function Hero50011:Ctor()
    BaseHero.Ctor(self)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return BaseHero
function Hero50011:CreateInstance()
    return Hero50011()
end

--- @return HeroInitializer
function Hero50011:CreateInitializer()
    return Hero50011_Initializer(self)
end

--- @return void
--- @param skill BaseSkill
function Hero50011:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return List<BaseActionResult>, boolean
--- @param actionType ActionType
function Hero50011:DoAction(actionType)
    local actionResults, isEndTurn = BaseHero.DoAction(self, actionType)

    if self.skill_4 ~= nil then
        self.skill_4:OnDoAction()
    end

    return actionResults, isEndTurn
end

return Hero50011