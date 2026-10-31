--- @class DomainContributeHeroListInBound
DomainContributeHeroListInBound = Class(DomainContributeHeroListInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function DomainContributeHeroListInBound:Ctor(buffer)
    --- @type List
    self.listHeroContribute = List()

    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainContributeHeroListInBound:ReadBuffer(buffer)
    self.listHeroContribute:Clear()
    local heroContributeCount = buffer:GetByte()
    for _ = 1, heroContributeCount do
        self.listHeroContribute:Add(buffer:GetLong())
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DomainContributeHeroListInBound:Serialize(buffer)
    buffer:PutByte(self.listHeroContribute:Count())
    for _, id in ipairs(self.listHeroContribute:GetItems()) do
        buffer:PutLong(id)
    end
end