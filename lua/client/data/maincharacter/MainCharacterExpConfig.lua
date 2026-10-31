--- @class MainCharacterExpConfig
MainCharacterExpConfig = Class(MainCharacterExpConfig)

--- @return void
function MainCharacterExpConfig:Ctor()
    --- @type number
    self.level = nil
    --- @type number
    self.exp = nil
    --- @type List
    self.listReward = List()
end

--- @return void
--- @param data string
function MainCharacterExpConfig:ParseCsv(data)
    self.level = tonumber(data.level)
    self.exp = tonumber(data.exp)
    self:AddReward(data)
end

--- @return void
--- @param data string
function MainCharacterExpConfig:AddReward(data)
    self.listReward:Add(ItemIconData.CreateInstance(tonumber(data.res_type), tonumber(data.res_id), tonumber(data.res_number)))
end