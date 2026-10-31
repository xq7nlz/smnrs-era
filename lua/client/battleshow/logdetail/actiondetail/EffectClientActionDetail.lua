
--- @class EffectClientActionDetail : ClientActionDetail
EffectClientActionDetail = Class(EffectClientActionDetail, ClientActionDetail)

--- @return void
--- @param type ActionResultType
function EffectClientActionDetail:Ctor(type)
    ClientActionDetail.Ctor(self, type)
    --- @type Dictionary<BaseHero, ClientEffectLogDetail>
    self.targetDict = Dictionary()
    self.effectCCList = List()
end

--- @return void
function EffectClientActionDetail:Execute()
    for i = 1, self.actionResults:Count() do
        --- @type BaseActionResult
        local action = self.actionResults:Get(i)
        if ClientActionResultUtils.IsEffectShouldBeShowed(action.persistentType, action.effectLogType) then
            --- @type ClientEffectLogDetail
            local effectLogDetail
            if self.targetDict:IsContainKey(action.target) then
                effectLogDetail = self.targetDict:Get(action.target)
                effectLogDetail:AddAction(action)
            else
                effectLogDetail = ClientEffectLogDetail()
                effectLogDetail:AddAction(action)
                self.targetDict:Add(action.target, effectLogDetail)
            end
        elseif ClientActionResultUtils.IsEffectCC(action.effectLogType) then
            self.effectCCList:Add(action)
        else
            --XDebug.Log("NOT EXIST " .. action:ToString())
        end
    end
end

--- @return List<ClientEffectLogDetail>
function EffectClientActionDetail:GetItems()
    local listItems = List()
    --- @param value ClientEffectLogDetail
    for _, value in pairs(self.targetDict:GetItems()) do
        if value:ShouldRemove() == false then
            listItems:Add(value)
        end
    end
    return listItems
end

--- @return List<BaseActionResult>
function EffectClientActionDetail:GetCCItems()
    return self.effectCCList
end

--- @return void
function EffectClientActionDetail:ToString()
    local content = "[EFFECT]\n"
    for key, value in pairs(self.targetDict:GetItems()) do
        content = content .. value:ToString() .. "\n"
    end
    return content
end