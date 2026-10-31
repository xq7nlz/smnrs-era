--- @class BgMarket
BgMarket = Class(BgMarket)

--- @param transform UnityEngine_RectTransform
function BgMarket:Ctor(transform, parent, bgName)
    --- @type BgMarketConfig
    self.config = UIBaseConfig(transform)
    --- @type string
    self.bgName = bgName

    transform:SetParent(parent)
    transform:SetAsFirstSibling()
    transform.anchoredPosition3D = U_Vector3.zero
    transform.localScale = U_Vector3.one * 1.175
end

function BgMarket:OnShow()
    self:SetActive(true)
    self.config.npc.AnimationState:SetAnimation(0, "start", false)
    self.config.npc.AnimationState:AddAnimation(0, "idle", true, 0)
end

function BgMarket:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end