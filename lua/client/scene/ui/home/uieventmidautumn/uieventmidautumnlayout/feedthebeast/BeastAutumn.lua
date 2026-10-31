--- @class BeastAutumn
BeastAutumn = Class(BeastAutumn)

--- @param transform UnityEngine_Transform
function BeastAutumn:Ctor(transform, level)
    self.level = level
    self:InitConfig(transform)
end

--- @param transform UnityEngine_Transform
function BeastAutumn:InitConfig(transform)
    --- @type {gameObject : UnityEngine_GameObject, transform, anim : Spine_Unity_SkeletonGraphic}
    self.config = {}
    self.config.gameObject = transform.gameObject
    self.config.transform = transform
    self.config.anim = transform:GetComponent(ComponentName.Spine_Unity_SkeletonGraphic)

    UIUtils.SetParent(transform, transform.parent)
    transform:SetAsFirstSibling()
end

function BeastAutumn:PlayIdle()
    self.config.anim.AnimationState:SetAnimation(0, "idle", true)
end

function BeastAutumn:PlayEat()
    self.config.anim.AnimationState:SetAnimation(0, "eat", false)
    self.config.anim.AnimationState:AddAnimation(0, "idle", true, 0)
end

function BeastAutumn:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end