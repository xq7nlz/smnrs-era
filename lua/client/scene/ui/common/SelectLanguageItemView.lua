---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.SelectLanguageItemConfig"

--- @class SelectLanguageItemView : IconView
SelectLanguageItemView = Class(SelectLanguageItemView, IconView)

--- @return void
function SelectLanguageItemView:Ctor()
    IconView.Ctor(self)
    ---@type Language
    self.language = nil
end

--- @return void
function SelectLanguageItemView:SetPrefabName()
    self.prefabName = 'select_language'
    self.uiPoolType = UIPoolType.SelectLanguageItemView
end

--- @return void
function SelectLanguageItemView:AutoFillSize()
    --Coroutine.start(function ()
    --    self.config.layout.enabled = false
    --    coroutine.waitforendofframe()
    --    self.config.layout.enabled = true
    --    coroutine.waitforendofframe()
    --    self.config.layout.enabled = false
    --    coroutine.waitforendofframe()
    --    self.config.layout.enabled = true
    --end)
end

--- @return void
--- @param transform UnityEngine_Transform
function SelectLanguageItemView:SetConfig(transform)
    assert(transform)
    --- @type SelectLanguageItemConfig
    ---@type SelectLanguageItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param language Language
function SelectLanguageItemView:SetData(language)
    self.language = language
    self.config.textLanguage.text = language.name
    self:SetSelected(language.keyLanguage == PlayerSettingData.language)
end

--- @return void
---@param isSelect boolean
function SelectLanguageItemView:SetSelected(isSelect)
    self.config.box:SetActive(isSelect)
    self.config.bgSelect:SetActive(isSelect)
    --self.config.layout.enabled = false
    self:AutoFillSize()
end

--- @return void
function SelectLanguageItemView:AddListener(fuc)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        fuc(self.language)
    end)
end

return SelectLanguageItemView