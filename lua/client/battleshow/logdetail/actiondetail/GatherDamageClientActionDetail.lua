
--- @class GatherDamageClientActionDetail : ClientActionDetail
GatherDamageClientActionDetail = Class(GatherDamageClientActionDetail, ClientActionDetail)

--- @return void
--- @param type ActionResultType
function GatherDamageClientActionDetail:Ctor(type)
    ClientActionDetail.Ctor(self, type)
    --- @type Dictionary<BaseHero, BaseActionResult>
    self.targetDict = Dictionary()
end

--- @return void
function GatherDamageClientActionDetail:Execute()
    local minIndex
    for i = 1, self.actionResults:Count() do
        --- @type BaseActionResult
        local action = self.actionResults:Get(i)
        if minIndex == nil or minIndex > action.index then
            minIndex = action.index
        end
        local target = action.target
        if self.targetDict:IsContainKey(target) then
            --- @type BaseActionResult
            local actionDetail = self.targetDict:Get(target)
            actionDetail.damage = actionDetail.damage + action.damage
            actionDetail.index = minIndex
            actionDetail.targetHpPercent = action.targetHpPercent
        else
            self.targetDict:Add(target, action)
        end
    end
end

--- @return List<BaseActionResult>
function GatherDamageClientActionDetail:GetItems()
    local listItems = List()
    for _, value in pairs(self.targetDict:GetItems()) do
        listItems:Add(value)
    end
    return listItems
end

--- @return void
function GatherDamageClientActionDetail:ToString()
    local content = "[DOT]\n"
    for key, value in pairs(self.targetDict:GetItems()) do
        content = content .. value:ToString() .. "\n"
    end
    return content
end