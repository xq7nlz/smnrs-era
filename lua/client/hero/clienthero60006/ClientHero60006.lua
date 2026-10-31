require "lua.client.hero.ClientHero60006.ClientHero60006MeleeAttack"
require "lua.client.hero.ClientHero60006.ClientHero60006ActiveSkill"

--- Hehta
--- @class ClientHero60006 : ClientHero
ClientHero60006 = Class(ClientHero60006, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60006:CreateInstance(heroModelType)

    return ClientHero60006(heroModelType)
end

--- @param baseHero BaseHero
--- @param overridePosition UnityEngine_Vector3
function ClientHero60006:Init(baseHero, overridePosition)
    ClientHero.Init(self, baseHero, overridePosition)
    self.transferEffectName = string.format("hero_%s_skill_buff_projectile", self.baseHero.id)
    self.deadBuffEffect = string.format("hero_%s_skill_dead_buff", self.baseHero.id)
end

function ClientHero60006:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 60006002 then
            require "lua.client.hero.ClientHero60006.60006002.ClientHero60006002MeleeAttack"
            self.basicAttack = ClientHero60006002MeleeAttack(self)
            self.basicAttack:SetFrameActionEvent(66, 67, 25, -1)
        elseif self.skinId == 60006003 then
            require "lua.client.hero.ClientHero60006.60006003.ClientHero60006003MeleeAttack"
            self.basicAttack = ClientHero60006003MeleeAttack(self)
            self.basicAttack:SetFrameActionEvent(66, 67, 25, -1)
        elseif self.skinId == 60006004 then
            require "lua.client.hero.ClientHero60006.60006004.ClientHero60006004MeleeAttack"
            self.basicAttack = ClientHero60006004MeleeAttack(self)
            self.basicAttack:SetFrameActionEvent(66, 67, 25, -1)
        else
            self.basicAttack = ClientHero60006MeleeAttack(self)
            self.basicAttack:SetFrameActionEvent(66, 67, 24, -1)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 60006002 then
            require "lua.client.hero.ClientHero60006.60006002.ClientHero60006002ActiveSkill"
            self.skillAttack = ClientHero60006002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(96, 97, 53, 20)
        elseif self.skinId == 60006003 then
            require "lua.client.hero.ClientHero60006.60006003.ClientHero60006003ActiveSkill"
            self.skillAttack = ClientHero60006003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(96, 97, 53, 20)
        elseif self.skinId == 60006004 then
            require "lua.client.hero.ClientHero60006.60006004.ClientHero60006004ActiveSkill"
            self.skillAttack = ClientHero60006004ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(96, 97, 53, 20)
        else
            self.skillAttack = ClientHero60006ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(89, 90, 30, 28)
        end
    end
end

function ClientHero60006:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60006:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

--- @param target ClientHero
function ClientHero60006:OnTransferStat(target)
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    self.actionCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(15 * AnimationConstants.FRAME_LENGTH)
        self:StartEffect(target)
        self.actionCoroutine = nil
    end)
end
--- @param target ClientHero
function ClientHero60006:StartEffect(target)
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.transferEffectName)
    if projectile ~= nil then
        if target ~= nil then
            local targetPosition = target.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
            local spawnPos = targetPosition + U_Vector3(-2, 2, 0)
            projectile:SetPosition(spawnPos)
            projectile:DoMoveTween(targetPosition, 0.5, function()
                projectile:Release()
            end)
            projectile:Play()
        end
    end
end
return ClientHero60006