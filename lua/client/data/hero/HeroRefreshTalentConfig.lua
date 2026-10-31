require "lua.client.data.Hero.TalentConfig"
--- @class HeroRefreshTalentConfig
HeroRefreshTalentConfig = Class(HeroRefreshTalentConfig)

function HeroRefreshTalentConfig:Ctor()
    --- @type Dictionary
    self.talentConfigDict = Dictionary()
    self:Init()
end

function HeroRefreshTalentConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/item/talent/talent_config.csv")
    local data = nil
    local talentConfigList
    for i = 1, #parsedData do
        data = parsedData[i]
        if data.slot ~= nil then
            talentConfigList = List()
            self.talentConfigDict:Add(tonumber(data.slot), talentConfigList)
        end
        talentConfigList:Add(TalentConfig(data))
    end
end

function HeroRefreshTalentConfig:GetStarUnlockTalent()
    return 13
end

--- @param slotEquipmentType SlotEquipmentType -- Talent or Talent2
--- @return List -- <TalentConfig>
function HeroRefreshTalentConfig:GetTalentConfigListBySlotEquipment(slotEquipmentType)
    return self.talentConfigDict:Get(slotEquipmentType)
end


return HeroRefreshTalentConfig