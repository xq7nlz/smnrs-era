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

--------------------------------------------------------------------------------
local file = io.open("battle.json", "r")
if not file then
  error("Could not open file")
end

local contents = file:read("*a")
file:close()

local data = json.decode(contents)

--------------------------------------------------------------------------------
function iniTeam(data)
  ----------------------------------------
  local heroList = HeroList()

  heroList:InitDatabase(data.heroes)

  ----------------------------------------
  local summoner = SummonerBattleInfo()

  summoner:SetInfo(data.teamId, data.summonerId, 11, 300)
  summoner:SetSkills(table.unpack(data.summonerSkill))

  ----------------------------------------
  local teamInfo = BattleTeamInfo()

  teamInfo:SetFormationId(data.formationId)
  teamInfo:SetSummonerBattleInfo(summoner)

  ----------------------------------------
  local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(teamInfo.formation)

  for i, v in ipairs(heroList:GetItems()) do
    local heroInfo = HeroBattleInfo()

    heroInfo:SetInfo(data.teamId, v.heroId, v.heroStar, v.heroLevel)
    heroInfo:SetItemsDict(v.heroItem, v.isHideSkin)

    if i <= formationData.frontLine then
      heroInfo:SetPosition(true, i)
    else
      heroInfo:SetPosition(false, i)
    end

    heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)
    teamInfo:AddHero(heroInfo)
  end

  return teamInfo
end

--------------------------------------------------------------------------------
local attackerTeamInfo = iniTeam(data.attackTeam)
local defenderTeamInfo = iniTeam(data.defenseTeam)

--[[ print(attackerTeamInfo)
print(defenderTeamInfo) ]]

--------------------------------------------------------------------------------
-- gameMode: lua\logicbattle\enum\battle\GameMode.lua
-- runMode: lua\logicbattle\enum\battle\RunMode.lua

local gameMode = 6
local randomHelper = nil
local runMode = 3
local battleString = nil

local battleMgr = BattleMgr()

battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, runMode, battleString)
