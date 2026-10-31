--- @class UITabItem
UITabItem = Class(UITabItem)

--- @param transform UnityEngine_Transform
function UITabItem:Ctor(transform, callBack, localizeTabFunc, tabIndex)
    --- @type UIHeroCollectionTabConfig
    self.config = UIBaseConfig(transform)
    self.tabIndex = tabIndex
    self.localizeTabFunc = localizeTabFunc

    self.onTextColor = U_Color(232 / 255, 1, 252 / 255, 1)
    self.offTextColor = U_Color(232 / 255, 220 / 255, 198 / 255, 1)

    self:SetListener(callBack)
end

--- @param tabName string
function UITabItem:SetTabName(tabName)
    self.config.textTabName.text = tabName
end

--- @param isSelect boolean
function UITabItem:SetButtonInteractable(isSelect)
    self.config.button.interactable = not isSelect
end

--- @param listener function
function UITabItem:SetListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener(self.tabIndex)
    end)
end

function UITabItem:SetTabState(isChoose)
    self.config.bgOff:SetActive(not isChoose)
    self.config.bgOn:SetActive(isChoose)
    if isChoose then
        self.config.textTabName.color = self.onTextColor
    else
        self.config.textTabName.color = self.offTextColor
    end
end

function UITabItem:OverrideColor(colorOn, colorOff)
    if colorOn ~= nil then
        self.onTextColor = colorOn
    end
    if colorOff ~= nil then
        self.offTextColor = colorOff
    end
end

function UITabItem:SetShowButton(isEnable)
    self.config.button.enabled = isEnable
end

function UITabItem:EnableNotify(isEnable)
    self.config.notify:SetActive(isEnable)
end

function UITabItem:InitLocalization()
    if self.localizeTabFunc ~= nil then
        self:SetTabName(self.localizeTabFunc())
    else
        XDebug.Log("LOCALIZE NIL " .. self.config.gameObject.name)
    end
end

--- @param isActive boolean
function UITabItem:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

return UITabItem