--- @class Hero30011_Utils
Hero30011_Utils = {}

--- @return boolean
--- @param target BaseHero
--- @param skillId number
function Hero30011_Utils.IsContainSkavenPoison(target, skillId)
    local poisonList = target.effectController:GetEffectWithType(EffectType.POISON)

    local i = 1
    while i <= poisonList:Count() do
        local poison = poisonList:Get(i)
        if TableUtils.IsContainKey(poison, "skillId") then
            if poison.skillId == skillId then
                return true
            end
        end
        i = i + 1
    end

    return false
end

return Hero30011_Skill1