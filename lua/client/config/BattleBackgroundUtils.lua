--- @class BattleBackgroundUtils
BattleBackgroundUtils = {}

--- @param gameMode GameMode
function BattleBackgroundUtils.GetBgPrefixByGameMode(gameMode)
    if gameMode == GameMode.CAMPAIGN
            or gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT then
        return "background_", "back_anchor_bot_"
    elseif gameMode == GameMode.ARENA then
        return "arena_anchor_top", "arena_anchor_bot"
    elseif gameMode == GameMode.DUNGEON then
        return "dungeon_anchor_top", "dungeon_anchor_bot"
    elseif gameMode == GameMode.EVENT_KAZETSU_TRIAL then
        return "kazetsu_trial_anchor_top", "kazetsu_trial_anchor_bot"
    elseif gameMode == GameMode.EVENT_BOSS_CHALLENGE then
        return "kazetsu_trial_anchor_top", "kazetsu_trial_anchor_bot"
    elseif gameMode == GameMode.EVENT_SKIN_CHALLENGE then
        return "background_", "back_anchor_bot_"
    elseif gameMode == GameMode.EVENT_CHRISTMAS or gameMode == GameMode.CHRISTMAS_ARENA_RECORD then
        return "background_christmas"
    else
        return "arena_anchor_top", "arena_anchor_bot"
    end
end

--- @return string, string
--- @param gameMode GameMode
function BattleBackgroundUtils.GetBgAnchorNameByMode(gameMode, ...)
    local args = { ... }
    local bgAnchorTop, bgAnchorBot = BattleBackgroundUtils.GetBgPrefixByGameMode(gameMode)
    if gameMode == GameMode.CAMPAIGN then
        local stage = args[1]
        local selectBackgroundId = ResourceMgr.GetCampaignDataConfig():GetRandomBgByStage(stage)
        bgAnchorTop = bgAnchorTop .. selectBackgroundId
        bgAnchorBot = bgAnchorBot .. selectBackgroundId
    elseif gameMode == GameMode.TOWER or gameMode == GameMode.TOWER_RECORD then
        local floor = args[1]
        bgAnchorTop, bgAnchorBot = ResourceMgr.GetTowerConfig():GetBackgroundByFloor(floor)
    elseif gameMode == GameMode.ARENA
            or gameMode == GameMode.DUNGEON
            or gameMode == GameMode.EVENT_CHRISTMAS or gameMode == GameMode.CHRISTMAS_ARENA_RECORD then
        -- Do nothing
    elseif gameMode == GameMode.EVENT_SKIN_CHALLENGE then
        local selectBackgroundId = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE):GetConfig():GetBackgroundId()
        bgAnchorTop = bgAnchorTop .. selectBackgroundId
        bgAnchorBot = bgAnchorBot .. selectBackgroundId
    elseif gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT then
        bgAnchorTop = bgAnchorTop .. UIRaidModel.raidBgId
        bgAnchorBot = bgAnchorBot .. UIRaidModel.raidBgId
    end
    return bgAnchorTop, bgAnchorBot
end

--- @param stage number
function BattleBackgroundUtils.PreloadDummyCampaignBackground(stage)
    local selectBackgroundId = ResourceMgr.GetCampaignDataConfig():GetRandomBgByStage(stage, 1)
    local nameBgAnchorTop, nameBgAnchorBot = BattleBackgroundUtils.GetBgPrefixByGameMode(GameMode.CAMPAIGN)
    nameBgAnchorTop = nameBgAnchorTop .. selectBackgroundId
    nameBgAnchorBot = nameBgAnchorBot .. selectBackgroundId

    local onSpawned = function(gameObject)
        SmartPool.Instance:DespawnGameObject(AssetType.Background, nameBgAnchorTop, gameObject.transform)
    end
    SmartPool.Instance:SpawnGameObjectAsync(AssetType.Background, nameBgAnchorTop, onSpawned)
end


