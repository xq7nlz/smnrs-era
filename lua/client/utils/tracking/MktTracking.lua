

--- @class MktTrackingType
MktTrackingType = {
    stoneUp = "stone_up",
    summonBasic = "summon_basic",
    marketBuy = "market_buy",
    forge = "forge",
    altarHero = "altar_hero",
    summonPre = "summon_pre",
    quickBattle = "quick_battle",
    arena = "arena",
    towerLost = "tower_lost",
    arenaTeam = "arena_team",
}

--- @class MktTrackingData
local MktTrackingData = {}

local LoadData = function()
    if U_PlayerPrefs.HasKey(PlayerPrefsKey.MKT_TRACKING) then
        local content = U_PlayerPrefs.GetString(PlayerPrefsKey.MKT_TRACKING, "")
        MktTrackingData = json.decode(content)
    end
end

local SaveData = function()
    local content = json.encode(MktTrackingData)
    U_PlayerPrefs.SetString(PlayerPrefsKey.MKT_TRACKING, content)
end

local AddTracking = function(type)
    if MktTrackingData[type] == nil then
        MktTrackingData[type] = 1
    else
        MktTrackingData[type] = MktTrackingData[type] + 1
    end
end

local CheckTracking = function(type)
    if (type == MktTrackingType.stoneUp and MktTrackingData[type] == 13) or
            (type == MktTrackingType.summonBasic and (MktTrackingData[type] == 10 or MktTrackingData[type] == 14)) or
            (type == MktTrackingType.summonPre and (MktTrackingData[type] == 14 or MktTrackingData[type] == 21)) or
            (type == MktTrackingType.quickBattle and (MktTrackingData[type] == 2 or MktTrackingData[type] == 4)) or
            (type == MktTrackingType.marketBuy and (MktTrackingData[type] == 4 or MktTrackingData[type] == 7)) or
            (type == MktTrackingType.forge and (MktTrackingData[type] == 3 or MktTrackingData[type] == 15)) or
            (type == MktTrackingType.altarHero and (MktTrackingData[type] == 2)) or
            (type == MktTrackingType.towerLost and (MktTrackingData[type] == 3)) or
            (type == MktTrackingType.arena and (MktTrackingData[type] == 2))
    then
        TrackingUtils.AddMkt(string.format("%s_%d", type, MktTrackingData[type]))
    end
end

local Init = function()
    LoadData()

    RxMgr.mktTracking:Subscribe(function(type, number)
        --XDebug.Log(string.format("Tracking=>  type: %s, number: %d", type, number))
        for _ = 1, number do
            AddTracking(type)
            CheckTracking(type)
        end
        SaveData()
    end)
end

Init()