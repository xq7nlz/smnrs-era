--- @class UIStarterPackItem
UIStarterPackItem = Class(UIStarterPackItem)

--- @param transform UnityEngine_Transform
function UIStarterPackItem:Ctor(transform)
    --- @type ProductConfig
    self.starterPackProduct = nil
    self.updateTime = nil
    ---@type UIStarterPackItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

--- @param starterPackProduct ProductConfig
function UIStarterPackItem:InitConfig(starterPackProduct)
    self.starterPackProduct = starterPackProduct
    self.config.profitValue.text = string.format("+%d%% <size=%d>%s</size>",
            self.starterPackProduct.profit,
            MathUtils.Round(self.config.profitValue.fontSize * 0.7),
            UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("extra")))
    local listIconData = RewardInBound.GetItemIconDataList(self.starterPackProduct:GetRewardList())
    self.itemsTableView:SetData(listIconData)
end

--- @param packName string
--- @param packDesc string
--- @param iconFaction UnityEngine_Sprite
--- @param price string
--- @param buyCount number
function UIStarterPackItem:ShowLayout(packName, packDesc, iconFaction, price, buyCount)
    self.config.packName.text = packName or ""
    self.config.packDesc.text = packDesc or ""
    self.config.iconFaction.gameObject:SetActive(iconFaction ~= nil)
    self.config.textPrice.text = price
    if iconFaction ~= nil then
        self.config.iconFaction.sprite = iconFaction
    end
    self:ShowBuyState(buyCount)
end

function UIStarterPackItem:ShowBuyState(buyCount)
    self.config.coverBuy:SetActive(buyCount >= self.starterPackProduct.stock)
    local color = UIUtils.green_light
    if buyCount >= self.starterPackProduct.stock then
        color = UIUtils.red_light
    end
    self.config.textBuyState.text = string.format("%s <color=#%s>(%d/%s)</color>",
            LanguageUtils.LocalizeCommon("buy"),
            color,
            self.starterPackProduct.stock - buyCount,
            self.starterPackProduct.stock)
end

function UIStarterPackItem:Hide()
    if self.itemsTableView ~= nil then
        self.itemsTableView:Hide()
    end
end

--- @param listener function
function UIStarterPackItem:AddOnClickBuyListener(listener)
    self.config.buttonBuy.onClick:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener ~= nil then
            listener()
        end
    end)
end