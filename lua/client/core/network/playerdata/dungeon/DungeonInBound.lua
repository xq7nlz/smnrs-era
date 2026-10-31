require "lua.client.core.network.dungeon.DungeonBindingHeroInBound"
require "lua.client.core.network.playerData.common.HeroStateInBound"

--- @class DungeonInBound : BaseJsonInBound
DungeonInBound = Class(DungeonInBound, BaseJsonInBound)

DungeonInBound.KEY_DUNGEON_CHECK_IN_OPEN = "dungeon_check_in_open"
DungeonInBound.KEY_DUNGEON_CHECK_IN_SHOP = "dungeon_check_in_shop"

--- @return void
function DungeonInBound:Ctor()
    --- @type number
    self.currentStage = nil
    --- @type List<DungeonBindingHeroInBound>
    self.bindingHeroList = List()
    --- @type PredefineTeamData
    self.predefineTeam = nil
    --- @type PredefineTeamData
    self.cachePredefineTeam = nil
    --- @type BattleTeamInfo
    self.battleTeamInfo = nil
    --- @type List -- <HeroStateInBound>
    self.defenderList = List()
    --- @type List -- <HeroStateInBound>
    self.attackerList = nil
    --- @type Dictionary <number, number>
    self.passiveBuff = Dictionary()
    --- @type Dictionary <number, number>
    self.activeBuff = Dictionary()
    --- @type MarketItemInBound
    self.currentShop = nil
    --- @type DungeonShopType
    self.currentShopType = nil
    --- @type Dictionary<number, List<MarketItemInBound>>
    self.shopDict = nil
    --- @type List
    self.buffSelectionStageList = nil
    --- @type number
    self.highestStage = nil
    --- @type number
    self.timeReachHighestStage = nil
    --- @type Dictionary
    self.masteryLevel = nil
    --- @type Dictionary
    self.activeLinking = Dictionary()
    --- @type List --<RewardInBound>
    self.rewardChallengeList = List()
    --- @type boolean
    self.isWin = nil
    --- @type SeedInBound
    self.seedInBound = nil
    --- @type number
    self.selectedHero = 1
    --- @type List
    self.buffRewardList = List()
    --- @type number
    self.dungeonCheckInOpenSeason = nil
    --- @type number
    self.dungeonCheckInShop = nil
    --- @type string
    self.battleLog = nil
end

