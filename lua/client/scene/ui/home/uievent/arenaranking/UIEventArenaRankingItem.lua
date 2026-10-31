---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiEvent.arenaRanking.UIEventArenaRankingItemConfig"

--- @class UIEventArenaRankingItem : MotionIconView
UIEventArenaRankingItem = Class(UIEventArenaRankingItem, MotionIconView)

function UIEventArenaRankingItem:Ctor()
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type ProductConfig
    self.productConfig = nil
    MotionIconView.Ctor(self)
end

function UIEventArenaRankingItem:SetPrefabName()
    self.prefabName = 'event_arena_item_view'
    self.uiPoolType = UIPoolType.EventArenaRankingItem
end

--- @param transform UnityEngine_Transform
function UIEventArenaRankingItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventArenaRankingItemConfig
    self.config = UIBaseConfig(transform)
end

function UIEventArenaRankingItem:InitLocalization()
    self.config.textClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("archived")
end

--- @param arenaRewardRankingConfig ArenaRewardRankingConfig
--- @param listIconData List
function UIEventArenaRankingItem:SetData(arenaRewardRankingConfig, listIconData)
    if arenaRewardRankingConfig.eloMax < 0 then
        self.config.rankDesc.text = string.format("%s %s",
                string.format("<color=#%s>%s+</color>", UIUtils.color2, arenaRewardRankingConfig.eloMin),
                LanguageUtils.LocalizeCommon("ranking_point"))
    elseif arenaRewardRankingConfig.eloMin < 0 then
        self.config.rankDesc.text = string.format("%s %s",
                string.format("<color=#%s>%s-</color>", UIUtils.color2, arenaRewardRankingConfig.eloMax),
                LanguageUtils.LocalizeCommon("ranking_point"))
    else
        self.config.rankDesc.text = string.format("%s %s",
                string.format("<color=#%s>%s - %s</color>", UIUtils.color2, arenaRewardRankingConfig.eloMin, arenaRewardRankingConfig.eloMax),
                LanguageUtils.LocalizeCommon("ranking_point"))
    end
    self.itemsTableView = ItemsTableView(self.config.itemTableAnchor)
    self.itemsTableView:SetData(listIconData)
end

function UIEventArenaRankingItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.itemsTableView ~= nil then
        self.itemsTableView:Hide()
        self.itemsTableView = nil
    end
end

function UIEventArenaRankingItem:AddOnClaimListener(callback)
    self.config.claimed:SetActive(false)
    self.config.buttonClaim.onClick:RemoveAllListeners()
    self.config.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if callback then
            callback()
        end
    end)
    self.config.buttonClaim.gameObject:SetActive(true)
end

function UIEventArenaRankingItem:SetDefaultButton()
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.claimed:SetActive(false)
end

function UIEventArenaRankingItem:HideAllButton()
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.claimed:SetActive(false)
end

function UIEventArenaRankingItem:SetAsClaimed()
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.claimed:SetActive(true)
end

return UIEventArenaRankingItem