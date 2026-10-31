--- @class TempleSummonResultInBound
TempleSummonResultInBound = Class(TempleSummonResultInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TempleSummonResultInBound:Ctor(buffer)
    --- @type HeroFactionType
    self.factionType = buffer:GetByte()
    --- @type boolean
    self.isUseGem = buffer:GetBool()
    --- @type number
    self.prophetWoodBonus = buffer:GetShort()

    local sizeOfHeroFragment = buffer:GetByte()
    self.heroFragmentDict = Dictionary()
    for i = 1, sizeOfHeroFragment do
        local fragmentId = buffer:GetInt()
        local number = buffer:GetShort()
        local heroFragment = self.heroFragmentDict:Get(fragmentId)
        self.heroFragmentDict:Add(fragmentId, heroFragment and heroFragment + number or number)
        InventoryUtils.Add(ResourceType.HeroFragment, fragmentId, number)
    end
    InventoryUtils.Add(ResourceType.Money, MoneyType.PROPHET_WOOD, self.prophetWoodBonus)
end

--- @return void
function TempleSummonResultInBound:ToString()
    return LogUtils.ToDetail(self)
end