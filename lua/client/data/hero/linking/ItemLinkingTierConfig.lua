require("lua.client.data.Hero.Linking.BonusLinkingTierConfig")

--- @class ItemLinkingTierConfig
ItemLinkingTierConfig = Class(ItemLinkingTierConfig)

function ItemLinkingTierConfig:Ctor()
    self.id = nil
    --- @type List
    self.listHero = List()
    --- @type List
    self.listBonus = List()
    --- @type number
    self.minStar = nil
    --- @type boolean
    self.isHide = nil
end

function ItemLinkingTierConfig:ParsedData(parsedData)
    self.id = tonumber(parsedData.id)
    self.listHero = List()
    local heroId = parsedData.affected_hero:Split(";")
    for _, v in ipairs(heroId) do
        self.listHero:Add(tonumber(v))
    end
    self.listBonus = List()
    self.isHide = MathUtils.ToBoolean(parsedData.is_hide)
    self:AddBonus(parsedData)
end

function ItemLinkingTierConfig:AddBonus(parsedData)
    local bonus = BonusLinkingTierConfig()
    bonus:ParsedData(parsedData)
    if self.minStar == nil or self.minStar > bonus.star then
        self.minStar = bonus.star
    end
    self.listBonus:Add(bonus)
end

--- @return number
function ItemLinkingTierConfig:GetHeroIdBySlotIndex(slotIndex)
    return self.listHero:Get(slotIndex)
end