---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.ArenaBattleItemConfig"
require "lua.client.core.network.playerData.arena.ArenaSingleChallengeInBound"

--- @class ArenaBattleItemView : IconView
ArenaBattleItemView = Class(ArenaBattleItemView, IconView)

--- @return void
function ArenaBattleItemView:Ctor()
    IconView.Ctor(self)
    ---@type ArenaOpponentBase
    self.arenaOpponentInfo = nil
    self.callbackClickBattle = nil
    ---@type VipIconView
    self.avatarIconView = nil
end

--- @return void
function ArenaBattleItemView:SetPrefabName()
    self.prefabName = 'arena_battle_item_view'
    self.uiPoolType = UIPoolType.ArenaBattleItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaBattleItemView:SetConfig(transform)
    assert(transform)
    --- @type ArenaBattleItemConfig
    ---@type ArenaBattleItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonBattleArena.onClick:AddListener(function()
        self:OnClickBattle()
    end)
end

--- @return void
function ArenaBattleItemView:InitLocalization()
    self.config.localizeScore.text = LanguageUtils.LocalizeCommon("point")
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
end

--- @return void
---@param arenaOpponentInfo ArenaOpponentBase
function ArenaBattleItemView:SetData(arenaOpponentInfo)
    self.arenaOpponentInfo = arenaOpponentInfo
    self.config.iconRankArena.sprite = self.arenaOpponentInfo:GetRankImage()
    self.config.iconRankArena:SetNativeSize()

    self.power = math.floor(self.arenaOpponentInfo:GetPower())
    self.config.textAp.text = tostring(self.power)
    self.config.textScore.text = UIUtils.SetColorString(UIUtils.color2, self.arenaOpponentInfo:GetElo())
    self.config.textPlayerName.text = self.arenaOpponentInfo:GetName()
    if self.avatarIconView == nil then
        self.avatarIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.heroSlot)
    end
    self.avatarIconView:SetData2(self.arenaOpponentInfo:GetAvatar(), self.arenaOpponentInfo:GetLevel())
    self.avatarIconView:AddListener(function()
        self:OnClickInfo()
    end)
    if InventoryUtils.CanUseFreeTurnArena() then
        self.config.textCoin.text = tostring(0)
    else
        self.config.textCoin.text = tostring(1)
    end
end

--- @return void
function ArenaBattleItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.avatarIconView ~= nil then
        self.avatarIconView:ReturnPool()
        self.avatarIconView = nil
    end
end

--- @return void
function ArenaBattleItemView:OnClickBattle()
    if self.callbackClickBattle ~= nil then
        self.callbackClickBattle()
    end
end

--- @return void
function ArenaBattleItemView:OnClickInfo()
    local data = {}
    data.userName = self.arenaOpponentInfo:GetName()
    data.avatar = self.arenaOpponentInfo:GetAvatar()
    data.level = self.arenaOpponentInfo:GetLevel()
    data.power = self.power
    if self.arenaOpponentInfo.otherPlayerInfo ~= nil then
        NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(self.arenaOpponentInfo.otherPlayerInfo.playerId, GameMode.ARENA,
                function(_otherPlayerInfoInBound)
                    ---@type OtherPlayerInfoInBound
                    local otherPlayerInfoInBound = _otherPlayerInfoInBound
                    data.battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(data.level, 1)
                    --data.mastery = otherPlayerInfoInBound.summonerBattleInfoInBound.masteryDict
                    PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
                end)
    else
        data.battleTeamInfo = self.arenaOpponentInfo:GetBattleTeamInfo()
        PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
    end
end

return ArenaBattleItemView