--- @return void
function DungeonInBound:InitDatabase()
    local jsonDatabase = json.decode(self.jsonData)
    self.currentStage = jsonDatabase['0']
    self.bindingHeroList = List()
    local dataBinding = jsonDatabase['1']
    if dataBinding ~= nil then
        for i, binding in ipairs(dataBinding) do
            local heroInbound = DungeonBindingHeroInBound.CreateByJson(binding)
            heroInbound.index = self.bindingHeroList:Count() + 1
            self.bindingHeroList:Add(heroInbound)
        end
    end

    local dataDefenderTeam = jsonDatabase['2']
    if dataDefenderTeam ~= nil then
        self.predefineTeam = PredefineTeamData.CreateByJson(dataDefenderTeam)
    end

    self.defenderList = List()
    local dataDefender = jsonDatabase['3']
    if dataDefender ~= nil then
        for id, defender in pairs(dataDefender) do
            assert(id and defender)
            local heroStateInBound = HeroStateInBound.CreateByJson(tonumber(id), defender)
            self.defenderList:Add(heroStateInBound)
        end
    end

    self.passiveBuff = Dictionary()
    local dataBuff = jsonDatabase['4']
    if dataBuff ~= nil then
        for id, value in pairs(dataBuff) do
            if value > 0 then
                id = tonumber(id)
                self:AddBuff(RewardInBound.CreateBySingleParam(ResourceType.DungeonItemPassiveBuff, id, value))
            end
        end
    end

    self.activeBuff = Dictionary()
    local dataPotion = jsonDatabase['5']
    if dataPotion ~= nil then
        for id, value in pairs(dataPotion) do
            if value > 0 then
                id = tonumber(id)
                self:AddBuff(RewardInBound.CreateBySingleParam(ResourceType.DungeonItemActiveBuff, id, value))
            end
        end
    end

    self.currentShopType = jsonDatabase['6']

    local dataCurrentShop = jsonDatabase['7']
    if dataCurrentShop ~= nil then
        self.currentShop = MarketItemInBound.CreateByJson(dataCurrentShop)
    else
        self.currentShop = nil
    end

    self.shopDict = Dictionary()
    local dataSmashShop = jsonDatabase['8']
    if dataSmashShop ~= nil then
        for id, value in pairs(dataSmashShop) do
            local shop = List()
            for k, v in pairs(value) do
                shop:Add(MarketItemInBound.CreateByJson(v))
            end
            self.shopDict:Add(tonumber(id), shop)
            --XDebug.Log(string.format("id[%d], item[%s]", id, LogUtils.ToDetail(shop:GetItems())))
        end
    end

    self.selectedHero = jsonDatabase['9']
    if self.selectedHero <= 0 then
        self.selectedHero = 1
    end

    self.buffSelectionStageList = List()
    local buffGeneratedHistoryDict = jsonDatabase['10']
    if buffGeneratedHistoryDict ~= nil then
        for stage, buffHistory in pairs(buffGeneratedHistoryDict) do
            if buffHistory['0'] == nil then
                self.buffSelectionStageList:Add(tonumber(stage))
            end
        end
    end
    self.buffSelectionStageList:SortWithMethod(function(a, b)
        if a < b then
            return -1
        end
        return 1
    end)

    self.highestStage = tonumber(jsonDatabase['13'])
    self.timeReachHighestStage = tonumber(jsonDatabase['14'])

    self.guildMonasteryLevel = tonumber(jsonDatabase['15'])

    self.masteryLevel = Dictionary()
    local dataMasteryLevel = jsonDatabase['16']
    if dataMasteryLevel ~= nil then
        for classId, levelList in pairs(dataMasteryLevel) do
            local list = List()
            for _, level in pairs(levelList) do
                list:Add(level)
            end
            self.masteryLevel:Add(tonumber(classId), list)
        end
    end

    self.activeLinking = Dictionary()
    local data = jsonDatabase['17']
    if data ~= nil then
        for id, value in pairs(data) do
            self.activeLinking:Add(tonumber(id), tonumber(value))
        end
    end
end

--- @return boolean
function DungeonInBound:ReadBufferChallenge(buffer)
    --- @type BattleResultInBound
    local battleResult = BattleResultInBound.CreateByBuffer(buffer, false)

    self.isWin = battleResult.isWin
    self.attackerList = battleResult.heroStateAttacker
    self.defenderList = battleResult.heroStateDefender
    self.seedInBound = battleResult.seedInBound
    self.battleLog = battleResult.battleLog

    if self.isWin == true then
        self:SetStage(1, zg.timeMgr:GetServerTime())

        local dungeonReward = DungeonRewardInBound()
        dungeonReward:ReadBuffer(buffer)
        if dungeonReward.type == DungeonRewardType.SHOP then
            self.currentShopType = dungeonReward.shopType
            self.currentShop = dungeonReward.marketItem
        else
            self.buffRewardList:Clear()
            --- @param v RewardInBound
            for _, v in ipairs(dungeonReward.rewardList:GetItems()) do
                if v.type ~= ResourceType.DungeonItemPassiveBuff and v.type ~= ResourceType.DungeonItemActiveBuff then
                    v:AddToInventory()
                    self:ClearRewardChallenge()
                    self.rewardChallengeList:Add(v)
                else
                    self.buffRewardList:Add(v)
                end
            end
        end

        --- @type PredefineTeamData
        self.predefineTeam = PredefineTeamData.CreateByBuffer(buffer)
    else
        self.cachePredefineTeam = nil
    end
end

