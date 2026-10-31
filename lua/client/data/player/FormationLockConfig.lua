local FORMATION_LOCK_PATH = "csv/account/formation_lock.csv"

--- @class FormationLockConfig
FormationLockConfig = Class(FormationLockConfig)

---@return void
function FormationLockConfig:Ctor()
    ---@type Dictionary
    self.dict = Dictionary()
    ---@type number
    self.formationDefault = 4
    self:ReadData()
end

---@return void
function FormationLockConfig:ReadData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(FORMATION_LOCK_PATH)
    for i = 1, #parsedData do
        self.dict:Add(tonumber(parsedData[i]["formation"]), tonumber(parsedData[i]["level"]))
    end
end

return FormationLockConfig