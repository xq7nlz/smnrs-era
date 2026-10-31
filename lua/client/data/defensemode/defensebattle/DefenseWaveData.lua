--- @class DefenseWaveData
DefenseWaveData = Class(DefenseWaveData)

function DefenseWaveData:Ctor(parsedCsv)
    self:_ReadParsedData(parsedCsv)
end

function DefenseWaveData:_ReadParsedData(parsedCsv)
    self.id = tonumber(parsedCsv.id)
end