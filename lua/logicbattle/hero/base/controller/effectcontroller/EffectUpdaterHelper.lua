--- @class EffectUpdaterHelper
EffectUpdaterHelper = Class(EffectUpdaterHelper)

--- @return void
--- @param effectController EffectController
function EffectUpdaterHelper:Ctor(effectController)
    --- @type EffectController
    self.effectController = effectController

    --- @type DirtyList
    self.effectList = self.effectController.effectList
end

--- @return void
--- call at start of each round
function EffectUpdaterHelper:UpdateBeforeRound()
    self:_Update(self._UpdateBeforeRound)
end

--- @return void
--- call at end of each round
function EffectUpdaterHelper:UpdateAfterRound()
    self:_Update(self._UpdateAfterRound)

    local effectsToRemove = List()
    local i = 1
    while i <= self.effectList:Count() do
        ---@type  BaseEffect
        local effect = self.effectList:Get(i)
        if effect:IsShouldRemove() then
            effectsToRemove:Add(effect)
        end
        i = i + 1
    end
    self.effectController:_RemoveEffects(effectsToRemove)
end

--- @return void
--- @param callback function this function will be executed per effect
function EffectUpdaterHelper:_Update(callback)
    if self.effectList:Count() > 0 then
        local updatedEffects = List()

        self.effectList:SetDirty(true)
        while self.effectList:IsDirty() do
            --- Update order: Bond -> Dot -> Heal -> Others
            self.effectList:Sort(self, self._CompareEffect)
            self.effectList:SetDirty(false)

            local i = 1
            while i <= self.effectList:Count() do
                ---@type  BaseEffect
                local effect = self.effectList:Get(i)
                if updatedEffects:IsContainValue(effect) == false then
                    callback(self, effect)
                    updatedEffects:Add(effect)

                    if self.effectList:IsDirty() then
                        break
                    end
                end
                i = i + 1
            end
        end
    end
end

---------------------------------------- Callback ----------------------------------------
--- @return void
function EffectUpdaterHelper:_UpdateBeforeRound(effect)
    effect:UpdateBeforeRound()
end

--- @return void
function EffectUpdaterHelper:_UpdateAfterRound(effect)
    effect:UpdateAfterRound()
end

--- @return number
--- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
---@param first BaseEffect
---@param second BaseEffect
function EffectUpdaterHelper:_CompareEffect(first, second)
    local effect1_Point = 100000
    local effect2_Point = 100000

    if first:IsHealEffect() then
        effect1_Point = 10
    elseif first:IsDotEffect() then
        effect1_Point = 1
    end

    if second:IsHealEffect() then
        effect2_Point = 10
    elseif second:IsDotEffect() then
        effect2_Point = 1
    end

    return effect1_Point - effect2_Point
end