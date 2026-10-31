require "lua.client.hero.ClientHero30006.ClientHero30006RangeAttack"
require "lua.client.hero.ClientHero30006.ClientHero30006ActiveSkill"

--- Zyx
--- @class ClientHero30006 : ClientHero
ClientHero30006 = Class(ClientHero30006, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30006:CreateInstance(heroModelType)
    return ClientHero30006(heroModelType)
end

function ClientHero30006:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 30006001 then
            require "lua.client.hero.ClientHero30006.30006001.ClientHero30006001RangeAttack"
            self.basicAttack = ClientHero30006001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(50, 51, -1, 23)
        else
            self.basicAttack = ClientHero30006RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(30, 40, -1, 14)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 30006001 then
            require "lua.client.hero.ClientHero30006.30006001.ClientHero30006001ActiveSkill"
            self.skillAttack = ClientHero30006001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(90, 91, 54, 0)
        else
            self.skillAttack = ClientHero30006ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(90, 91, 54, -1)
        end
    end
end

function ClientHero30006:OnAddEffect(effectLogType)
    if effectLogType == EffectLogType.NON_TARGETED_MARK then
        ClientHero.PlayAnimation(self, "color_untarget", false, 1)
    end
end

function ClientHero30006:OnRemoveEffect(effectLogType)
    if effectLogType == EffectLogType.NON_TARGETED_MARK then
        self.animation:ClearTrack(1)
        self:PlayStartAnimation()
    end
end

return ClientHero30006