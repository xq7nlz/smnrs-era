require "lua.client.utils.json"
require "lua.libs.collection.Dictionary"
require "lua.client.config.const.ResourceType"
require "lua.client.utils.CsvReaderUtils"
require "lua.client.core.ClientRequire"
require "lua.logicBattle._gen._LuaRequire"
require "lua.client.core.ResourceMgr"
require "lua.client.core.BattleMgr"
require "lua.client.core.inventory.HeroResource"
require "lua.client.data.Player.PlayerData"

---------------------------------------- Constants ----------------------------------------
IS_CLIENT_RUNNING = true

---------------------------------------- Linking ----------------------------------------
local linkingDict = Dictionary()

linkingDict:Add(24, 3) -- Dragon Tribe Tier 3
linkingDict:Add(21, 3)

local playerData = PlayerData()

playerData:SetActiveLinking(linkingDict)

---------------------------------------- Matery ----------------------------------------
local masteryCsv = CsvReaderUtils.ReadLocalFile("mastery.csv")
local mastery = BattleCsvParser:ParseMastery(masteryCsv)

---------------------------------------- Hero ----------------------------------------
local ariyuu = HeroResource.CreateInstanceByJson(CsvReaderUtils.ReadAndParseLocalFile("ariyuu.json", nil, true))
local kazetsu = HeroResource.CreateInstanceByJson(CsvReaderUtils.ReadAndParseLocalFile("kazetsu.json", nil, true))

---------------------------------------- SummonerBattleInfo ----------------------------------------
local summonerAttacker = SummonerBattleInfo()
local summonerDefender = SummonerBattleInfo()

summonerAttacker:SetInfo(1, 0, 11, 300) -- teamId, summonerId, star, level player
summonerAttacker:SetSkills(3, 3, 3, 3) -- skill 1 = 7, skill 2 = 11

summonerDefender:SetInfo(2, 4, 11, 300)
summonerDefender:SetSkills(7, 7, 7, 7)

---------------------------------------- HeroBattleInfo ----------------------------------------
local heroAttacker = HeroBattleInfo()
local heroDefender = HeroBattleInfo()
local heroDefender2 = HeroBattleInfo()
local heroDefender3 = HeroBattleInfo()
local heroDefender4 = HeroBattleInfo()
local heroDefender5 = HeroBattleInfo()

heroAttacker:SetInfo(1, 30027, 14, 312)
heroAttacker:SetItemsDict(kazetsu.heroItem, kazetsu.isHideSkin)
heroAttacker:SetPosition(true, 1) -- isFrontLine, position
heroAttacker:SetState(1, HeroConstants.DEFAULT_HERO_POWER) -- HP%, Default Energy

heroDefender:SetInfo(2, 40027, 14, 350)
heroDefender:SetItemsDict(ariyuu.heroItem, ariyuu.isHideSkin)
heroDefender:SetPosition(true, 1)
heroDefender:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

heroDefender2:SetInfo(2, 40027, 14, 350)
heroDefender2:SetItemsDict(ariyuu.heroItem, ariyuu.isHideSkin)
heroDefender2:SetPosition(true, 2)
heroDefender2:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

heroDefender3:SetInfo(2, 40027, 14, 350)
heroDefender3:SetItemsDict(ariyuu.heroItem, ariyuu.isHideSkin)
heroDefender3:SetPosition(false, 3)
heroDefender3:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

heroDefender4:SetInfo(2, 40027, 14, 350)
heroDefender4:SetItemsDict(ariyuu.heroItem, ariyuu.isHideSkin)
heroDefender4:SetPosition(false, 4)
heroDefender4:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

heroDefender5:SetInfo(2, 30027, 14, 350)
heroDefender5:SetItemsDict(kazetsu.heroItem, kazetsu.isHideSkin)
heroDefender5:SetPosition(false, 5)
heroDefender5:SetState(1, HeroConstants.DEFAULT_HERO_POWER)

---------------------------------------- BattleTeamInfo ----------------------------------------
--- Attack Team ---
local attackerTeamInfo = BattleTeamInfo()

attackerTeamInfo:SetFormationId(1)

for key, data in pairs(mastery:GetItems()) do
  attackerTeamInfo:AddMasteriesClass(key, data:Get(1), data:Get(2), data:Get(3), data:Get(4), data:Get(5), data:Get(6))
end

for i, v in pairs(playerData.battleResultLinking:GetItems()) do
  attackerTeamInfo:AddLinkingGroup(i, v)
end

attackerTeamInfo:SetSummonerBattleInfo(summonerAttacker)

attackerTeamInfo:AddHero(heroAttacker)

--- Defense Team ---

local defenderTeamInfo = BattleTeamInfo()

defenderTeamInfo:SetFormationId(2)

for key, data in pairs(mastery:GetItems()) do
  defenderTeamInfo:AddMasteriesClass(key, data:Get(1), data:Get(2), data:Get(3), data:Get(4), data:Get(5), data:Get(6))
end

for i, v in pairs(playerData.battleResultLinking:GetItems()) do
  defenderTeamInfo:AddLinkingGroup(i, v)
end

defenderTeamInfo:SetSummonerBattleInfo(summonerDefender)

defenderTeamInfo:AddHero(heroDefender)
defenderTeamInfo:AddHero(heroDefender2)
defenderTeamInfo:AddHero(heroDefender3)
defenderTeamInfo:AddHero(heroDefender4)
defenderTeamInfo:AddHero(heroDefender5)

---------------------------------------- BattleMgr ----------------------------------------
local gameMode = 6 -- 6 = Arena
local randomHelper = nil
local runMode = 3 --- 3 = Fast
local battleString = nil

local battleMgr = BattleMgr()

battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper, runMode, battleString)

--- Print battle result ---
--[[ for key, value in pairs(ClientBattleData.battleResult) do
  print(key, value)
end ]]
