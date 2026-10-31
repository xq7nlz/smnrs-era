--- @class HeroPredefine
HeroPredefine = Class(HeroPredefine)

--- @return void
function HeroPredefine:Ctor()
    --- @type number
    self.heroId = nil
    --- @type number
    self.isFrontLine = nil
    --- @type number
    self.position = nil
    --- @type number
    self.bossId = -1
end

--- @return void
--- @param data string
function HeroPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.heroId = tonumber(data.hero_id)
    self.isFrontLine = MathUtils.ToBoolean(data.is_front)
    self.position = tonumber(data.position)

    if data.boss_id ~= nil then
        self.bossId = tonumber(data.boss_id)
    end
    self:ValidateAfterParseCsv()
end

--- @return void
function HeroPredefine:ValidateAfterParseCsv()
    if MathUtils.IsNumber(self.heroId) == false then
        assert(false)
    end
end

function HeroPredefine:ValidateBeforeParseCsv(data)
    if data.hero_id == nil then
        assert(false)
    end

    if data.is_front == nil then
        assert(false)
    end

    if data.position == nil then
        assert(false)
    end
end
