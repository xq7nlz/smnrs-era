--- @class IdleMoneyConfig
IdleMoneyConfig = Class(IdleMoneyConfig)

--- @return void
function IdleMoneyConfig:Ctor()
    ---@type number
    self.stageId = 0
    ---@type number
    self.typeId = 0
    ---@type number
    self.id = 0
    ---@type number
    self.number = 0
end

--- @return void
--- @param data string
function IdleMoneyConfig:ParseCsv(data)
    self.typeId = tonumber(data.res_type)
    self.id = tonumber(data.res_id)
    self.number = tonumber(data.res_number)
end