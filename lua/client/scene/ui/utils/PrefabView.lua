require "lua.client.utils.PrefabLoadUtils"

--- @class PrefabView
PrefabView = Class(PrefabView)

--- @return void
function PrefabView:Ctor()
    self.parent = nil
    --- @type string
    self.prefabName = nil
    --- @type {transform : UnityEngine_RectTransform}
    self.config = nil
    --- @type string
    self.language = nil

    self:SetPrefabName()
    self:SetConfig(self:GetTransform())
end

--- @return void
function PrefabView:SetPrefabName()
    assert(false, "override this method")
    self.prefabName = ''
end

--- @return void
--- @param transform UnityEngine_Transform
function PrefabView:SetConfig(transform)
    assert(false, "override this method")
end

--- @return void
function PrefabView:CheckLoadLocalize()
    if self.language ~= PlayerSettingData.language then
        self.language = PlayerSettingData.language
        FontUtils.SetNewFont(self.config.transform, self.language)
        self:InitLocalization()
    end
end

--- @return void
function PrefabView:InitLocalization()
    -- override
end

--- @return void
--- @param parent UnityEngine_Transform
function PrefabView:SetParent(parent)
    UIUtils.SetParent(self.config.transform, parent)
end

--- @return UnityEngine_Transform
function PrefabView:GetTransform()
    if self.config ~= nil then
        return self.config.transform
    else
        --- @type UnityEngine_GameObject
        local gameObject = PrefabLoadUtils.Instantiate(self.prefabName)
        return gameObject.transform
    end
end

--- @return number
function PrefabView:GetInstanceID()
    return self.config.transform:GetInstanceID()
end

--- @return void
function PrefabView:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

--- @return void
function PrefabView:SetAsLastSibling()
    self.config.transform:SetAsLastSibling()
end

--- @return void
function PrefabView:Show(data)
    self:OnShow(data)
    self:CheckLoadLocalize()
    self.config.gameObject:SetActive(true)
end

--- @return void
function PrefabView:OnShow()

end

--- @return void
function PrefabView:Hide()
    self.config.gameObject:SetActive(false)
    self:OnHide()
end

--- @return void
function PrefabView:OnHide()

end
