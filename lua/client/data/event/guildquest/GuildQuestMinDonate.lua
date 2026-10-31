--- @class GuildQuestMinDonate
GuildQuestMinDonate = Class(GuildQuestMinDonate)

--- @return void
function GuildQuestMinDonate:Ctor()
    ---@type Dictionary
    self.dictMinDonate = Dictionary()
end

--- @return void
function GuildQuestMinDonate:ParsedData(data)
    self.dictMinDonate:Add(tonumber(data.min_donation_money_type), tonumber(data.min_donation_money_value))
end

--- @return void
function GuildQuestMinDonate:GetMinDonateByMoneyType(id)
    return self.dictMinDonate:Get(id)
end