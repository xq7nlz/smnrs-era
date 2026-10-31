--- @class BgWorldView : PrefabView
BgWorldView = Class(BgWorldView, PrefabView)

--- @param transform UnityEngine_Transform
function BgWorldView:Ctor(transform)
    self:InitConfig(transform)
    self:UpdateView()
    self:OnCreated()
end

--- @param transform UnityEngine_Transform
function BgWorldView:InitConfig(transform)
    ---@type BgWorldConfig
    self.config = UIBaseConfig(transform)
end

function BgWorldView:OnCreated()
    self.config.transform:SetParent(zgUnity.transform)
    self.config.transform.position = U_Vector3.zero
    self.config.transform.localScale = U_Vector3.one
end

function BgWorldView:UpdateView()
    local screenSize = U_Vector2(U_Screen.width, U_Screen.height)
    self.config.camera.orthographicSize = ClientConfigUtils.GetCameraSizeFromViewSize(screenSize)
end

function BgWorldView:OnDestroy()
    U_Object.Destroy(self.config.gameObject)
end

--- @param isActive boolean
function BgWorldView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
    self.config.camera.enabled = isActive
end

function BgWorldView:OnHide()
    self:SetActive(false)
end