--- @class UIButtonTabModeShop
UIButtonTabModeShop = Class(UIButtonTabModeShop)

--- @param gameObject UnityEngine_GameObject
function UIButtonTabModeShop:Ctor(gameObject)
    self.gameObject = gameObject
    --- @type UnityEngine_RectTransform
    self.rectTransform = gameObject:GetComponent(ComponentName.UnityEngine_RectTransform)
    --- @type UnityEngine_Canvas
    self.canvas = gameObject:GetComponent(ComponentName.UnityEngine_Canvas)
    --- @type UnityEngine_UI_Image
    self.iconMoneyType = self.rectTransform:GetChild(0):GetComponent(ComponentName.UnityEngine_UI_Image)
end

function UIButtonTabModeShop:SetIcon(moneyType)
    self.iconMoneyType.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyType)
end

function UIButtonTabModeShop:Select()
    self.rectTransform.sizeDelta = U_Vector2(200, 200)
    self.canvas.sortingOrder = 0
end

function UIButtonTabModeShop:UnSelect()
    self.rectTransform.sizeDelta = U_Vector2(150, 150)
    self.canvas.sortingOrder = -1
end