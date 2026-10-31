require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIIdleEffectCollectionView : UIBaseView
UIIdleEffectCollectionView = Class(UIIdleEffectCollectionView, UIBaseView)

--- @return void
--- @param model UISkinCollectionModel
function UIIdleEffectCollectionView:Ctor(model, ctrl)
    ---@type UIIdleEffectCollectionConfig
    self.config = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listIdleEffectData = List()
    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    ---@type UIIdleEffectCollectionModel
    self.model = model
end

--- @return void
function UIIdleEffectCollectionView:OnReadyCreate()
    ---@type UISkinCollectionConfig
    self.config = UIBaseConfig(self.uiTransform)
    --- @param obj MoneyIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type {idleEffectId, number}
        local idleEffectData = self.listIdleEffectData:Get(index)
        local id = idleEffectData.idleEffectId
        local type = ResourceType.IDLE_EFFECT
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id))
        obj:RemoveAllListeners()
        obj:RegisterShowInfo()
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIIdleEffectCollectionView:InitLocalization()
    self.config.titleArtifactCollection.text = LanguageUtils.LocalizeCommon("gallery")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UIIdleEffectCollectionView:OnReadyShow(onBuySuccess)
    self.onBuySuccess = onBuySuccess
    self:Sort()
end

--- @return void
function UIIdleEffectCollectionView:Sort()


    --InventoryUtils.ValidateIdleEffectInventory(function(idleEffectDict)
    --    for k, v in pairs(idleEffectDict:GetItems()) do
    --        local data = {}
    --        data.idleEffectId = k
    --        data.number = v
    --        self.listIdleEffectData:Add(data)
    --    end
    --    self.uiScroll:Resize(self.listIdleEffectData:Count())
    --end)
    self.listIdleEffectData =  self.model:GetAllIdleEffect()
    self.uiScroll:Resize(self.listIdleEffectData:Count())
    self.config.empty:SetActive(self.listIdleEffectData:Count() <= 0)
end
