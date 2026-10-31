require "lua.client.hero.ClientHero4.ClientHero4ActiveSkill"

--- @class ClientHero4 : ClientHero
ClientHero4 = Class(ClientHero4, ClientHero)

--- @return ClientHero4
--- @param heroModelType HeroModelType
function ClientHero4:CreateInstance(heroModelType)
    return ClientHero4(heroModelType)
end

function ClientHero4:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero4ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(134, 135, 75, 60)
    self.skillAttack:SetFrameActionEventWithVideo(150, 151, 140, 125)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero4:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero4:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
end

function ClientHero4:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end

return ClientHero4