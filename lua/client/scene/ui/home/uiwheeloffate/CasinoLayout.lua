--- @class CasinoLayout
CasinoLayout = Class(CasinoLayout)

--- @param transform UnityEngine_Transform
--- @param parent UnityEngine_Transform
--- @param casinoType CasinoType
function CasinoLayout:Ctor(transform, parent, casinoType)
    --- @type CasinoLayoutConfig
    self.config = UIBaseConfig(transform)
    --- @type CasinoType
    self.casinoType = casinoType

    UIUtils.SetParent(transform, parent)
    transform:SetAsLastSibling()
end

function CasinoLayout:OnShow()
    self:EnableEffect(false)
    self:SetActive(true)
    self:PlayAnim()
end

function CasinoLayout:PlayAnim()
    local trackEntry = self.config.npc.AnimationState:SetAnimation(1, "idle2", false)
    trackEntry:AddCompleteListenerFromLua(function ()
        self.config.npc.AnimationState:SetAnimation(1, "idle", true)
    end)
end

--- @param isActive boolean
function CasinoLayout:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @param isActive boolean
function CasinoLayout:EnableEffect(isActive)
    self.config.effect:SetActive(isActive)
end

function CasinoLayout:SetRotateWheel(angle)
    self.config.wheel.eulerAngles = angle
end