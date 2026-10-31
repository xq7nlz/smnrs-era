
--- @class ClientActionDetail
ClientActionDetail = Class(ClientActionDetail)

--- @return void
--- @param type ActionResultType
function ClientActionDetail:Ctor(type)
    self.type = type

    self.actionResults = List()
end

--- @return void
--- @param action BaseActionResult
function ClientActionDetail:Add(action)
    self.actionResults:Add(action)
end

--- @return void
function ClientActionDetail:Execute()
    assert(false, "Need override this method")
end

--- @return table
function ClientActionDetail:GetItems()
    assert(false, "Need override this method")
end

--- @return string
function ClientActionDetail:ToString()
    return string.format("Action[%s]", self.type)
end

--- @param clientActionDetail ClientActionDetail
function ClientActionDetail:OverloadAction(clientActionDetail)
    self.actionResults:AddAll(clientActionDetail.actionResults)
end


