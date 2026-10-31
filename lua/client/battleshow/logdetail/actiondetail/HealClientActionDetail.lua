
--- @class HealClientActionDetail : ClientActionDetail
HealClientActionDetail = Class(HealClientActionDetail, ClientActionDetail)

--- @return void
--- @param type ActionResultType
function HealClientActionDetail:Ctor(type)
    ClientActionDetail.Ctor(self, type)
    --- @type Dictionary<BaseHero, BaseActionResult>
    self.targetDict = Dictionary()
end

--- @return void
function HealClientActionDetail:Execute()
    for i = 1, self.actionResults:Count() do
        local action = self.actionResults:Get(i)
        if self.targetDict:IsContainKey(action.target) then
            local actionDetail = self.targetDict:Get(action.target)
            actionDetail.healAmount = actionDetail.healAmount + action.healAmount
            actionDetail.index = action.index
            actionDetail.targetHpPercent = action.targetHpPercent

        else
            self.targetDict:Add(action.target, action)
        end
    end
end

--- @return List<BaseActionResult>
function HealClientActionDetail:GetItems()
    local listItems = List()
    for _, value in pairs(self.targetDict:GetItems()) do
        listItems:Add(value)
    end
    return listItems
end

--- @return void
function HealClientActionDetail:ToString()
    local content = "[HEAL]\n"
    for key, value in pairs(self.targetDict:GetItems()) do
        content = content .. value:ToString() .. "\n"
    end
    return content
end