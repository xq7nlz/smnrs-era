--- @class EffectOnMarBarMgr
EffectOnMarBarMgr = Class(EffectOnMarBarMgr)

--- @param clientHeroEffectMgr ClientHeroEffectMgr
function EffectOnMarBarMgr:Ctor(clientHeroEffectMgr)
    self.clientHeroEffectMgr = clientHeroEffectMgr
    self.uiHeroStatusBar = clientHeroEffectMgr.uiHeroStatusBar

    --- @type Dictionary {EffectTypeLog, UIBattleMarkIcon}
    self.effectMarkOnBarDictionary = Dictionary()
    --- @type Dictionary
    self.drownMarkByInitiator = Dictionary()
end

--- @param effectLogType EffectLogType
--- @param clientEffectDetail ClientEffectDetail
function EffectOnMarBarMgr:UpdateEffectMarkIconByType(effectLogType, clientEffectDetail)
    if effectLogType ~= EffectLogType.DROWNING_MARK then
        local isBuff = ClientActionResultUtils.IsBuffTypeMarkOnBar(effectLogType)
        local stack = clientEffectDetail:GetStack(isBuff)
        if stack > 0 then
            local uiBattleMarkIcon = self:GetUiBattleMarkByType(effectLogType)
            uiBattleMarkIcon:SetStack(stack)
        else
            self:ReleaseMarkEffectOnBarByType(effectLogType)
        end
    end
end

--- @param effectLogType EffectLogType
--- @param effectChangeResult BaseActionResult
function EffectOnMarBarMgr:UpdateEffectByAction(effectLogType, effectChangeResult)
    if effectLogType == EffectLogType.DROWNING_MARK then
        self:UpdateDrowningMarkAction(effectChangeResult)
    end
end

--- @return UIBattleMarkIcon
--- @param effectLogType EffectLogType
function EffectOnMarBarMgr:GetMoreMarkIcon(effectLogType)
    local mark = zg.battleEffectMgr:GetUIBattleMarkIcon(effectLogType)
    self.uiHeroStatusBar:AddMarkEffectIcon(mark)
    if effectLogType == EffectLogType.DROWNING_MARK then
        mark:FixedTextMarkPosition(U_Vector3.zero)
        mark:FixedTextSize(30)
    else
        mark:FixedTextMarkPosition(U_Vector3(20, -21.17, 0))
        mark:FixedTextSize(20)
    end
    self.effectMarkOnBarDictionary:Add(effectLogType, mark)
    return mark
end

function EffectOnMarBarMgr:Release()
    --- @param effectLogType EffectLogType
    for effectLogType, _ in pairs(self.effectMarkOnBarDictionary:GetItems()) do
        self:ReleaseMarkEffectOnBarByType(effectLogType)
    end
end

--- @param drowningMarkResult DrowningMarkResult
function EffectOnMarBarMgr:UpdateDrowningMarkAction(drowningMarkResult)
    local effectLogType = EffectLogType.DROWNING_MARK
    local duration = drowningMarkResult.remainingRound
    local initiator = drowningMarkResult.initiator

    local drowningMarkChangeType = drowningMarkResult.drowningMarkChangeType
    if drowningMarkChangeType == DrowningMarkChangeType.ADD
            or drowningMarkChangeType == DrowningMarkChangeType.CHANGE_DURATION then
        local currentDuration = self.drownMarkByInitiator:Get(initiator)
        if currentDuration == nil then
            self.drownMarkByInitiator:Add(initiator, duration)
        elseif duration < currentDuration then
            self.drownMarkByInitiator:Add(initiator, duration)
        end
    elseif drowningMarkChangeType == DrowningMarkChangeType.REMOVE then
        self.drownMarkByInitiator:RemoveByKey(initiator)
    end
    if self.drownMarkByInitiator:Count() == 0 then
        self:ReleaseMarkEffectOnBarByType(effectLogType)
    else
        local minDuration
        --- @param v number
        for _, v in pairs(self.drownMarkByInitiator:GetItems()) do
            if minDuration == nil then
                minDuration = v
            elseif v < minDuration then
                minDuration = v
            end
        end
        local uiBattleMarkIcon = self:GetUiBattleMarkByType(effectLogType)
        uiBattleMarkIcon:SetStack(minDuration)
    end
end

--- @return UIBattleMarkIcon
function EffectOnMarBarMgr:GetUiBattleMarkByType(effectLogType)
    local uiBattleMarkIcon = self.effectMarkOnBarDictionary:Get(effectLogType)
    if uiBattleMarkIcon == nil then
        uiBattleMarkIcon = self:GetMoreMarkIcon(effectLogType)
    end
    return uiBattleMarkIcon
end

function EffectOnMarBarMgr:ReleaseMarkEffectOnBarByType(effectLogType)
    --- @type UIBattleMarkIcon
    local uiBattleMarkIcon = self.effectMarkOnBarDictionary:Get(effectLogType)
    if uiBattleMarkIcon ~= nil then
        uiBattleMarkIcon:Release()
    end
    self.effectMarkOnBarDictionary:RemoveByKey(effectLogType)
end