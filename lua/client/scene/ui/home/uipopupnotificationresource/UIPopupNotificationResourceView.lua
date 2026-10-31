--- @class UIPopupNotificationResourceView : UIBaseView
UIPopupNotificationResourceView = Class(UIPopupNotificationResourceView, UIBaseView)

--- @param model UIPopupNotificationModel
function UIPopupNotificationResourceView:Ctor(model)
    --- @type UIPopupNotificationResourceConfig
    self.config = nil
    --- @type List
    self.listItemView = List()
    UIBaseView.Ctor(self, model)
    --- @type UIPopupNotificationModel
    self.model = model
end

function UIPopupNotificationResourceView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
end

function UIPopupNotificationResourceView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("not_enough_resource")
    self.config.textNoti.text = LanguageUtils.LocalizeCommon("popup_context_need_resource")
    self.config.textButton2.text = LanguageUtils.LocalizeCommon("understand")
end

--- @return void
function UIPopupNotificationResourceView:InitButtonListener()
    self.config.background.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.button2.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIPopupNotificationResourceView:OnReadyShow(result)
    if self.config.item ~= nil then
        if result.listItem ~= nil and result.listItem:Count() > 0 and self.listItemView:Count() == 0 then
            self.config.item.gameObject:SetActive(true)
            --- @param v RewardInBound
            for _, v in ipairs(result.listItem:GetItems()) do
                ---@type RootIconView
                local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
                item:SetIconData(v:GetIconData())
                --item:RegisterShowInfo()
                self.listItemView:Add(item)
            end
        else
            self.config.item.gameObject:SetActive(false)
        end
    end
end

function UIPopupNotificationResourceView:ReturnPoolListItem()
    ---@param v RootIconView
    for _, v in ipairs(self.listItemView:GetItems()) do
        v:ReturnPool()
    end
    self.listItemView:Clear()
end

function UIPopupNotificationResourceView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolListItem()
end