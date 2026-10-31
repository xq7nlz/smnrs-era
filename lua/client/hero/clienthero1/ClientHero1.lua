require "lua.client.hero.ClientHero1.ClientHero1ActiveSkill"

--- @class ClientHero1 : ClientHero
ClientHero1 = Class(ClientHero1, ClientHero)

--- @return ClientHero1
--- @param heroModelType HeroModelType
function ClientHero1:CreateInstance(heroModelType)
    return ClientHero1(heroModelType)
end

function ClientHero1:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero1ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(80, 81, 52, 47)
    self.skillAttack:SetFrameActionEventWithVideo(171, 172, 135, 130)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero1:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero1:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "vatao", true, 1)
end

function ClientHero1:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end

return ClientHero1