require "lua.client.hero.ClientHero2.ClientHero2ActiveSkill"

--- @class ClientHero2 : ClientHero
ClientHero2 = Class(ClientHero2, ClientHero)

--- @return ClientHero2
--- @param heroModelType HeroModelType
function ClientHero2:CreateInstance(heroModelType)
    return ClientHero2(heroModelType)
end

function ClientHero2:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero2ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(80, 81, 53, 52)
    self.skillAttack:SetFrameActionEventWithVideo(132, 133, 112, 107)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero2:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero2:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

function ClientHero2:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end



return ClientHero2