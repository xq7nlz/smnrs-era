
--- @class UIPopupInfo
UIPopupInfo = Class(UIPopupInfo)

--- @return void
--- @param name UIPopupName
function UIPopupInfo:Ctor(name)
    --- @type UIPopupName
    self.name = name
    --- @type UIBase
    self.popup = nil

    self:Init()
end

--- @return void
function UIPopupInfo:Init()
    --- @type UIBase
    local class = require(self.name)
    if type(class) ~= 'boolean' then
        self.popup = class()
        self.type = self.popup.model.type
    else
        XDebug.Error("popup is nil: " .. self.name .. ".")
    end
end

--- @return void
function UIPopupInfo:Preload()
    self.popup.view:OnCreate()
end

--- @return void
function UIPopupInfo:Show(data)
    self.popup.view:Show(data)
end

--- @return void
function UIPopupInfo:Hide()
    self.popup.view:Hide()
end

--- @return void
function UIPopupInfo:RefreshView()
    self.popup.view:RefreshView()
end