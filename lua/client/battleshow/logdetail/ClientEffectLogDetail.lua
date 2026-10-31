--- @class ClientEffectLogDetail
ClientEffectLogDetail = Class(ClientEffectLogDetail)

--- @return void
function ClientEffectLogDetail:Ctor()
    --- @type ActionResultType
    self.type = ActionResultType.CHANGE_EFFECT
    --- @type BaseHero
    self.target = nil
    --- @type BaseHero
    self.initiator = nil
    --- @type Dictionary<EffectLogType, ClientEffectDetail>
    self.effectDict = Dictionary()
end

--- @return void
--- @param action BaseActionResult
function ClientEffectLogDetail:AddAction(action)
    self.target = action.target
    self.initiator = action.initiator
    --- @type ClientEffectDetail
    local effectDetail
    local effectLogType = action.effectLogType

    if self.effectDict:IsContainKey(effectLogType) then
        effectDetail = self.effectDict:Get(effectLogType)
    else
        effectDetail = ClientEffectLogDetailBuilder.Create(effectLogType,self.initiator)
        self.effectDict:Add(effectLogType, effectDetail)
    end
    effectDetail:ChangeStack(action)
end

--- @return boolean
function ClientEffectLogDetail:ShouldRemove()
    --- @param value ClientEffectDetail
    for key, value in pairs(self.effectDict:GetItems()) do
        if value:ShouldRemove() then
            self.effectDict:RemoveByKey(key)
        end
    end
    return self.effectDict:Count() <= 0
end

--- @return ClientEffectLogDetail
function ClientEffectLogDetail:Clone()
    local clientEffectDetail = ClientEffectLogDetail()
    clientEffectDetail.target = self.target
    for key, value in pairs(self.effectDict:GetItems()) do
        clientEffectDetail.effectDict:Add(key, value:Clone())
    end
    return clientEffectDetail
end

--- @return void
--- @param clientEffectLogDetail ClientEffectLogDetail
function ClientEffectLogDetail:Update(clientEffectLogDetail)
    --- @param key EffectLogType
    --- @param value ClientEffectDetail
    for key, value in pairs(clientEffectLogDetail.effectDict:GetItems()) do
        if self.effectDict:IsContainKey(key) then
            --- @type ClientEffectDetail
            local effectDetail = self.effectDict:Get(key)
            effectDetail:Update(value)
            value:Replace(effectDetail)
        else
            self.effectDict:Add(key, value:Clone())
        end
    end
end

--- @return string
function ClientEffectLogDetail:ToString()
    local content = self.target:ToString() .. " => "
    for key, value in pairs(self.effectDict:GetItems()) do
        content = content .. value:ToString()
    end
    content = content .. "\n"
    return content
end
