
--- @class RegenerateClientActionDetail : ClientActionDetail
RegenerateClientActionDetail = Class(RegenerateClientActionDetail, ClientActionDetail)

--- @return void
--- @param type ActionResultType
function RegenerateClientActionDetail:Ctor(type)
    ClientActionDetail.Ctor(self, type)

    --- @type BaseActionResult[] List
    self.actionList = List()
    ----- @type BaseActionResult[] List
    --self.regenerateList = List()
end

--- @return void
function RegenerateClientActionDetail:Execute()
    for i = 1, self.actionResults:Count() do
        local action = self.actionResults:Get(i)
        --if action.isTransform then
        --    self.regenerateList:Add(action)
        --else
            self.actionList:Add(action)
        --end
    end
end

--- @return BaseActionResult[] List
function RegenerateClientActionDetail:GetItems()
    return self.actionList
end

--- @return BaseActionResult[] List
function RegenerateClientActionDetail:GetRegenerateItems()
    return self.regenerateList
end

--- @return void
function RegenerateClientActionDetail:ToString()
    local content = string.format("[ACTION %s]\n", self.type)
    for key, value in pairs(self.actionList:GetItems()) do
        content = content .. value:ToString() .. "\n"
    end

    --for key, value in pairs(self.regenerateList:GetItems()) do
    --    content = content .. value:ToString() .. "\n"
    --end

    return content
end