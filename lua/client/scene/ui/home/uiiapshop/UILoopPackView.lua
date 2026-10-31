--- @class UILoopPackView
UILoopPackView = Class(UILoopPackView)

--- @param root UnityEngine_UI_LoopScrollRect
function UILoopPackView:Ctor(root)
    --- @type UnityEngine_UI_LoopScrollRect
    self.root = root
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type PackOfProducts
    self.packOfProducts = nil
    --- @type OpCode
    self.opCode = nil
    --- @type string
    self.scrollName = nil
    --- @type UIGrowthMilestoneItem
    self.uiPoolType = nil
    --- @type boolean
    self.isShowing = false
end

function UILoopPackView:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(self.opCode)
    --- @param obj UIGrowthMilestoneItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type RawProduct
        local rawPackData = self.packOfProducts:GetPackBase(dataIndex)
        obj:SetIconData(rawPackData)
    end

    self.uiScroll = UILoopScroll(self.root, self.uiPoolType, onCreateItem)
end

function UILoopPackView:Show()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, self.scrollName)
    self.root.gameObject:SetActive(true)
    self.isShowing = true
    self:Resize()
end

function UILoopPackView:Resize()
    self.uiScroll:Resize(self.packOfProducts:GetAllPackBase():Count())
end

function UILoopPackView:Hide()
    self.isShowing = false
    self.uiScroll:Hide()
    self.root.gameObject:SetActive(false)
end

function UILoopPackView:IsShowing()
    return self.isShowing
end

function UILoopPackView:OnDestroy()
    return self.isShowing
end
