--- @class PurchaseLevelBattlePassByGemLayout
PurchaseLevelBattlePassByGemLayout = Class(PurchaseLevelBattlePassByGemLayout)

--- @param anchor UnityEngine_RectTransform
function PurchaseLevelBattlePassByGemLayout:Ctor(anchor, onClickPurchase)
    --- @type PurchaseLevelBattlePassByGemLayoutConfig
    self.config = UIBaseConfig(anchor)

    self.onClickPurchase = onClickPurchase

    self.config.buttonPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickPurchase then
            self.onClickPurchase()
        end
    end)
end

function PurchaseLevelBattlePassByGemLayout:InitLocalization()
    self.config.textTittle.text = LanguageUtils.LocalizeCommon("buy_level_buy_gem")
    self.config.textPrice.text = LanguageUtils.LocalizeCommon("go")
    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    --- @type EventBattlePassConfig
    local eventBattlePassConfig = self.eventBattlePassModel:GetConfig()
    if eventBattlePassConfig then
        --- @type ExchangeEventConfig
        self.exchangeExpConfig = eventBattlePassConfig:GetExchangeExpConfig()
    end
    local max = self.exchangeExpConfig.limit
    local currentBought = self.eventBattlePassModel:GetNumberBuy(EventActionType.BATTLE_PASS_EXCHANGE_EXP, self.exchangeExpConfig.id)
    if  currentBought < max then
        local textLimit = string.format("%s/%s",max-currentBought,max)
        self.config.buttonPurchase.interactable = true
        self.config.disableButton:SetActive(false)
        self.config.textLimit.text = LanguageUtils.LocalizeCommon("limit") .." ".. UIUtils.SetColorString(UIUtils.green_light,textLimit)
    else
        self.config.buttonPurchase.interactable = false
        self.config.disableButton:SetActive(true)
        self.config.textLimit.text = LanguageUtils.LocalizeCommon("out_of_buy_level_by_gem_time")
    end

end