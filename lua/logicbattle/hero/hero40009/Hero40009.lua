--- @class Hero40009 Sylph
Hero40009 = Class(Hero40009, BaseHero)

--- @return void
function Hero40009:Ctor()
    BaseHero.Ctor(self)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return BaseHero
function Hero40009:CreateInstance()
    return Hero40009()
end

--- @return HeroInitializer
function Hero40009:CreateInitializer()
    return Hero40009_Initializer(self)
end

--- @return void
--- @param skill BaseSkill
function Hero40009:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return boolean
function Hero40009:CanBeTargetedByEnemy()
    if self.skill_1 ~= nil then
        if self.skill_1:CanBeTargetedByEnemy() == false then
            return false
        end
    end

    return BaseHero.CanBeTargetedByEnemy(self)
end

return Hero40009