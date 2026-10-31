--- @class SummonHeroFragmentInBound
SummonHeroFragmentInBound = Class(SummonHeroFragmentInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SummonHeroFragmentInBound:Ctor(buffer)
    ---@type number
    self.size = buffer:GetShort()
    ---@type List
    self.listHeroResource = List()
    for i = 1, self.size do
        self.listHeroResource:Add(HeroResource.CreateInstanceByBuffer(buffer))
    end
end

--- @return void
function SummonHeroFragmentInBound:ToString()
    return LogUtils.ToDetail(self)
end