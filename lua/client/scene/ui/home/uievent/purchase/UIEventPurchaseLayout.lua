--- @class UIEventPurchaseLayout : UIEventLayout
UIEventPurchaseLayout = Class(UIEventPurchaseLayout, UIEventLayout)

local cellSize = U_Vector2(1110, 145)
local spacing = U_Vector2(0, 10)

--- @param eventPopupModel EventPopupPurchaseModel
function UIEventPurchaseLayout:OnShow(eventPopupModel)
    self:InitScrollContentBundle(eventPopupModel)
    self:ResizeLoopScrollContent(eventPopupModel:GetAllData():Count())
end

--- @param eventPopupModel EventPopupModel
function UIEventPurchaseLayout:InitScrollContentBundle(eventPopupModel)
    self.view:SetGridContentSize(cellSize, spacing, 1)

    --- @param obj UIEventPackageItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type PurchasedPackInBound
        local purchasedPack = eventPopupModel:GetDataByIndexOfList(dataIndex)
        --- @type ProductConfig
        local productConfig = purchasedPack.config
        obj:AddListener(function()
            self.view:OnClickBuyPack(productConfig.opCode, productConfig.id, productConfig.dataId)
        end)
        obj:SetIconData(purchasedPack)
    end
    self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.EventPackageItem, onCreateItem)
    self.view.scrollLoopContent:SetUpMotion(MotionConfig())
end

function UIEventPurchaseLayout:OnHide()
    UIEventLayout.OnHide(self)
    UIEventLayout.EnableLoopScrollContent(self, false)
end
