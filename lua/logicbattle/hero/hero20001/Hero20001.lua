--- @class Hero20001 Icarus
Hero20001 = Class(Hero20001, BaseHero)

function Hero20001:Ctor()
    BaseHero.Ctor(self)

    --- @type boolean  egg state or not
    self.isSpecialState = false
end

--- @return Hero20001
function Hero20001:CreateInstance()
    return Hero20001()
end

--- @return HeroInitializer
function Hero20001:CreateInitializer()
    return Hero20001_Initializer(self)
end

---------------------------------------- Battle actions ----------------------------------------
--- @return List<BaseActionResult>, boolean
--- @param actionType ActionType
function Hero20001:DoAction(actionType)
    if self.effectController:IsContainEffectType(EffectType.REBORN) then
        local actionResults, isEndTurn = List(), true
        return actionResults, isEndTurn
    else
        return BaseHero.DoAction(self, actionType)
    end
end

return Hero20001