--- @param reward RewardInBound
function DungeonInBound:AddBuff(reward)
    if reward.type == ResourceType.DungeonItemActiveBuff then
        local tempReward = self.activeBuff:Get(reward.id)
        if tempReward == nil then
            tempReward = RewardInBound.Clone(reward)
            self.activeBuff:Add(reward.id, tempReward)
        else
            tempReward.number = tempReward.number + reward.number
        end
    elseif reward.type == ResourceType.DungeonItemPassiveBuff then
        local tempReward = self.passiveBuff:Get(reward.id)
        if tempReward == nil then
            tempReward = RewardInBound.Clone(reward)
            self.passiveBuff:Add(reward.id, tempReward)
        else
            tempReward.number = tempReward.number + reward.number
        end
    else
        XDebug.Log("Buff Type is not valid: " .. tostring(reward.type))
    end
end

--- @param buffId number
function DungeonInBound:UseActiveBuff(buffId)
    local activeBuff = ResourceMgr.GetServiceConfig():GetDungeon():GetActiveBuff(buffId)
    --- @type DungeonBindingHeroInBound
    local hero = self:GetSelectedHero()
    hero:AddBuff(activeBuff.hpPercent, activeBuff.power)
end

--- @return boolean
function DungeonInBound:HasBuffSelectionStage()
    return self.buffSelectionStageList:Count() > 0
end

--- @return number
function DungeonInBound:GetFirstBuffSelectionStage()
    return self.buffSelectionStageList:Get(1)
end

function DungeonInBound:RemoveFirstBuffSelectionStage()
    self.buffSelectionStageList:RemoveByIndex(1)
end

--- @return boolean
function DungeonInBound:HasShop()
    return self.currentShop ~= nil
end

function DungeonInBound:HasReward()
    return self.rewardChallengeList:Count() > 0 or self.buffSelectionStageList:Count() > 0 or self.buffRewardList:Count() > 0
end

function DungeonInBound:SelectAttacker()
    local hero = self:GetSelectedHero()
    if hero:IsAlive() then
        -- continue use this attacker, do nothing
    else
        self:AutoSelectHero()
    end
end

function DungeonInBound:AutoSelectHero()
    --- @param hero DungeonBindingHeroInBound
    for i, hero in ipairs(self.bindingHeroList:GetItems()) do
        if hero:IsAlive() then
            self.selectedHero = i
            return
        end
    end
end

--- @return DungeonBindingHeroInBound
function DungeonInBound:GetHero(index)
    --- @type DungeonBindingHeroInBound
    local hero = self.bindingHeroList:Get(index)
    if hero == nil then
        XDebug.Error(string.format("hero is invalid: %s", tostring(index)))
    end
    return hero
end

--- @return DungeonBindingHeroInBound
function DungeonInBound:GetSelectedHero()
    return self:GetHero(self.selectedHero)
end

function DungeonInBound:CanBattle()
    --- @param hero DungeonBindingHeroInBound
    for _, hero in ipairs(self.bindingHeroList:GetItems()) do
        if hero:IsAlive() then
            return true
        end
    end
    return false
end

--- @return void
function DungeonInBound:UpdateSelectedHeroStatus(hp, power)
    local hero = self:GetSelectedHero()
    if hero ~= nil then
        hero.hpPercent = hp
        hero.power = power
    end
end

--- @return HeroStateInBound
function DungeonInBound:GetAttacker()
    if self.attackerList ~= nil and self.attackerList:Count() == 1 then
        return self.attackerList:Get(1)
    else
        XDebug.Error("attacker list is invalid")
        return nil
    end
end

--- @param delta number
--- @param timeUpdate number
function DungeonInBound:SetStage(delta, timeUpdate)
    self.currentStage = self.currentStage + delta
    if self.currentStage > self.highestStage then
        self.highestStage = self.currentStage
    end
    self.timeReachHighestStage = timeUpdate
end

function DungeonInBound:CanShowMerchant()
    --- @param v List <MarketItemInBound>
    for i, v in pairs(self.shopDict:GetItems()) do
        if v:Count() > 0 then
            return true
        end
    end
    return false
end

