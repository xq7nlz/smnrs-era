require "lua.client.scene.ui.common.UIPrefabView"
--- @class PieceAdventureShopTitleView : UIPrefabView
PieceAdventureShopTitleView = Class(PieceAdventureShopTitleView, UIPrefabView)

--- @type UnityEngine_Vector2
local GROUP1SIZE = U_Vector2(1470, 690)
--- @type UnityEngine_Vector2
local GROUP2SIZE = U_Vector2(1470, 1465)
--- @type number
local DAILY_PACK = 1

function PieceAdventureShopTitleView:Ctor()
    UIPrefabView.Ctor(self)
    --- @type List
    self.listRewardItem = List()
    ---@type number
    self.dataIndex = nil
    self:InitUpdateTime()
end

--- @return void
function PieceAdventureShopTitleView:SetPrefabName()
    self.prefabName = 'event_piece_adventure_shop_title'
    self.uiPoolType = UIPoolType.UIEventPieceAdventureShopTitle
end

--- @return void
--- @param transform UnityEngine_RectTransform
function PieceAdventureShopTitleView:SetConfig(transform)
    ---@type BossChallengeShopTitleConfig
    self.config = UIBaseConfig(transform)
end

--- @param listItem BossChallengeGroupProductConfig
--- @param dataIndex number
function PieceAdventureShopTitleView:SetData(listItem, packViewType, listener, dataIndex)
    self.dataIndex = dataIndex
    if(dataIndex == DAILY_PACK) then
        self.config.parent.sizeDelta = GROUP1SIZE
        self.config.textTimer.gameObject:SetActive(true)
        self.config.content.text = LanguageUtils.LocalizeCommon("piece_adventure_shop_title_1")
    else
        self.config.parent.sizeDelta = GROUP2SIZE
        self.config.textTimer.gameObject:SetActive(false)
        self.config.content.text = LanguageUtils.LocalizeCommon("piece_adventure_shop_title_2")
    end

    self:StartUpdateTime()

    for i = 1, listItem:GetListProductConfig():Count() do
        --- @type IapTilePackItem
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.IapTilePackZodiacItem, self.config.rewardAnchor)
        --- @type ProductConfig
        local productConfig = listItem:GetListProductConfig():Get(i)
        item:SetViewIconData(packViewType, productConfig, listener)
        self.listRewardItem:Add(item)
    end
end

function PieceAdventureShopTitleView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textTimer.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

--- @return void
function PieceAdventureShopTitleView:Show()
    self.config.gameObject:SetActive(true)
end

--- @return void
function PieceAdventureShopTitleView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:RemoveUpdateTime()
    self:ReturnPoolItem()
    self.config.textTimer.gameObject:SetActive(false)
end

--- @return void
function PieceAdventureShopTitleView:ReturnPoolItem()
    for i = 1, self.listRewardItem:Count() do
        self.listRewardItem:Get(i):ReturnPool()
    end
    self.listRewardItem:Clear()
end

--- @return void
function PieceAdventureShopTitleView:ActiveEffectSelect(isActive)
    if self.iconView ~= nil then
        self.iconView:ActiveEffectSelect(isActive)
    end
end

function PieceAdventureShopTitleView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function PieceAdventureShopTitleView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function PieceAdventureShopTitleView:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

return PieceAdventureShopTitleView
