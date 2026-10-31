---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiWorldMap.UIWorldMapGateConfig"

--- @class UIWorldMapGateItem : IconView
UIWorldMapGateItem = Class(UIWorldMapGateItem, IconView)

--- @return void
function UIWorldMapGateItem:Ctor()
    --- @type number
    self.index = nil
    IconView.Ctor(self)
end

--- @return void
function UIWorldMapGateItem:SetPrefabName()
    self.prefabName = 'ui_world_map_gate'
    self.uiPoolType = UIPoolType.WorldMapGateItem
end

--- @return void
--- @param transform UnityEngine_Transform
function UIWorldMapGateItem:SetConfig(transform)
    --- @type UIWorldMapGateConfig
    ---@type UIWorldMapGateConfig
    self.config = UIBaseConfig(transform)
end

function UIWorldMapGateItem:InitLocalization()
    self.config.localizeComplete.text = LanguageUtils.LocalizeCommon("complete")
end

--- @param spriteBgGate UnityEngine_Sprite
function UIWorldMapGateItem:SetBg(spriteBgGate)
    self.config.bgGate.sprite = spriteBgGate
end

--- @param index number
--- @param isComplete boolean
--- @param isOpen boolean
--- @param isEnableArrow boolean
function UIWorldMapGateItem:SetData(index, isComplete, isOpen, isEnableArrow, playLoopOnDefault)
    self.index = index
    self.config.name.text = LanguageUtils.LocalizeCommon(string.format("gate")) .. " " .. index
    self.config.complete:SetActive(isComplete)
    self.config.cover:SetActive(not isOpen or isComplete)
    self:SetOpen(isOpen)
    self.config.arrowNext:SetActive(isEnableArrow)
    self.config.openMark:SetActive(isOpen and not isComplete)
    if isOpen and not isComplete and playLoopOnDefault == true then
        self.config.fxUiGateLoop:Play()
    end
end

--- @param isComplete boolean
--- @param isOpen boolean
function UIWorldMapGateItem:UpdateState(isComplete, isOpen)
    self.config.complete:SetActive(isComplete)
    self.config.cover:SetActive(not isOpen or isComplete)
    self:SetOpen(isOpen)
    self.config.openMark:SetActive(isOpen and not isComplete)
end

--- @param isOpen boolean
function UIWorldMapGateItem:SetOpen(isOpen)
    self.config.gateOpen:SetActive(isOpen)
    self.config.gateClose:SetActive(not isOpen)
end

--- @param listener function
function UIWorldMapGateItem:AddOnClickListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function ()
        if listener ~= nil then
            listener()
        end
    end)
end

return UIWorldMapGateItem