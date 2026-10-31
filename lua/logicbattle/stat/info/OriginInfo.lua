--- @class OriginInfo
--- see csv/origin for more info
OriginInfo = Class(OriginInfo)

--- @return void
--- @param hero BaseHero
--- @param class HeroClassType
--- @param faction HeroFactionType
function OriginInfo:Ctor(hero, class, faction)
    --- @type BaseHero
    self.myHero = hero

    --- @type HeroClassType
    self.class = class
    --- @type HeroFactionType
    self.faction = faction
end

--- @return boolean
--- @param enemyFaction HeroFactionType
--- only use this method in attacker/initiator
function OriginInfo:HasFactionBonus(enemyFaction)
    if self.faction == enemyFaction then
        return false
    end

    --- Abyss vs Water
    if self.faction == HeroFactionType.ABYSS then
        if enemyFaction == HeroFactionType.WATER then
            return true
        else
            return false
        end
    end

    --- Water vs Fire
    if self.faction == HeroFactionType.WATER then
        if enemyFaction == HeroFactionType.FIRE then
            return true
        else
            return false
        end
    end

    --- Fire vs Nature
    if self.faction == HeroFactionType.FIRE then
        if enemyFaction == HeroFactionType.NATURE then
            return true
        else
            return false
        end
    end

    --- Nature vs Abyss
    if self.faction == HeroFactionType.NATURE then
        if enemyFaction == HeroFactionType.ABYSS then
            return true
        else
            return false
        end
    end

    --- Light vs Dark
    if self.faction == HeroFactionType.LIGHT then
        if enemyFaction == HeroFactionType.DARK then
            return true
        else
            return false
        end
    end

    --- Dark vs Light
    if self.faction == HeroFactionType.DARK then
        if enemyFaction == HeroFactionType.LIGHT then
            return true
        else
            return false
        end
    end
end

--- @return number damage bonus
--- @param target BaseHero
--- @param multiplier number
function OriginInfo:CalculateAttackFactionBonus(target, multiplier)
    if self:HasFactionBonus(target.originInfo.faction) then
        return MathUtils.Truncate(multiplier * (1 + HeroConstants.FACTION_BONUS_DAMAGE))
    end

    return multiplier
end

--- @return number accuracy bonus
--- @param target BaseHero
function OriginInfo:CalculateAccuracyFactionBonus(target)
    local accuracy = self.myHero.accuracy:GetValue()
    if self:HasFactionBonus(target.originInfo.faction) then
        return MathUtils.Truncate(accuracy * (1 + HeroConstants.FACTION_BONUS_ACCURACY))
    else
        return accuracy
    end
end

--- @return string
function OriginInfo:ToString()
    local result = ""

    result = result .. string.format("class = %s\n", self.class)
    result = result .. string.format("faction = %s\n", self.faction)

    return result
end