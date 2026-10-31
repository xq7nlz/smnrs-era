--- @class BondLink
BondLink = Class(BondLink)

--- @param gameObject UnityEngine_GameObject
function BondLink:Ctor(gameObject)
    --- @type BondLinkConfig
    self.config = UIBaseConfig(gameObject)

    self._bondTweener = nil
    self._animName = "bond"

    --- @type UnityEngine_Transform
    self._initiatorTorso = nil
    self._targetTorso = nil
end

--- @param initiator ClientHero
--- @param target ClientHero
function BondLink:MakeBond(initiator, target)
    self:_KillBondTweener()
    self._initiatorTorso = initiator.components:GetHeroAnchor(ClientConfigUtils.TORSO_ANCHOR)
    self._targetTorso = target.components:GetHeroAnchor(ClientConfigUtils.TORSO_ANCHOR)
    self._bondTweener = Coroutine.start(function()
        while true do
            coroutine.yield(nil)
            self:_UpdatePointPosition()
        end
    end)
    self:_PlayEffect()
end

function BondLink:_KillBondTweener()
    if self._bondTweener ~= nil then
        Coroutine.stop(self._bondTweener)
        self._bondTweener = nil
    end
end

function BondLink:_PlayEffect()
    local trackEntry = self.config.anim.AnimationState:SetAnimation(0, self._animName, false)
    trackEntry:AddCompleteListenerFromLua(function()
        self:_KillBondTweener()
        SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bond_linking", self.config.transform)
    end)
end

function BondLink:_UpdatePointPosition()
    self.config.mainBone.position = self._initiatorTorso.position
    self.config.targetBone.position = self._targetTorso.position
end