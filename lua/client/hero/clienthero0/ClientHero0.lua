require "lua.client.hero.ClientHero0.ClientHero0ActiveSkill"

--- @class ClientHero0 : ClientHero
ClientHero0 = Class(ClientHero0, ClientHero)

--- @return ClientHero0
--- @param heroModelType HeroModelType
function ClientHero0:CreateInstance(heroModelType)
    return ClientHero0(heroModelType)
end

function ClientHero0:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero0ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(74, 75, 43, -1)
    self.skillAttack:SetFrameActionEventWithVideo(82, 115, 95, -1)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero0:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero0:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

function ClientHero0:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end

return ClientHero0