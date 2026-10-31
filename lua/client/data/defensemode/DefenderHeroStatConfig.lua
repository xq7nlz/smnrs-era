--- @class DefenderHeroStatConfig
DefenderHeroStatConfig = Class(DefenderHeroStatConfig)

function DefenderHeroStatConfig:Ctor(parsedData)
    ---@type number
    self.id = tonumber(parsedData.id)
    ---@type Dictionary
    self.heroItem = Dictionary()
    for i = 1, 7 do
        self.heroItem:Add(i, tonumber(parsedData[string.format("item_%s", i)]))
    end
    ---@type List
    self.listLevel = List()
    local lv = parsedData.level:Split(";")
    for i, v in ipairs(lv) do
        self.listLevel:Add(tonumber(v))
    end
    ---@type List
    self.listStar = List()
    local star = parsedData.star:Split(";")
    for i, v in ipairs(star) do
        self.listStar:Add(tonumber(v))
    end
end

---@return HeroResource
function DefenderHeroStatConfig:CreateHeroResource(heroId, index)
    return HeroResource.CreateInstance(nil, heroId, self.listStar:Get(index), self.listLevel:Get(index), self.heroItem)
end