require "lua.client.data.DefenderTeamData"
--- @class KazetsuTowerLevelConfig : TowerLevelConfig
KazetsuTowerLevelConfig = Class(KazetsuTowerLevelConfig,TowerLevelConfig)

--- @return void
function KazetsuTowerLevelConfig:_InitPowerTeam()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.KAZETSU_DEFENDER_POWER_PATH)
    for i = 1, #data do
        local v = data[i]
        self._dataDictionary:Get(tonumber(v.stage)).powerTeam = v.power
    end
end
