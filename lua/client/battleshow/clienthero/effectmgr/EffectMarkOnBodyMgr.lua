--- @class EffectMarkOnBodyMgr
EffectMarkOnBodyMgr = Class(EffectMarkOnBodyMgr)

--- @param clientHeroEffectMgr ClientHeroEffectMgr
function EffectMarkOnBodyMgr:Ctor(clientHeroEffectMgr)
    self.clientHeroEffectMgr = clientHeroEffectMgr
    self.clientBattleShowController = clientHeroEffectMgr.clientBattleShowController
    self.uiHeroStatusBar = clientHeroEffectMgr.uiHeroStatusBar
    self.clientHero = clientHeroEffectMgr.clientHero
    --- @type Dictionary {EffectTypeLog, ClientEffect}
    self.effectMarkDictionary = Dictionary()
end

--- @param effectLogType EffectLogType
function EffectMarkOnBodyMgr:UpdateEffectMarkOnBody(effectLogType, clientEffectDetail)
    --- @type ClientEffect
    local effectMark = self.effectMarkDictionary:Get(effectLogType)
    local initiator = self.clientBattleShowController:GetClientHeroByBaseHero(clientEffectDetail.initiator)
    local stackCount = 0
    if clientEffectDetail.buff > 0 then
        stackCount = clientEffectDetail.buff
    elseif clientEffectDetail.debuff > 0 then
        stackCount = clientEffectDetail.debuff
    else
        if effectMark ~= nil then
            effectMark:Release()
        end
        self.effectMarkDictionary:RemoveByKey(effectLogType)
        self.clientHero:OnRemoveEffect(effectLogType)
        if effectLogType == EffectLogType.DIVINE_SHIELD then
            local effectName = "effect_type_" .. effectLogType .. "_broke"
            if initiator.skinId ~= -1 then
                effectName = effectName .. "_" .. initiator.skinId
            end
            local clientEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
            clientEffect:SetToHeroAnchor(self.clientHero)
        end
        return
    end

    if effectMark ~= nil then
        effectMark.Stack = stackCount
    else
        local effectName = "effect_type_" .. effectLogType
        if effectLogType == EffectLogType.NON_TARGETED_MARK then
            effectName = effectName .. "_" .. ClientConfigUtils.GetFactionIdByHeroId(self.clientHero.baseHero.id)
        end
        if effectLogType == EffectLogType.DIVINE_SHIELD then
            if initiator.skinId ~= -1 then
                effectName = effectName .. "_" .. initiator.skinId
            end
        end
        effectMark = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
        if effectMark ~= nil then
            effectMark.Stack = stackCount
            effectMark:SetToHeroAnchor(self.clientHero)
            self.effectMarkDictionary:Add(effectLogType, effectMark)
            self.clientHero:OnAddEffect(effectLogType)
        else
            assert(false, "Missing Mark EffectLogType " .. effectLogType)
        end
    end
end

function EffectMarkOnBodyMgr:Release()
    for effectLogType, _ in pairs(self.effectMarkDictionary:GetItems()) do
        if ClientActionResultUtils.IsTalentBuffEffect(effectLogType) == false then
            local battleMark = self.effectMarkDictionary:Get(effectLogType)
            if battleMark ~= nil then
                battleMark:Release()
                battleMark = nil
            end
            self.effectMarkDictionary:RemoveByKey(effectLogType)
        end
    end
end