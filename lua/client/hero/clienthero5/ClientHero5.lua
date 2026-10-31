require "lua.client.hero.ClientHero5.ClientHero5ActiveSkill"

--- @class ClientHero5 : ClientHero
ClientHero5 = Class(ClientHero5, ClientHero)

--- @return ClientHero5
--- @param heroModelType HeroModelType
function ClientHero5:CreateInstance(heroModelType)
    return ClientHero5(heroModelType)
end

function ClientHero5:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero5ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(90, 91, 80, 65)
    self.skillAttack:SetFrameActionEventWithVideo(170, 171, 155, 140)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero5:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero5:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

function ClientHero5:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end

return ClientHero5