--- @class IapShopTabItem
IapShopTabItem = Class(IapShopTabItem)

local ON_ICON_TAB_COLOR = U_Color(0.55, 0.49, 0.43, 1)
local OFF_ICON_TAB_COLOR = U_Color(1, 1, 1, 1)

local ON_TEXT_COLOR = U_Color(0.42, 0.34, 0.24, 1)
local OFF_TEXT_COLOR = U_Color(0.77, 0.7, 0.58, 1)

--- @param transform UnityEngine_Transform
--- @param callBack function
--- @param localizeTabFunc function
function IapShopTabItem:Ctor(transform, callBack, localizeTabFunc)
    --- @type IapShopTabItemConfig
    self.config = UIBaseConfig(transform)
    self.localizeTabFunc = localizeTabFunc
    self.hasTimer = self.config.textTimeCountDown ~= nil

    if callBack then
        self:SetListener(callBack)
    end
end

--- @param time string
function IapShopTabItem:SetTime(time)
    self.config.textTimeCountDown.text = time
end

--- @param tabName string
function IapShopTabItem:SetTabName(tabName)
    self.config.textTabName.text = tabName
end

function IapShopTabItem:InitLocalization()
    if self.localizeTabFunc ~= nil then
        self:SetTabName(self.localizeTabFunc())
    else
        XDebug.Log("LOCALIZE NIL " .. self.config.gameObject.name)
    end
end

--- @param listener function
function IapShopTabItem:SetListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

function IapShopTabItem:SetTabState(isHighlight)
    self.config.bgOff:SetActive(not isHighlight)
    self.config.bgOn:SetActive(isHighlight)
    if isHighlight then
        if self.config.iconTab ~= nil then
            self.config.iconTab.color = ON_ICON_TAB_COLOR
        end
        self.config.textTabName.color = ON_TEXT_COLOR
    else
        if self.config.iconTab ~= nil then
            self.config.iconTab.color = OFF_ICON_TAB_COLOR
        end
        self.config.textTabName.color = OFF_TEXT_COLOR
    end
end

function IapShopTabItem:EnableNotify(isEnable)
    self.config.notify:SetActive(isEnable)
end

function IapShopTabItem:SetActive(isEnable)
    self.config.gameObject:SetActive(isEnable)
end

return IapShopTabItem