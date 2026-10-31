--- @class HeroLockOutBound : OutBound
HeroLockOutBound = Class(HeroLockOutBound, OutBound)

--- @return void
function HeroLockOutBound:Ctor()
    --- @type List
    self.listLock = List()
    --- @type List
    self.listUnlock = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroLockOutBound:Serialize(buffer)
    buffer:PutByte(self.listUnlock:Count())
    for _, v in pairs(self.listUnlock:GetItems()) do
        buffer:PutLong(v)
    end

    buffer:PutByte(self.listLock:Count())
    for _, v in pairs(self.listLock:GetItems()) do
        buffer:PutLong(v)
    end
end