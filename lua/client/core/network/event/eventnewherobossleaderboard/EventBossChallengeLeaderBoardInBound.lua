--- @class InventoryBasicInfo
InventoryBasicInfo = Class(InventoryBasicInfo)

function InventoryBasicInfo:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function InventoryBasicInfo:ReadBuffer(buffer)
    self.heroId = buffer:GetInt()
    self.heroLevel = buffer:GetInt()
    self.heroStar = buffer:GetInt()
end


--- @class EventBossChallengeLeaderBoardInBound
EventBossChallengeLeaderBoardInBound = Class(EventBossChallengeLeaderBoardInBound)

function EventBossChallengeLeaderBoardInBound:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventBossChallengeLeaderBoardInBound:ReadBuffer(buffer)
    self.ranking = buffer:GetInt()
    self.avatar = buffer:GetInt()
    self.level = buffer:GetInt()
    self.playerName = buffer:GetString()
    self.guildName = buffer:GetString()

    self.summonerClass = buffer:GetInt()
    self.summonerStar = buffer:GetInt()
    self.formation = buffer:GetInt()
    self.power = buffer:GetLong()

    ---@type Dictionary
    self.dictFront = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        self.dictFront:Add(buffer:GetInt(), InventoryBasicInfo(buffer))
    end
    ---@type Dictionary
    self.dictBack = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        self.dictBack:Add(buffer:GetInt(), InventoryBasicInfo(buffer))
    end
    XDebug.Log(LogUtils.ToDetail(self))
end

--- @return BattleTeamInfo
function EventBossChallengeLeaderBoardInBound:GetBattleTeamInfo()
    local battleTeamInfo = BattleTeamInfo()
    battleTeamInfo:SetFormationId(self.formation)
    ---@param v InventoryBasicInfo
    for i, v in pairs(self.dictFront:GetItems()) do
        local heroInfo = HeroBattleInfo()
        heroInfo:SetInfo(1, v.heroId, v.heroStar, v.heroLevel)
        heroInfo:SetPosition(true, i)
        heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)
        battleTeamInfo:AddHero(heroInfo)
    end
    ---@param v InventoryBasicInfo
    for i, v in pairs(self.dictBack:GetItems()) do
        local heroInfo = HeroBattleInfo()
        heroInfo:SetInfo(1, v.heroId, v.heroStar, v.heroLevel)
        heroInfo:SetPosition(false, i)
        heroInfo:SetState(1, HeroConstants.DEFAULT_HERO_POWER)
        battleTeamInfo:AddHero(heroInfo)
    end
    local summoner = SummonerBattleInfo()
    summoner:SetInfo(1, self.summonerClass, self.summonerStar, self.level)
    battleTeamInfo:SetSummonerBattleInfo(summoner)

    return battleTeamInfo
end

--- @return void
function EventBossChallengeLeaderBoardInBound:ShowInfo()
    local data = {}
    data.userName = self.playerName
    data.avatar = self.avatar
    data.level = self.level
    data.power = self.power
    data.battleTeamInfo = self:GetBattleTeamInfo()
    PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
end