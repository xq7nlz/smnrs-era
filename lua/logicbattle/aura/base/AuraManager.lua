--- @class AuraManager
AuraManager = Class(AuraManager)

--- @return void
--- @param eventManager EventManager
function AuraManager:Ctor(eventManager)
    --- @type Dictionary<string, List<BaseAura>>
    self.auraDict = Dictionary()

    ----- @type EventListener
    local heroReviveListener = EventListener(nil, self, self.OnHeroRevive)
    eventManager:AddListener(EventType.HERO_REVIVE, heroReviveListener)

    ----- @type EventListener
    local heroDeadListener = EventListener(nil, self, self.OnHeroDead)
    eventManager:AddListener(EventType.HERO_DEAD, heroDeadListener)
end

---------------------------------------- Manage ----------------------------------------
--- @return void
--- @param aura BaseAura
function AuraManager:AddAura(aura)
    local auraTag = aura:GetAuraTag()

    local similarAuraList = self.auraDict:Get(auraTag)
    if similarAuraList == nil then
        similarAuraList = List()
        self.auraDict:Add(auraTag, similarAuraList)
    end

    similarAuraList:Add(aura)
end

--- @return void
--- @param aura BaseAura
function AuraManager:StartAura(aura)
    local similarAuraList = self:_GetSimilarAuraList(aura)
    self:_StartStrongestAura(similarAuraList)
end

--- @return void
--- @param aura BaseAura
function AuraManager:StopAura(aura)
    aura:Stop()

    local similarAuraList = self:_GetSimilarAuraList(aura)
    self:_StartStrongestAura(similarAuraList)
end

--- @return void
--- @param aura BaseAura
function AuraManager:RecalculateAura(aura)
    aura:Recalculate()

    local similarAuraList = self:_GetSimilarAuraList(aura)
    self:_StartStrongestAura(similarAuraList)
end

--- @return void
--- @param similarAuras List<BaseAura>
--- Start strongest aura and stop all other similar aura
function AuraManager:_StartStrongestAura(similarAuras)
    if similarAuras:Count() > 0 then
        ---@type BaseAura
        local strongestAura = self:_GetStrongestAura(similarAuras)
        if strongestAura ~= nil then
            for i = 1, similarAuras:Count() do
                ---@type BaseAura
                local aura = similarAuras:Get(i)

                if aura == strongestAura then
                    aura:Start()
                else
                    if aura:GetState() == AuraState.RUNNING then
                        aura:StopByStrongerAura()
                    end
                end
            end
        end
    end
end

---------------------------------------- Getters ----------------------------------------
--- @return BaseAura
--- @param similarAuraList List<BaseAura>
function AuraManager:_GetStrongestAura(similarAuraList)
    ---@type BaseAura
    local strongestAura
    for i = 1, similarAuraList:Count() do
        ---@type BaseAura
        local aura = similarAuraList:Get(i)
        if aura:IsInitiatorDead() == false then
            if strongestAura == nil then
                strongestAura = aura
            else
                if aura:Compare(strongestAura) > 0 then
                    strongestAura = aura
                end
            end
        end
    end
    return strongestAura
end

--- @return List<BaseAura>
--- @param aura BaseAura
function AuraManager:_GetSimilarAuraList(aura)
    local auraTag = aura:GetAuraTag()
    ---@type List<BaseAura>
    local similarAuraList = self.auraDict:Get(auraTag)
    if similarAuraList == nil then
        similarAuraList = List()
    end
    return similarAuraList
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param eventData table
function AuraManager:OnHeroRevive(eventData)
    self:_Update()
end

--- @return void
--- @param eventData table
function AuraManager:OnHeroDead(eventData)
    self:_Update()
end

--- @return void
function AuraManager:_Update()
    if self.auraDict:Count() > 0 then
        for _, auraList in pairs(self.auraDict:GetItems()) do
            for i = 1, auraList:Count() do
                ---@type BaseAura
                local aura = auraList:Get(i)
                if aura:IsInitiatorDead() then
                    if aura:GetState() ~= AuraState.STOP then
                        -- hero is dead and aura is still running
                        self:StopAura(aura)
                    end
                else
                    if aura:GetState() == AuraState.STOP then
                        -- hero is alive and aura is not running
                        self:StartAura(aura)
                    end
                end
            end
        end
    end
end