--- @return BattleTeamInfo
function DungeonInBound:GetDefenderTeamInfo()
    if self.predefineTeam == nil then
        XDebug.Error("predefineTeam is nil")
        return
    end

    if self.cachePredefineTeam ~= self.predefineTeam then
        self.battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(self.predefineTeam)

        if self.isWin == true then
            local heroList = self.battleTeamInfo:GetListHero()
            --- @param hero HeroBattleInfo
            for _, hero in ipairs(heroList:GetItems()) do
                hero:SetState(1, HeroConstants.DEFAULT_HERO_POWER)
            end
        else
            if self.defenderList == nil then
                XDebug.Error("defenderList is nil")
                return
            end
            ----- @param heroState HeroStateInBound
            --for _, heroState in ipairs(self.defenderList:GetItems()) do
            --    self.battleTeamInfo:SetState(GameMode.DUNGEON, heroState.isFrontLine, heroState.position, heroState.hp, heroState.power)
            --end

            --- @param hero HeroBattleInfo
            for _, hero in ipairs(self.battleTeamInfo.listHeroInfo:GetItems()) do
                --- @param heroState HeroStateInBound
                for _, heroState in ipairs(self.defenderList:GetItems()) do
                    if hero.isFrontLine == heroState.isFrontLine and hero.position == heroState.position then
                        hero:SetState(heroState.hp, heroState.power)
                        if heroState.hp > 0 then
                            hero.isInitialize = true
                        end
                        break
                    end
                    hero:SetState(0, heroState.power)
                end
            end

        end
        self.battleTeamInfo:RemoveUninitializedHeroes()
        self.cachePredefineTeam = self.predefineTeam
    end

    return self.battleTeamInfo
end

function DungeonInBound:ClearRewardChallenge()
    self.rewardChallengeList:Clear()
end

--- @return boolean
function DungeonInBound:HasBoss()
    --- @type BattleTeamInfo
    local battleTeamInfo = self:GetDefenderTeamInfo()
    --- @param heroInfo HeroBattleInfo
    for _, heroInfo in ipairs(battleTeamInfo:GetListHero():GetItems()) do
        if heroInfo.isBoss then
            return true
        end
    end
    return false
end

function DungeonInBound:Reset()
    self.activeBuff:Clear()
    self.passiveBuff:Clear()
    self.rewardChallengeList:Clear()
    self.buffRewardList:Clear()
end

--- @param onSuccess function
--- @param onFailed function
function DungeonInBound.GetDungeonCheckInOpen(onSuccess, onFailed)
    local setDungeonCheckInOpen = function(value)
        --- @type DungeonInBound
        local dungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
        if dungeonInBound ~= nil then
            dungeonInBound.dungeonCheckInOpenSeason = value
        end
        onSuccess(value)
    end
    local dungeonCheckInOpenSeason = zg.playerData.remoteConfig.dungeonCheckInOpenSeason
    if dungeonCheckInOpenSeason == nil then
        dungeonCheckInOpenSeason = -1
    end
    setDungeonCheckInOpen(dungeonCheckInOpenSeason)
end

--- @param seasonCheckIn number
--- @param onSuccess function
--- @param onFailed function
function DungeonInBound.SetDungeonCheckInOpen(seasonCheckIn, onSuccess, onFailed)
    zg.playerData.remoteConfig.dungeonCheckInOpenSeason = seasonCheckIn
    zg.playerData:SaveRemoteConfig()
    if onSuccess ~= nil then
        onSuccess()
    end
end

--- @param onSuccess function
--- @param onFailed function
function DungeonInBound.GetDungeonCheckInShop(onSuccess, onFailed)
    local setDungeonCheckInShop = function(value)
        --- @type DungeonInBound
        local dungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
        if dungeonInBound ~= nil then
            dungeonInBound.dungeonCheckInShop = value
        end
        onSuccess(value)
    end
    local dungeonCheckInShop = zg.playerData.remoteConfig.dungeonCheckInShop
    if dungeonCheckInShop == nil then
        dungeonCheckInShop = -1
    end
    setDungeonCheckInShop(dungeonCheckInShop)
end

--- @param seasonCheckIn number
--- @param onSuccess function
--- @param onFailed function
function DungeonInBound.SetDungeonCheckInShop(seasonCheckIn, onSuccess, onFailed)
    zg.playerData.remoteConfig.dungeonCheckInShop = seasonCheckIn
    zg.playerData:SaveRemoteConfig()
    if onSuccess ~= nil then
        onSuccess()
    end
end