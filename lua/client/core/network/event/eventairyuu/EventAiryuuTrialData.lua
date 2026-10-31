--- @class EventAiryuuTrialData
EventAiryuuTrialData = Class(EventAiryuuTrialData)

function EventAiryuuTrialData:Ctor(buffer)
    ---@type number
    self.currentStamina = nil
    ---@type number
    self.numberBuy = nil
    ---@type Dictionary
    self.defenderTeamGenerated = Dictionary()
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventAiryuuTrialData:ReadBuffer(buffer)
    ---@type Dictionary
    self.currentStamina = buffer:GetInt()
    self.numberBuy = buffer:GetInt()
    local size = buffer:GetByte()
    for i = 1, size do
        self.defenderTeamGenerated:Add(buffer:GetInt(), buffer:GetInt())
    end
end

function EventAiryuuTrialData:SetCurrentStamina(number)
    self.currentStamina = number
end

function EventAiryuuTrialData:SubCurrentStamina(number)
    self.currentStamina = self.currentStamina - number
    return self.currentStamina
end

function EventAiryuuTrialData:GetCurrentStamina()
    return self.currentStamina
end

function EventAiryuuTrialData:AddCurrentStamina(number)
    self.currentStamina = self.currentStamina + number
    return self.currentStamina
end

function EventAiryuuTrialData:GetNumberBuy()
    return self.numberBuy
end

function EventAiryuuTrialData:AddNumberBuy(number)
    self.numberBuy = self.numberBuy + number
    return self.numberBuy
end

function EventAiryuuTrialData:GetEnemyDefenderTeamData()
    return self.defenderTeamGenerated
end

function EventAiryuuTrialData:GetEnemyDefenderTeamDataByDifficulty(id)
    return self.defenderTeamGenerated:Get(id)
end