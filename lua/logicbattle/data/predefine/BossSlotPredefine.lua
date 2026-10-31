--- @class BossSlotPredefine
BossSlotPredefine = Class(BossSlotPredefine)

--- @return void
function BossSlotPredefine:Ctor()
    ---@type number
    self.id = 0

    --- @type List
    self.bossStatList = List()
end

--- @return void
--- @param data string
function BossSlotPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.id = tonumber(data.boss_slot_id)
    self.bossStatList:Add(tonumber(data.slot_1))
    self.bossStatList:Add(tonumber(data.slot_2))
    self.bossStatList:Add(tonumber(data.slot_3))
    self.bossStatList:Add(tonumber(data.slot_4))
    self.bossStatList:Add(tonumber(data.slot_5))
end

function BossSlotPredefine:ValidateBeforeParseCsv(data)
    if data.slot_1 == nil then
        assert(false)
    end

    if data.slot_2 == nil then
        assert(false)
    end

    if data.slot_3 == nil then
        assert(false)
    end

    if data.slot_4 == nil then
        assert(false)
    end

    if data.slot_5 == nil then
        assert(false)
    end
end
