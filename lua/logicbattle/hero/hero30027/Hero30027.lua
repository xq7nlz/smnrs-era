--- @class Hero30027 : BaseHero Kazetsu
Hero30027 = Class(Hero30027, BaseHero)

--- @return void
function Hero30027:Ctor()
    BaseHero.Ctor(self)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return BaseHero
function Hero30027:CreateInstance()
    return Hero30027()
end

--- @return HeroInitializer
function Hero30027:CreateInitializer()
    return Hero30027_Initializer(self)
end

--- @return void
--- @param skill BaseSkill
function Hero30027:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean
function Hero30027:CanBeTargetedByEnemy()
    if self.skill_4 ~= nil then
        if self.skill_4:CanBeTargeted() == false then
            return false
        end
    end

    return BaseHero.CanBeTargetedByEnemy(self)
end

--- @return boolean
function Hero30027:CanBeTargetedByAlly()
    if self.skill_4 ~= nil then
        if self.skill_4:CanBeTargeted() == false then
            return false
        end
    end

    return BaseHero.CanBeTargetedByAlly(self)
end

--- @return boolean
function Hero30027:CanPlay()
    if self:IsDead() then
        return false
    end

    if self.effectController:IsContainCCEffect() then
        return false
    end

    if self.skill_4 ~= nil then
        if self.skill_4:CanBeTargeted() == false then
            return false
        end
    end

    return true
end

return Hero30027