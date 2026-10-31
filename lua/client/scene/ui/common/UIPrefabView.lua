--- @class UIPrefabView
UIPrefabView = Class(UIPrefabView)

--- @return void
--- @param transform UnityEngine_RectTransform
function UIPrefabView:Ctor(transform)
    self.parent = nil
    --- @type string
    self.prefabName = nil
    --- @type UIPoolType
    self.uiPoolType = nil
    --- @type {transform : UnityEngine_RectTransform}
    self.config = nil

    self.language = nil

    self:SetPrefabName()
    self:SetConfig(transform and transform or self:GetTransform())
end

--- @return void
function UIPrefabView:SetPrefabName()
    assert(false, "override this method")
    self.prefabName = ''
    self.uiPoolType = nil
end

--- @return void
function UIPrefabView:OverridePrefab(prefabName)
    if self.prefabName ~= prefabName then
        U_Object.Destroy(self.config.transform.gameObject)
        self.config = nil
        self.prefabName = prefabName
        self:SetConfig(self:GetTransform())
    end
end

--- @return void
--- @param transform UnityEngine_Transform
function UIPrefabView:SetConfig(transform)
    assert(false, "override this method")
end

--- @return void
function UIPrefabView:CheckLoadLocalize()
    if self.language ~= PlayerSettingData.language then
        self.language = PlayerSettingData.language
        FontUtils.SetNewFont(self.config.transform, self.language)
        self:InitLocalization()
    end
end

--- @return void
function UIPrefabView:InitLocalization()
    -- override
end

--- @return void
--- @param parent UnityEngine_Transform
function UIPrefabView:SetParent(parent)
    UIUtils.SetParent(self.config.transform, parent)
end

--- @return UnityEngine_Transform
function UIPrefabView:GetTransform()
    if self.config ~= nil then
        return self.config.transform
    else
        return SmartPool.Instance:SpawnTransform(AssetType.UIPool, self.prefabName)
    end
end

--- @return number
function UIPrefabView:GetInstanceID()
    return self.config.transform:GetInstanceID()
end

--- @return void
function UIPrefabView:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

--- @return void
function UIPrefabView:SetAsLastSibling()
    self.config.transform:SetAsLastSibling()
end

--- @return void
function UIPrefabView:Show()
    self.config.gameObject:SetActive(true)
    self:CheckLoadLocalize()
end

--- @return void
function UIPrefabView:ReturnPool()
    self.config.gameObject:SetActive(false)
    SmartPool.Instance:DespawnLuaGameObject(AssetType.UIPool, self.uiPoolType, self)
end

--- @return void
function UIPrefabView:UpdateView()
    assert(false, "override this method")
end

function UIPrefabView:DefaultShow()
    -- override
end

return UIPrefabView
