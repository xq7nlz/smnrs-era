require "lua.client.config.const.AnimationConstants"
require "lua.client.config.battle.PositionConfig"
require "lua.client.battleShow.ClientHero.HeroComponents"
require "lua.client.battleShow.ClientHero.ClientHeroAnimation"
require "lua.client.hero.BaseSkillShow"
require "lua.client.hero.CastOnMovingSkill"
require "lua.client.hero.MoveToPointThenCast"
require "lua.client.hero.SummonerSkillShow"
require "lua.client.hero.BaseMeleeAttack"
require "lua.client.hero.BaseRangeAttack"
require "lua.client.battleShow.LogDetail.ClientLogDetail"
require "lua.client.battleShow.ClientHero.ClientHero"
require "lua.client.battleShow.ClientBattleData"
require "lua.client.battleShow.PreviewHeroMgr"
require "lua.client.battleShow.BattleView.BattleView"

--- @class BattleMgr
BattleMgr = Class(BattleMgr)

--- @return void
function BattleMgr:Ctor()
    --- @type ClientBattleShowController
    self.clientBattleShowController = nil
    --- @type
    self.requireDict = {}
    --- @type {avatar, level, name, score, scoreChange, playerId}
    self.attacker = nil
    --- @type {avatar, level, name, score, scoreChange, playerId}
    self.defender = nil
    --- @type GameMode
    self.gameMode = nil
    --- @type BattleView
    self.battleView = nil
    --- @type PreviewHeroMgr
    self.previewHeroMgr = PreviewHeroMgr()
end

function BattleMgr:ResetArenaPlayerData()
    self.attacker = nil
    self.defender = nil
end

function BattleMgr:ShowBattleFromResult()
    require "lua.client.battleShow.ClientBattleShowController"
    self.clientBattleShowController = ClientBattleShowController()
    self.clientBattleShowController:OnCreate()
    self.clientBattleShowController:OnEnable()
    self.clientBattleShowController:InitBattleShow()
end

--- @return void
function BattleMgr:RunPVEMode()
    local csvBattleContent = CsvReaderUtils.ReadLocalFile(CsvPathConstants.BATTLE_DUC_PATH)
    local csvMasteryLevelContent = CsvReaderUtils.ReadLocalFile(CsvPathConstants.MASTERY_LEVEL_PATH)

    self:RequireLuaFiles(CsvReader.ReadContent(csvBattleContent))

    local battle = Battle()
    local battleCsvParser = BattleCsvParser(battle)
    battleCsvParser:ParseCsv(csvBattleContent, csvMasteryLevelContent)
    battle:SetHeroes()

    self:ConfigBattleResult(battle, RunMode.TEST)
end

--- @return void
function BattleMgr:RunBossFightMode()
    local csvAttackerContent = CsvReaderUtils.ReadLocalFile(CsvPathConstants.BATTLE_BOSS_FIGHT_ATTACKER_PATH)
    local csvDefenderContent = CsvReaderUtils.ReadLocalFile(CsvPathConstants.BATTLE_BOSS_FIGHT_DEFENDER_PATH)
    local csvMasteryLevelContent = CsvReaderUtils.ReadLocalFile(CsvPathConstants.MASTERY_LEVEL_PATH)

    self:RequireLuaFiles(CsvReader.ReadContent(csvAttackerContent))
    local battle = Battle()
    local battleCsvParser = BattleCsvParser(battle)
    battleCsvParser:ParseCsv(csvAttackerContent, csvMasteryLevelContent)

    local dataParse = CsvReader.ReadContent(csvDefenderContent)
    local data = dataParse[1]
    XDebug.Log("Defense team: " .. LogUtils.ToDetail(data))
    local predefineTeam = PredefineTeamData.CreateByCsv(data)
    ---@type BattleTeamInfo
    local defenderTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
    self:RequireBattleTeam(defenderTeamInfo)
    battle:SetDefenderTeamInfo(defenderTeamInfo)
    battle:SetHeroes()

    self:ConfigBattleResult(battle, RunMode.TEST)
end

--- @return void
function BattleMgr:StartTheShow()
    self.clientBattleShowController:StartTheShow()
end

function BattleMgr:ReleaseBattle()
    self.clientBattleShowController = nil
end

--- @return BattleView
function BattleMgr:GetBattleView()
    if self.battleView == nil then
        local inst = PrefabLoadUtils.Instantiate("battle_view", zgUnity.transform)
        self.battleView = BattleView(inst.transform)
    end
    return self.battleView
end

--- @return BattleView
function BattleMgr:GetBattleViewRaiseLevel()
    if self.battleViewRaiseLevel == nil then
        local inst = PrefabLoadUtils.Instantiate("battle_view_raise_level", zgUnity.transform)
        self.battleViewRaiseLevel = BattleViewRaiseLevel(inst.transform)
    end
    return self.battleViewRaiseLevel
end

