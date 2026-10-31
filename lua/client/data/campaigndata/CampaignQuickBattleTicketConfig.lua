require "lua.client.data.CampaignData.QuickBattleTicketData"

local CAMPAIGN_QUICK_BATTLE_TICKET_PATH = "csv/campaign/quick_battle/campaign_quick_battle_ticket_config.csv"

--- @class CampaignQuickBattleTicketConfig
CampaignQuickBattleTicketConfig = Class(CampaignQuickBattleTicketConfig)

function CampaignQuickBattleTicketConfig:Ctor()
    --- @type Dictionary--<number, QuickBattleTicketData>
    self.battleTicketDictionary = Dictionary()

    self:InitData()
end

function CampaignQuickBattleTicketConfig:InitData()
    self:ParseCsv(CsvReaderUtils.ReadAndParseLocalFile(CAMPAIGN_QUICK_BATTLE_TICKET_PATH))
end

--- @data string
function CampaignQuickBattleTicketConfig:ParseCsv(parsedData)
    for _, v in ipairs(parsedData) do
        ---@type QuickBattleTicketData
        local quickTicket = QuickBattleTicketData()
        quickTicket:ParseCsv(v)
        self.battleTicketDictionary:Add(quickTicket.id, quickTicket)
    end
end

--- @return QuickBattleTicketData
--- @param ticketId number
function CampaignQuickBattleTicketConfig:GetTicket(ticketId)
    return self.battleTicketDictionary:Get(ticketId)
end

--- @return QuickBattleTicketData
--- @param resourceType number
--- @param resourceId number
function CampaignQuickBattleTicketConfig:GetListQuickBattle(resourceType, resourceId)
    local list = List()
    ---@param v QuickBattleTicketData
    for i, v in pairs(self.battleTicketDictionary:GetItems()) do
        if v.resourceType == resourceType and v.resourceId == resourceId then
            list:Add(v)
        end
    end
    list:SortWithMethod(QuickBattleTicketData.SortTime)
    return list
end

return CampaignQuickBattleTicketConfig