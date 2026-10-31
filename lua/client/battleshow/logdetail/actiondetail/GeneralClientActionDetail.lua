
--- @class GeneralClientActionDetail : ClientActionDetail
GeneralClientActionDetail = Class(GeneralClientActionDetail, ClientActionDetail)

--- @return void
--- @param type ActionResultType
function GeneralClientActionDetail:Ctor(type)
    ClientActionDetail.Ctor(self, type)

    --- @type List<BaseActionResult>
    self.actionList = List()
end

--- @return void
function GeneralClientActionDetail:Execute()
    for i = 1, self.actionResults:Count() do
        local action = self.actionResults:Get(i)
        self.actionList:Add(action)
    end
end

--- @return List<BaseActionResult>
function GeneralClientActionDetail:GetItems()
    return self.actionList
end

--- @return string
function GeneralClientActionDetail:ToString()
    local content = string.format("[ACTION %s]\n", self.type)
    for key, value in pairs(self.actionList:GetItems()) do
        content = content .. value:ToString() .. "\n"
    end
    return content
end