--- @param attackerTeamInfo BattleTeamInfo
--- @param defenderTeamInfo BattleTeamInfo
--- @param gameMode GameMode
--- @param randomHelper RandomHelper
function BattleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, runMode, battleString)
    if battleString ~= nil then
        print("Have Battle Log")
    else
        print("Not Have Battle Log")
    end
    randomHelper = randomHelper or ClientMathUtils.randomHelper
    zg.sceneMgr.gameMode = gameMode or GameMode.CAMPAIGN
    self.gameMode = zg.sceneMgr.gameMode
    self:RequireBattleTeam(attackerTeamInfo)
    self:RequireBattleTeam(defenderTeamInfo)
    local battle = Battle()
    battle:SetGameMode(gameMode)
    battle:SetTeamInfo(attackerTeamInfo, defenderTeamInfo, randomHelper)
    battle:SetHeroes()

    self:ConfigBattleResult(battle, runMode, battleString)
end

--- @param battle Battle
--- @param runMode RunMode
--- @param battleString string
function BattleMgr:ConfigBattleResult(battle, runMode, battleString)
    runMode = runMode or RunMode.FAST

    local battleResult = ResourceMgr.GetServiceConfig():GetBattle():CalculateBattleResult(battle, runMode)
    local dkjson = require("lua.libs.dkjson")
    local battleLog

    if battleString == nil then
        battleLog = battleResult:ToClient()
    else
        battleLog = ClientConfigUtils.GetGunzipString(battleString)
    end

    local deBattleResult = dkjson.decode(battleLog)

    ClientBattleData.battle = battle
    ClientBattleData.battleResult = deBattleResult

    local clientLogDetail = ClientLogDetail(battle, deBattleResult)
    ClientBattleData.clientLogDetail = clientLogDetail

    self:SaveBattleLogJson(battleLog)
    self:SaveBattleLogTxt(battleResult:ToString(RunMode.TEST))

    if IS_EDITOR_PLATFORM then
        XDebug.Log(battleResult:ToString(RunMode.TEST))
    end
end

function BattleMgr:SaveBattleLogTxt(log)
    local file = io.open("battlelog.txt", "w")

    if file then
        file:write(log)
        
        file:close()
        print("File saved successfully.")
    else
        print("Error: Could not open file for writing.")
    end
end

function BattleMgr:SaveBattleLogJson(log)
    local file = io.open("battlelog.json", "w")

    if file then
        file:write(log)
        
        file:close()
        print("File saved successfully.")
    else
        print("Error: Could not open file for writing.")
    end
end

--- @param battleTeamInfo BattleTeamInfo
function BattleMgr:RequireBattleTeam(battleTeamInfo)
    --- @param v HeroBattleInfo
    for i, v in ipairs(battleTeamInfo:GetListHero():GetItems()) do
        local heroId = v.heroId
        if self.requireDict[heroId] == nil then
            local luaFiles = ResourceMgr.GetHeroesConfig():GetHeroLua():Get(heroId)
            for _, value in pairs(luaFiles) do
                require(value)
            end
            self.requireDict[heroId] = true
        end
    end
end

--- @return void
function BattleMgr:RequireLuaFiles(parsedData)
    local requireDict = {}
    for i = 1, #parsedData do
        local heroId = tonumber(parsedData[i].hero_id)
        if MathUtils.IsInteger(heroId) == false or heroId < 0 then
            assert(false, "heroId = " .. tostring(heroId))
        end
        if requireDict[heroId] == nil then
            local luaFiles = ResourceMgr.GetHeroesConfig():GetHeroLua():Get(heroId)
            for _, value in pairs(luaFiles) do
                require(value)
            end
            requireDict[heroId] = true
        end
    end
end

function BattleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper,
                                            onBattleResultCalculated, battleString)
    if self.isLoading == true then
        return
    end
    self.isLoading = true
    RxMgr.unloadUnusedResource:Next()
    self.gameMode = gameMode
    zg.sceneMgr:DeActiveCurrentScene()
    zg.sceneMgr:ActiveScene(SceneConfig.BattleScene)
    Coroutine.start(function()
        coroutine.yield(nil)
        zg.battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, nil, battleString)
        if gameMode == GameMode.ARENA_TEAM or gameMode == GameMode.ARENA_TEAM_RECORD then
            zg.playerData:GetArenaData():SaveDetail(ArenaTeamBattleData.match, ClientBattleData.battleResult, ClientBattleData.clientLogDetail)
        end
        if onBattleResultCalculated ~= nil then
            onBattleResultCalculated()
        end
        self.isLoading = false
    end)
end

---@param arenaTeamBattleData ArenaTeamBattleData
function BattleMgr.RunArenaTeamBattle(arenaTeamBattleData, index, gameMode, battleLog)
    gameMode = gameMode or GameMode.ARENA_TEAM
    ArenaTeamBattleData.match = index

    ---@type BattleDetailData
    local battleDetailData = arenaTeamBattleData.listBattleDetail:Get(index)
    battleDetailData.seedInbound:Initialize()
    zg.battleMgr:RunCalculatedBattleScene(battleDetailData.attackerTeam,
            battleDetailData.defenderTeam, gameMode, nil, nil, battleLog)
end