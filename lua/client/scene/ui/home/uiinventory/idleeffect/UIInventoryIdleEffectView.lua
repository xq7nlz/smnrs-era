require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIInventoryIdleEffectView
UIInventoryIdleEffectView = Class(UIInventoryIdleEffectView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventoryIdleEffectView:Ctor(view, transform, model)
    --- @type UIInventoryView
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List
    self.itemDic = nil
    ---@type List
    self.listIdleEffectData = List()

    ---@type UIInventoryArtifactConfig
    self.config = UIBaseConfig(transform)
    --- @param obj MoneyIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        index = index + 1
        local type = ResourceType.IDLE_EFFECT
        --- @type {idleEffectId, number}
        local idleEffectData = self.listIdleEffectData:Get(index)
        local id = idleEffectData.idleEffectId
        local number = idleEffectData.number
        local seen = false
        if zg.playerData.remoteConfig.listSeenIdleEffect == nil then
            zg.playerData.remoteConfig.listSeenIdleEffect = {}
            zg.playerData:SaveRemoteConfig()
        end
        for k, v in pairs(zg.playerData.remoteConfig.listSeenIdleEffect) do
            if v == id then
                seen = true
                break
            end
        end
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
        obj:SetNew(not seen)
        obj:RemoveAllListeners()
        obj:RegisterShowInfo()
        obj:AddListener(function()
            if zg.playerData.remoteConfig.listSeenIdleEffect ~= nil then
                local length = 0
                local constants = false
                for k, v in pairs(zg.playerData.remoteConfig.listSeenIdleEffect) do
                    if v == id then
                        constants =true
                        break
                    end
                    length = length + 1
                end
                if not constants then
                    zg.playerData.remoteConfig.listSeenIdleEffect[tostring(length+1)] = id
                    zg.playerData:SaveRemoteConfig()
                    obj:SetNew(false)
                end
            end
            self:Show()
        end)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.IdleEffectInfo, onCreateItem)
    self.config.buttonCollection.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCollection()
    end)
end

--- @return void
function UIInventoryIdleEffectView:Show()
    self.listIdleEffectData:Clear()
    self.config.loadingRotate:SetActive(true)
    InventoryUtils.ValidateIdleEffectInventory(function(idleEffectDict)
        self.config.loadingRotate:SetActive(false)
        for k, v in pairs(idleEffectDict:GetItems()) do
            local data = {}
            data.idleEffectId = k
            data.number = v
            self.listIdleEffectData:Add(data)
        end
        self:Sort()
    end,true)
end

--- @return void
function UIInventoryIdleEffectView:Hide()
    self.uiScroll:Hide()

    self.config.loadingRotate:SetActive(false)

    if self.buyCompleteSub ~= nil then
        self.buyCompleteSub:Unsubscribe()
        self.buyCompleteSub = nil
    end
end

--- @return void
function UIInventoryIdleEffectView:Sort()
    local itemCount = self.listIdleEffectData:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIInventoryIdleEffectView:OnClickCollection()
    PopupMgr.ShowPopup(UIPopupName.UIIdleEffectCollection)
end