--- @class ProphetTreeInBound
ProphetTreeInBound = Class(ProphetTreeInBound)

--- @return void
function ProphetTreeInBound:Ctor()
    self.isConverting = false
    self.heroInventoryId = nil
    self.newHeroId = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function ProphetTreeInBound:ReadBuffer(buffer)
    self.isConverting = buffer:GetBool()
    if self.isConverting == true then
        self.heroInventoryId = buffer:GetLong()
        self.newHeroId = buffer:GetInt()
    end
end