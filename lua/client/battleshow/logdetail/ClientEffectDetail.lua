
--- @class ClientEffectDetail
ClientEffectDetail = Class(ClientEffectDetail)

--- @return void
--- @param effectLogType EffectLogType
function ClientEffectDetail:Ctor(effectLogType)
    self.effectLogType = effectLogType
    self.buff = 0
    self.debuff = 0
end

--- @return void
--- @param effectChangeResult EffectChangeResult
function ClientEffectDetail:ChangeStack(effectChangeResult)
    local isBuff = effectChangeResult.isBuff
    if effectChangeResult.effectChangeType == EffectChangeType.ADD then
        self:IncreaseStack(isBuff)
    else
        self:DecreaseStack(isBuff)
    end
end

--- @return void
--- @param isBuff boolean
function ClientEffectDetail:IncreaseStack(isBuff)
    if isBuff then
        self.buff = self.buff + 1
    else
        self.debuff = self.debuff + 1
    end
end

--- @return void
--- @param isBuff boolean
function ClientEffectDetail:DecreaseStack(isBuff)
    if isBuff then
        self.buff = self.buff - 1
    else
        self.debuff = self.debuff - 1
    end
end

--- @return boolean
function ClientEffectDetail:ShouldRemove()
    if self.buff == 0 and self.debuff == 0 then
        return true
    end
    return false
end

--- @return ClientEffectDetail
function ClientEffectDetail:Clone()
    local clientEffectDetail = ClientEffectDetail(self.effectLogType)
    clientEffectDetail.buff = self.buff
    clientEffectDetail.debuff = self.debuff

    return clientEffectDetail
end

--- @return void
--- @param clientEffectDetail ClientEffectDetail
function ClientEffectDetail:Update(clientEffectDetail)
    self.buff = self.buff + clientEffectDetail.buff
    self.debuff = self.debuff + clientEffectDetail.debuff
end

--- @return void
--- @param clientEffectDetail ClientEffectDetail
function ClientEffectDetail:Replace(clientEffectDetail)
    self.buff = clientEffectDetail.buff
    self.debuff = clientEffectDetail.debuff
end

--- @return number
--- @param isBuff boolean
function ClientEffectDetail:GetStack(isBuff)
    if isBuff then
        return self.buff
    end
    return self.debuff
end

--- @return string
function ClientEffectDetail:ToString()
    return string.format("[TYPE: %3s, buff = %s, debuff = %s]", self.effectLogType, self.buff, self.debuff)
end