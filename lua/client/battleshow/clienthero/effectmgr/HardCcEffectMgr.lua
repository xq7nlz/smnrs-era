--- @class HardCcEffectMgr
HardCcEffectMgr = Class(HardCcEffectMgr)
local maxPetrifyDuration = 3

--- @param clientHeroEffectMgr ClientHeroEffectMgr
function HardCcEffectMgr:Ctor(clientHeroEffectMgr)
    self.clientHeroEffectMgr = clientHeroEffectMgr
    self.clientBattleShowController = clientHeroEffectMgr.clientBattleShowController
    self.uiHeroStatusBar = clientHeroEffectMgr.uiHeroStatusBar
    self.clientHero = clientHeroEffectMgr.clientHero

    --- @type Dictionary {EffectLogType, table{stackCount, UnityEngine.BattleEffect}
    self.ccEffectDictionary = Dictionary()
    --- @type EffectLogType
    self._priorityEffectShow = nil
end

--- @param effectChangeResult EffectChangeResult
--- @param serverRound number
function HardCcEffectMgr:UpdateCCEffect(effectChangeResult, serverRound)
    local effectLogType = effectChangeResult.effectLogType
    local effectChangeType = effectChangeResult.effectChangeType

    --- @type {stackCount, BattleEffect}
    local ccEffect = self.ccEffectDictionary:Get(effectLogType)
    if effectChangeType == EffectChangeType.ADD then
        if ccEffect == nil then
            ccEffect = {}
            ccEffect.stackCount = 1
            self.ccEffectDictionary:Add(effectLogType, ccEffect)

            if self._priorityEffectShow ~= nil then
                local lastCC = self.ccEffectDictionary:Get(self._priorityEffectShow)
                if lastCC.battleEffect ~= nil then
                    lastCC.battleEffect:Release()
                    lastCC.battleEffect = nil
                    --self.ccEffectDictionary:Add(self._priorityEffectShow, lastCC)
                end
                self.clientHero:OnRemoveCCEffect(self._priorityEffectShow)
            end
            self._priorityEffectShow = effectLogType
            self.clientHero:OnAddCCEffect(effectLogType)
        else
            if effectLogType ~= self._priorityEffectShow then
                local ccPriority = self.ccEffectDictionary:Get(self._priorityEffectShow)
                if ccPriority ~= nil then
                    if ccPriority.battleEffect ~= nil then
                        ccPriority.battleEffect:Release()
                        ccPriority.battleEffect = nil
                        --self.ccEffectDictionary:Add(self._priorityEffectShow, ccPriority)
                    end
                end
                self.clientHero:OnRemoveCCEffect(self._priorityEffectShow)
                self.clientHero:OnAddCCEffect(effectLogType)
                self._priorityEffectShow = effectLogType
            end
            ccEffect.stackCount = ccEffect.stackCount + 1
            if effectLogType == EffectLogType.PETRIFY and ccEffect.stackCount > maxPetrifyDuration - 1 then
                ccEffect.stackCount = maxPetrifyDuration - 1
            end
            --self.ccEffectDictionary:Add(effectLogType, ccEffect)
        end
    elseif effectChangeType == EffectChangeType.REMOVE then
        if effectLogType == EffectLogType.FREEZE and ccEffect ~= nil then
            if ccEffect.stackCount == 1 then
                if ccEffect.battleEffect ~= nil then
                    ccEffect.battleEffect:Release()
                    ccEffect.battleEffect = nil
                    --self.ccEffectDictionary:Add(effectLogType, ccEffect)
                end
                if serverRound == 0 then
                    --- Freeze gone out
                else
                    --- Freeze break
                    local fxBreak = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "ice_broke")
                    fxBreak:SetToHeroAnchor(self.clientHero)
                end
                self.ccEffectDictionary:RemoveByKey(effectLogType)
                self.clientHero:OnRemoveCCEffect(effectLogType)
                --self._priorityEffectShow = nil
                self:UpdatePriorityEffect()
            elseif ccEffect.stackCount > 1 then
                ccEffect.stackCount = ccEffect.stackCount - 1
                --self.ccEffectDictionary:Add(effectLogType, ccEffect)
            end
        elseif ccEffect ~= nil then
            if ccEffect.stackCount == 1 then
                if ccEffect.battleEffect ~= nil then
                    ccEffect.battleEffect:Release()
                    ccEffect.battleEffect = nil
                    --self.ccEffectDictionary:Add(effectLogType, ccEffect)
                end
                self.ccEffectDictionary:RemoveByKey(effectLogType)
                self.clientHero:OnRemoveCCEffect(effectLogType)
                self:UpdatePriorityEffect()
            elseif ccEffect.stackCount > 1 then
                ccEffect.stackCount = ccEffect.stackCount - 1
                --self.ccEffectDictionary:Add(effectLogType, ccEffect)
            end
        end
    end
end

--- @return EffectLogType
function HardCcEffectMgr:PriorityEffectShow()
    return self._priorityEffectShow
end

--- @param effectLogType EffectLogType
function HardCcEffectMgr:GetCcEffectTable(effectLogType)
    return self.ccEffectDictionary:Get(effectLogType)
end

function HardCcEffectMgr:OnAddCcEffect(effectLogType)
    local ccEffect = self:GetCcEffectTable(effectLogType)
    if ccEffect ~= nil then
        if ClientConfigUtils.IsCCEffectHasInstance(effectLogType) == true and ccEffect.battleEffect == nil then
            ccEffect.battleEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_type_" .. effectLogType)
        end
        if ccEffect.battleEffect ~= nil then
            ccEffect.battleEffect:SetToHeroAnchor(self.clientHero)
        end
        self.ccEffectDictionary:Add(effectLogType, ccEffect)
    end
end

function HardCcEffectMgr:Release()
    for effectLogType, ccEffect in pairs(self.ccEffectDictionary:GetItems()) do
        if ccEffect.battleEffect ~= nil then
            ccEffect.battleEffect:Release()
            ccEffect.battleEffect = nil
        end
        self.ccEffectDictionary:RemoveByKey(effectLogType)
        self.clientHero:OnRemoveCCEffect(effectLogType)
    end
    self._priorityEffectShow = nil
end

function HardCcEffectMgr:UpdatePriorityEffect()
    if self.ccEffectDictionary:IsContainKey(self._priorityEffectShow) == true then
        self.clientHero:OnAddCCEffect(self._priorityEffectShow)
        return
    end
    if self.ccEffectDictionary:Count() > 0 then
        local tableEffect = self.ccEffectDictionary:GetItems()
        for k, _ in pairs(tableEffect) do
            if self._priorityEffectShow ~= k then
                local ccLastPriority = self.ccEffectDictionary:Get(self._priorityEffectShow)
                if ccLastPriority ~= nil then
                    if ccLastPriority.battleEffect ~= nil then
                        ccLastPriority.battleEffect:Release()
                        ccLastPriority.battleEffect = nil
                    end
                end
                self._priorityEffectShow = k
                self.clientHero:OnAddCCEffect(k)
                return
            end
        end
        self.clientHero:OnAddCCEffect(self._priorityEffectShow)
        return
    end
    self._priorityEffectShow = nil
end