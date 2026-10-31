--- @class HeroAllUnlockOutBound : OutBound
HeroAllUnlockOutBound = Class(HeroAllUnlockOutBound, OutBound)

--- @return void
function HeroAllUnlockOutBound:Ctor(...)
    --- @type List
    self.listHeroInventoryId = List()
    local args = {...}
    for i = 1, #args do
        self.listHeroInventoryId:Add(args[i])
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroAllUnlockOutBound:Serialize(buffer)
    buffer:PutByte(self.listHeroInventoryId:Count())
    for i, v in pairs(self.listHeroInventoryId:GetItems()) do
        buffer:PutLong(v)
    end
end