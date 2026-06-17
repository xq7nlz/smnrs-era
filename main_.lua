require "global"
require "lua.client.core.UnityLib"
require "lua.libs.collection.List"
require "lua.client.utils.json"
require "lua.libs.collection.Dictionary"
require "lua.client.config.const.ResourceType"
require "lua.client.utils.CsvReaderUtils"
require "lua.client.core.ClientRequire"
require "lua.logicBattle._gen._LuaRequire"
require "lua.client.core.ResourceMgr"
require "lua.client.core.BattleMgr"
require "lua.client.core.inventory.HeroList"

---------------------------------- Hero List -----------------------------------
local teamA = CsvReaderUtils.ReadAndParseLocalFile("teamA.json", nil, true)

local heroListAttacker = HeroList()

heroListAttacker:InitDatabase(teamA)

----------------------------- SummonerBattleInfo -------------------------------
-- SetInfo: (teamId, summonerId[0 = Tiros, 1 = Malefica, 2 = Bellator, 3 = Vesta, 4 = Faber, 5 = Sagittarius], star, level player)
-- SetSkills: (skill 1(Max) = 7, skill 2(Max) = 11)

-- Attack Team --
local summonerAttacker = SummonerBattleInfo()

summonerAttacker:SetInfo(1, 4, 11, 300)
summonerAttacker:SetSkills(11, 7, 7, 7)

-- Defense Team --
local summonerDefender = SummonerBattleInfo()

summonerDefender:SetInfo(2, 4, 11, 300)
summonerDefender:SetSkills(11, 7, 7, 7)

------------------------------- BattleTeamInfo ---------------------------------
-- SetFormationId: csv\battle\formation.csv

-- Attack Team --
local attackerTeamInfo = BattleTeamInfo()

attackerTeamInfo:SetFormationId(3)
attackerTeamInfo:SetSummonerBattleInfo(summonerAttacker)

-- Defense Team --
local defenderTeamInfo = BattleTeamInfo()

defenderTeamInfo:SetFormationId(3)
defenderTeamInfo:SetSummonerBattleInfo(summonerDefender)

------------------------------- HeroBattleInfo ---------------------------------
local formationAttackTeam = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(attackerTeamInfo.formation)

for i, v in ipairs(heroListAttacker:GetItems()) do
  if i <= formationAttackTeam.frontLine then
    print(i, v.heroId)
  else

  end
end

---------------------------------- BattleMgr -----------------------------------
-- gameMode: lua\logicbattle\enum\battle\GameMode.lua
-- runMode: lua\logicbattle\enum\battle\RunMode.lua

local gameMode = 6
local randomHelper = nil
local runMode = 3
local battleString = nil

local battleMgr = BattleMgr()

--[[ battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, runMode, battleString) ]]
