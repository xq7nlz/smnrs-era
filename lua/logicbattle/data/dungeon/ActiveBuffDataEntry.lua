--- @class ActiveBuffDataEntry
ActiveBuffDataEntry = Class(ActiveBuffDataEntry)

--- @return void
--- @param data table
function ActiveBuffDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.limit = tonumber(data.limit)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type number
    self.type = tonumber(data.buff_type)

    --- @type number
    self.hpPercent = tonumber(data.hp_percent)

    --- @type number
    self.power = tonumber(data.power)
end

--- @return void
function ActiveBuffDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.limit) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.type) == false then
        assert(false)
    end

    if MathUtils.IsNumber(self.hpPercent) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.power) == false then
        assert(false)
    end
end
