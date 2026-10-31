require "lua.client.hero.ClientHero3.ClientHero3ActiveSkill"

--- @class ClientHero3 : ClientHero
ClientHero3 = Class(ClientHero3, ClientHero)

--- @return ClientHero3
--- @param heroModelType HeroModelType
function ClientHero3:CreateInstance(heroModelType)
    return ClientHero3(heroModelType)
end

function ClientHero3:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    self.skillAttack = ClientHero3ActiveSkill(self)
    self.skillAttack:SetFrameActionEvent(75, 76, 45, 40)
    self.skillAttack:SetFrameActionEventWithVideo(178, 179, 143, 138)
    self.basicAttack = self.skillAttack

    self:SpawnSummonerEffectBody()
end

function ClientHero3:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero3:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
    ClientHero.PlayAnimation(self, "book", true, 2)
end

function ClientHero3:SpawnSummonerEffectBody()
    if self.heroModelType ~= HeroModelType.Dummy then
        local effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_summoner_body")
        effect:SetToHeroAnchor(self)
    end
end

return ClientHero3