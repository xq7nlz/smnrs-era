--- @class NpcDungeonSeller
NpcDungeonSeller = Class(NpcDungeonSeller)

--- @param shopType number
function NpcDungeonSeller:Ctor(shopType)
    --- @type number
    self.shopType = shopType
    --- @type UnityEngine_GameObject
    self.gameObject = nil
    --- @type UnityEngine_Transform
    self.transform = nil
    --- @type Spine_Unity_SkeletonAnimation
    self.anim = nil
    --- @type UnityEngine_Transform
    self.parent = nil
end

--- @return void
--- @param parent UnityEngine_Transform
function NpcDungeonSeller:SetConfig(parent, callback)
    local prefabName = string.format("dungeon_seller_%s_model", self.shopType)
    self.parent = parent
    local onNpcInstantiated = function(gameObject)
        self.gameObject = gameObject
        self.transform = self.gameObject.transform
        self.anim = self.transform:Find("model"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
        assert(self.transform and self.anim)
        self:ResetTransform()

        if callback then
            callback()
        end
    end
    PrefabLoadUtils.InstantiateAsync(prefabName, onNpcInstantiated)
end

--- @return void
function NpcDungeonSeller:PlayAnim()
    self.anim.AnimationState:ClearTracks()
    self.anim.skeleton:SetToSetupPose()

    --- @type Spine_TrackEntry
    local trackEntry = self.anim.AnimationState:SetAnimation(0, "start", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.anim.AnimationState:SetAnimation(0, "idle", true)
    end)
end

function NpcDungeonSeller:Show()
    self.gameObject:SetActive(true)
end

function NpcDungeonSeller:Hide()
    self.gameObject:SetActive(false)
end

function NpcDungeonSeller:ResetTransform()
    self.transform:SetParent(self.parent)
    self.transform.localPosition = U_Vector3.zero
    self.transform.localEulerAngles = U_Vector3.zero
    self.transform.localScale = U_Vector3(-1, 1, 1)
end