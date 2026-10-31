--- @class ClientDrowningMarkEffectDetail : ClientEffectDetail
ClientDrowningMarkEffectDetail = Class(ClientDrowningMarkEffectDetail, ClientEffectDetail)

--- @return void
--- @param effectLogType EffectLogType
function ClientDrowningMarkEffectDetail:Ctor(effectLogType)
    self.effectChangeResult = nil
    ClientEffectDetail.Ctor(self, effectLogType)
end

--- @param effectChangeResult EffectChangeResult
function ClientDrowningMarkEffectDetail:ChangeStack(effectChangeResult)
    self.effectChangeResult = effectChangeResult
    ClientEffectDetail.ChangeStack(self, effectChangeResult)
end

--- @return number
--- @param isBuff boolean
function ClientDrowningMarkEffectDetail:GetStack(isBuff)
    return ClientEffectDetail.GetStack(self, self.effectChangeResult.isBuff)
end