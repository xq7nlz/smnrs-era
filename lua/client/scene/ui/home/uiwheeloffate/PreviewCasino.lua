require "lua.client.scene.ui.home.uiWheelOfFate.CasinoLayout"

--- @class PreviewCasino : BgWorldView
PreviewCasino = Class(PreviewCasino, BgWorldView)

--- @return void
function PreviewCasino:Ctor(transform)
    BgWorldView.Ctor(self, transform)
    --- @type Dictionary
    self.casinoLayoutDict = Dictionary()
    --- @type CasinoLayout
    self.casinoLayout = nil
end

function PreviewCasino:InitConfig(transform)
    --- @type CasinoConfig
    self.config = UIBaseConfig(transform)
end

---@return void
---@param casinoType CasinoType
function PreviewCasino:Show(casinoType)
    self:SetActive(true)
    self:EnableLayout(casinoType)
end

---@param casinoType CasinoType
function PreviewCasino:EnableLayout(casinoType)
    if self.casinoLayout ~= nil and self.casinoLayout.casinoType ~= casinoType then
        self.casinoLayout:SetActive(false)
    end
    self.casinoLayout = self.casinoLayoutDict:Get(casinoType)
    if self.casinoLayout == nil then
        local bg = PrefabLoadUtils.Instantiate("casino_" .. casinoType)
        self.casinoLayout = CasinoLayout(bg.transform, self.config.transform, casinoType)
        self.casinoLayoutDict:Add(casinoType, self.casinoLayout)
    end
    self.casinoLayout:OnShow()
end

---@return void
function PreviewCasino:Hide()
    self:SetActive(false)
end

---@return void
---@param spineAnimation Spine_Unity_SkeletonAnimation
---@param anim string
function PreviewCasino:_StartAnim(spineAnimation, anim)
    if spineAnimation.state ~= nil then
        spineAnimation.state:SetAnimation(1, anim, true)
    end
end

---@return void
---@param spineAnimation Spine_Unity_SkeletonAnimation
---@param anim string
function PreviewCasino:_SpinAnim(spineAnimation, anim)
    local trackEntry = spineAnimation.AnimationState:SetAnimation(1, anim, false)
    trackEntry:AddCompleteListenerFromLua(function()
        spineAnimation.AnimationState:SetAnimation(1, "idle", true)
    end)
end

---@return void
function PreviewCasino:PlayAnim()
    self:PlayEffect(true)
    self.casinoLayout:PlayAnim()
end

---@return void
function PreviewCasino:PlayEffect(active)
    self.casinoLayout:EnableEffect(active)
end

function PreviewCasino:SetRotateWheel(rotate)
    self.casinoLayout:SetRotateWheel(rotate)
end

function PreviewCasino:GetFxAnchor()
    return self.config.fxCasinoBgActive
end