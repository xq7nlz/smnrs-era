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
require "lua.client.core.inventory.HeroResource"

--------------------------------------------------------------------------------
local file = io.open("battle.json", "r")
if not file then
  error("Could not open file")
end

local contents = file:read("*a")
file:close()

local data = json.decode(contents)

--------------------------------------------------------------------------------
local linkingDict = Dictionary()

for i = 1, 25 do
  linkingDict:Add(i, 3)
end

--------------------------------------------------------------------------------
function iniTeam(data)
  ----------------------------------------
  local summoner = SummonerBattleInfo()

  summoner:SetInfo(data.teamId, data.summonerId, 11, 300)
  summoner:SetSkills(table.unpack(data.summonerSkill))

  ----------------------------------------
  local teamInfo = BattleTeamInfo()

  teamInfo:SetFormationId(data.formationId)

  local masteries = data.masteries

  if masteries ~= nil then
    for heroClass, levels in ipairs(masteries) do
      assert(levels ~= nil and #levels == SkillConstants.SUMMONER_NUMBER_MASTERY)
      teamInfo:AddMasteriesClass(heroClass, levels[1], levels[2], levels[3], levels[4], levels[5], levels[6])
    end
  end

  for i, v in pairs(linkingDict:GetItems()) do
    teamInfo:AddLinkingGroup(i, v)
  end

  teamInfo:SetSummonerBattleInfo(summoner)

  ----------------------------------------
  local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(teamInfo.formation)

  for i, jsonHero in ipairs(data.heroes) do
    local heroResource = HeroResource.CreateInstanceByJson(jsonHero)

    local heroInfo = HeroBattleInfo()

    heroInfo:SetInfo(data.teamId, heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
    heroInfo:SetItemsDict(heroResource.heroItem, heroResource.isHideSkin)

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

--------------------------------------------------------------------------------
-- gameMode: lua\logicbattle\enum\battle\GameMode.lua
-- runMode: lua\logicbattle\enum\battle\RunMode.lua

local gameMode = 6
local randomHelper = nil
local runMode = 3
local battleString = nil

local battleMgr = BattleMgr()

battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, runMode, battleString)
