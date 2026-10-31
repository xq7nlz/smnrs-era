--- @class IapShopRegularTabItem
IapShopRegularTabItem = Class(IapShopRegularTabItem)

local ON_ICON_TAB_COLOR = U_Color(0.55, 0.49, 0.43, 1)
local OFF_ICON_TAB_COLOR = U_Color(1, 1, 1, 1)

local ON_TEXT_COLOR = U_Color(0.9215687, 0.8705883, 0.7725491, 1)
local OFF_TEXT_COLOR = U_Color(0.5137255, 0.4509804, 0.3843138, 1)

--- @param transform UnityEngine_Transform
--- @param callBack function
--- @param localizeTabFunc function
function IapShopRegularTabItem:Ctor(transform, callBack, localizeTabFunc)
    --- @type IapShopRegularTabItemConfig
    self.config = UIBaseConfig(transform)
    self.localizeTabFunc = localizeTabFunc
    self.hasTimer = self.config.textTimeCountDown ~= nil

    if callBack then
        self:SetListener(callBack)
    end
end

--- @param time string
function IapShopRegularTabItem:SetTime(time)
    self.config.textTimeCountDown.text = time
end

--- @param tabName string
function IapShopRegularTabItem:SetTabName(tabName)
    self.config.textTabName.text = tabName
end

function IapShopRegularTabItem:InitLocalization()
    if self.localizeTabFunc ~= nil then
        self:SetTabName(self.localizeTabFunc())
    else
        XDebug.Log("LOCALIZE NIL " .. self.config.gameObject.name)
    end
end

--- @param listener function
function IapShopRegularTabItem:SetListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

function IapShopRegularTabItem:SetTabState(isHighlight)
    self.config.bgOff:SetActive(not isHighlight)
    self.config.bgOn:SetActive(isHighlight)
    self.config.iconTabOff:SetActive(not isHighlight)
    self.config.iconTabOn:SetActive(isHighlight)

    if isHighlight then
        self.config.textTabName.color = ON_TEXT_COLOR
    else
        self.config.textTabName.color = OFF_TEXT_COLOR
    end
end

function IapShopRegularTabItem:EnableNotify(isEnable)
    self.config.notify:SetActive(isEnable)
end

function IapShopRegularTabItem:SetActive(isEnable)
    self.config.gameObject:SetActive(isEnable)
end

return IapShopRegularTabItem