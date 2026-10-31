--- @class VipData
VipData = Class(VipData)

--- @return void
function VipData:Ctor()
    ---@type number
    self.vipLevel = nil
    ---@type number
    self.vipPointRequired = nil
    ---@type number
    self.campaignBonusIdleTimeMax = nil
    ---@type number
    self.campaignBonusGold = nil
    ---@type number
    self.campaignBonusMagicPotion = nil
    ---@type number
    self.campaignBonusAutoTrainSlot = nil
    ---@type number
    self.campaignBonusExpSummoners = nil
    ---@type number
    self.campaignBonusQuickBattleBuyTurn = nil
    ---@type number
    self.tavernBonusQuest = nil
    ---@type number
    self.raidBonusTurnBuy = nil
    ---@type boolean
    self.casinoUnlockMultipleSpin = nil
    ---@type boolean
    self.casinoUnlockPremiumSpin = nil
    ---@type number
    self.casinoBonusTurnBuyBasicChip = nil
    --- @type number
    self.dungeonChallengeIncreased = nil
    ---@type boolean
    self.battleUnlockSpeedUp = nil
    ---@type boolean
    self.battleUnlockSkip = nil
    ---@type boolean
    self.summonUnlockAccumulate = nil
    ---@type number
    self.arenaBonusTicketBuy = nil
    ---@type number
    self.campaignBonusQuickBattleBuyTurn = nil
    ---@type boolean
    self.allowSkipAds = nil
    ---@type boolean
    self.prophetTreeUseGem = nil
    ---@type boolean
    self.autoNextBattle = nil
end

--- @return void
--- @param data string
function VipData:ParseCsv(data)
    self.vipLevel = tonumber(data["vip_level"])
    self.vipPointRequired = tonumber(data["vip_point_required"])
    self.campaignBonusIdleTimeMax = tonumber(data["campaign_bonus_idle_time_max"])
    self.campaignBonusGold = tonumber(data["campaign_bonus_gold"])
    self.campaignBonusMagicPotion = tonumber(data["campaign_bonus_magic_potion"])
    self.campaignBonusAutoTrainSlot = tonumber(data["campaign_bonus_auto_train_slot"])
    self.campaignBonusExpSummoners = tonumber(data["campaign_bonus_exp_summoners"])
    self.campaignBonusQuickBattleBuyTurn = tonumber(data["campaign_bonus_quick_battle_buy_turn"])
    self.tavernBonusQuest = tonumber(data["tavern_bonus_quest"])
    self.raidBonusTurnBuy = tonumber(data["raid_bonus_challenge_buy_turn"])
    self.casinoUnlockMultipleSpin = MathUtils.ToBoolean(data["casino_unlock_multiple_spin"])
    self.casinoUnlockPremiumSpin = MathUtils.ToBoolean(data["casino_unlock_premium_spin"])
    self.casinoBonusTurnBuyBasicChip = tonumber(data["casino_bonus_basic_chip_buy_turn"])
    self.dungeonChallengeIncreased = tonumber(data["dungeon_challenge_increased"])
    self.battleUnlockSpeedUp = MathUtils.ToBoolean(data["battle_unlock_speed_up"])
    self.battleUnlockSkip = MathUtils.ToBoolean(data["battle_unlock_skip"])
    self.battleUnlockSkipArena = MathUtils.ToBoolean(data["battle_unlock_skip_arena"])
    self.summonUnlockAccumulate = MathUtils.ToBoolean(data["summon_unlock_accumulate"])
    self.arenaBonusTicketBuy = tonumber(data["arena_bonus_ticket_buy_turn"])
    self.allowSkipAds = MathUtils.ToBoolean(data["allow_skip_ads"])
    self.prophetTreeUseGem = MathUtils.ToBoolean(data["prophet_tree_use_gem"])
    self.autoNextBattle = MathUtils.ToBoolean(data["auto_next_battle"])
end