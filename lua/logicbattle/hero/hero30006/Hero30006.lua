--- @class Hero30006 Thanatos
Hero30006 = Class(Hero30006, BaseHero)

--- @return void
function Hero30006:Ctor()
    BaseHero.Ctor(self)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return Hero30003
function Hero30006:CreateInstance()
    return Hero30006()
end

--- @return HeroInitializer
function Hero30006:CreateInitializer()
    return Hero30006_Initializer(self)
end

--- @return void
--- @param skill BaseSkill
function Hero30006:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return boolean
function Hero30006:CanBeTargetedByEnemy()
    if self.skill_3 ~= nil then
        if self.skill_3:CanBeTargetedByEnemy() == false then
            return false
        end
    end

    return BaseHero.CanBeTargetedByEnemy(self)
end

return Hero30006