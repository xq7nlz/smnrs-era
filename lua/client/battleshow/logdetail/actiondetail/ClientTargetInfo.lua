
--- @class ClientTargetInfo
ClientTargetInfo = Class(ClientTargetInfo)

--- @return void
--- @param target BaseHero
function ClientTargetInfo:Ctor(target)
    self.target = target

    self.totalValue = 0
end

function ClientTargetInfo:AddValue(value)
    self.totalValue = self.totalValue + value
end
