--- @class DomainFormationInBound
DomainFormationInBound = Class(DomainFormationInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function DomainFormationInBound:Ctor(buffer)
    self.summonerId = nil
    self.formation = nil

    --- @type Dictionary
    self.frontLineDict = Dictionary()
    --- @type Dictionary
    self.backLineDict = Dictionary()

    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainFormationInBound:ReadBuffer(buffer)
    self.summonerId = buffer:GetByte()
    self.formationId = buffer:GetByte()

    self.frontLineDict:Clear()
    local frontLine = buffer:GetByte()
    for _ = 1, frontLine do
        self.frontLineDict:Add(buffer:GetByte(), HeroResource.CreateInstanceByBuffer(buffer))
    end

    self.backLineDict:Clear()
    local backLine = buffer:GetByte()
    for _ = 1, backLine do
        self.backLineDict:Add(buffer:GetByte(), HeroResource.CreateInstanceByBuffer(buffer))
    end
end


