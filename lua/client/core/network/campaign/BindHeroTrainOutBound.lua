--- @class BindHeroTrainOutBound : OutBound
BindHeroTrainOutBound = Class(BindHeroTrainOutBound, OutBound)

--- @return void
function BindHeroTrainOutBound:Ctor()
    self.listHero = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BindHeroTrainOutBound:Serialize(buffer)
    buffer:PutByte(self.listHero:Count())
    for _, v in ipairs(self.listHero:GetItems()) do
        buffer:PutLong(v)
    end
end