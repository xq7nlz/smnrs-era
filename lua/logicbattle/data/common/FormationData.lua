--- @class FormationData
FormationData = Class(FormationData)

--- @return void
function FormationData:Ctor()
    --- @type number
    self.id = -1

    --- @type number
    self.frontLine = -1
    --- @type number
    self.backLine = -1
end

--- @return void
--- @param data string
function FormationData:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.id = tonumber(data.id)
    self.frontLine = tonumber(data.front_line)
    self.backLine = tonumber(data.back_line)

    self:ValidateAfterParseCsv()
end

--- @return void
--- @param data table
function FormationData:ValidateBeforeParseCsv(data)
    if data.id == nil then
        assert(false)
    end

    if data.front_line == nil then
        assert(false)
    end

    if data.back_line == nil then
        assert(false)
    end
end

--- @return void
function FormationData:ValidateAfterParseCsv()
    if MathUtils.IsInteger(self.id) == false or self.id < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.backLine) == false or self.backLine < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.frontLine) == false or self.frontLine < 0 then
        assert(false)
    end
end

function FormationData:GetIsFrontLine(indexSlot)
    if indexSlot <= self.frontLine then
        return true
    else
        return false
    end
end

function FormationData:GetPosition(indexSlot)
    if indexSlot <= self.frontLine then
        return indexSlot
    else
        return indexSlot - self.frontLine
    end
end