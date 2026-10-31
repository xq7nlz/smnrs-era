local HERO_ID_SKIN = "hero_%d_%s.csv"
local HERO_ID = "hero_%d.csv"

--- @class HeroAnimConfig
HeroAnimConfig = Class(HeroAnimConfig)

function HeroAnimConfig:Ctor()
    --- @type string
    self.heroAnimPath = nil
    --- @type string
    self.heroAnimDir = nil
    --- @type table
    self.animCheckDict = nil
    --- @type Dictionary
    self.animDict = Dictionary()
end

function HeroAnimConfig:InitCheck()
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(self.heroAnimPath, nil, true)
    self.animCheckDict = {}
    for _, heroId in ipairs(decodeData) do
        self.animCheckDict[heroId] = true
    end
end

--- @return List
function HeroAnimConfig:GetFileData(fileConfig)
    if self.animCheckDict[fileConfig] then
        local path = string.format("%s%s", self.heroAnimDir, fileConfig)
        return CsvReaderUtils.ReadAndParseLocalFile(path)
    else
        return nil
    end
end

--- @param data string
function HeroAnimConfig:ParseCsv(data)
    local fileDataList = List()
    for i = 1, #data do
        fileDataList:Add(self:ParseLine(data[i]))
    end
    return fileDataList
end

--- @return table
function HeroAnimConfig:ParseLine(line)
    XDebug.Error("Need override this method")
end

--- @return List
function HeroAnimConfig:ConfigFromHeroSkin(id, skinName)
    local heroSkinFile = string.format(HERO_ID_SKIN, id, skinName)
    if self.animDict:IsContainKey(heroSkinFile) == true then
        return self.animDict:Get(heroSkinFile)
    else
        local dataList = nil
        local csv = self:GetFileData(heroSkinFile)
        if csv == nil then
            csv = self:GetFileData(string.format(HERO_ID, id))
        end
        if csv ~= nil then
            dataList = self:ParseCsv(csv)
        end
        self.animDict:Add(heroSkinFile, dataList)
        return dataList
    end
end
