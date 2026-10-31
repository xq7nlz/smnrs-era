require "lua.client.hero.ClientHero30007.ClientHero30007RangeAttack"
require "lua.client.hero.ClientHero30007.ClientHero30007ActiveSkill"

--- Zygor
--- @class ClientHero30007 : ClientHero
ClientHero30007 = Class(ClientHero30007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30007:CreateInstance(heroModelType)
    return ClientHero30007(heroModelType)
end

function ClientHero30007:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 30007002 then
            require "lua.client.hero.ClientHero30007.ClientHero30007002.ClientHero30007002RangeAttack"
            self.basicAttack = ClientHero30007002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 46, 21, 16)
        elseif self.skinId == 30007001 then
            require "lua.client.hero.ClientHero30007.ClientHero30007001.ClientHero30007001RangeAttack"
            self.basicAttack = ClientHero30007001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 46, 34, 29)
        else
            self.basicAttack = ClientHero30007RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 46, 21, 16)
        end

    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 30007002 then
            require "lua.client.hero.ClientHero30007.ClientHero30007002.ClientHero30007002ActiveSkill"
            self.skillAttack = ClientHero30007002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 75, 40, -1)
        elseif self.skinId == 30007001 then
            require "lua.client.hero.ClientHero30007.ClientHero30007001.ClientHero30007001ActiveSkill"
            self.skillAttack = ClientHero30007001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(102, 103, 55, -1)
        else
            self.skillAttack = ClientHero30007ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 75, 40, -1)
        end
    end
end

function ClientHero30007:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30007:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:PlayAnimation("effect", true, 0)
    self:PlayAnimation("detail", true, 1)
end

--- @param actionResult BaseActionResult
function ClientHero30007:TriggerSubActiveSkill(actionResult)
    local effectName = nil
    if self.skinId == 30007002 then
        effectName = self:GetEffectNameByFormat("hero_%s_%s_explosion")
    elseif self.skinId == 30007001 then

    else
        effectName = self:GetEffectNameByFormat("hero_%s_explosion")
    end
    if (effectName ~= nil) then
        local exploseEffect = self.clientBattleShowController:GetClientEffect(AssetType.HeroBattleEffect, effectName)
        exploseEffect:SetToHeroAnchor(self)
    end
end

return ClientHero30007