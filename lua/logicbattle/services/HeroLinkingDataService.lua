--- @class HeroLinkingDataService
HeroLinkingDataService = Class(HeroLinkingDataService)

--- @return void
function HeroLinkingDataService:Ctor()

    --- @type Dictionary<number, BaseLinking>
    self.heroLinkingEntries = Dictionary()
end

---------------------------------------- Getters ----------------------------------------
--- @return Dictionary<number, BaseLinking>
function HeroLinkingDataService:GetHeroLinkingEntries()
    return self.heroLinkingEntries
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param csv string
function HeroLinkingDataService:AddHeroLinkingData(csv)
    local parsedData = CsvReader.ReadContent(csv)

    --- @type BaseLinking
    local linking

    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            ---@type BaseLinking
            linking = BaseLinking()
            linking:ParseCsv(parsedData[i])

            self.heroLinkingEntries:Add(linking.id, linking)
        end

        if linking ~= nil then
            if data.level ~= nil then
                ---@type BonusTier
                local bonus = BonusTier()
                bonus:ParseCsv(parsedData[i])
                linking:AddBonusTier(bonus)
            end
        else
            assert(false)
        end
    end
end
---------------------------------------- Validate ----------------------------------------
--- @return void
function HeroLinkingDataService:Validate()
    assert(self.heroLinkingEntries ~= nil and self.heroLinkingEntries:Count() > 0)
end