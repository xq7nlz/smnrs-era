--- @class StatChangerRemoveWhenDeadEffect : StatChangerEffect
StatChangerRemoveWhenDeadEffect = Class(StatChangerRemoveWhenDeadEffect, StatChangerEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
function StatChangerRemoveWhenDeadEffect:Ctor(initiator, target, isBuff)
    StatChangerEffect.Ctor(self, initiator, target, isBuff)

    self.heroDead = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, self.heroDead)
end

--- @return void
--- @param eventData table
function StatChangerRemoveWhenDeadEffect:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        ---@type BaseHero
        local hero = eventData.target
        if hero == self.initiator then
            self.myHero.effectController:ForceRemove(self)
            self.myHero.battle.eventManager:RemoveListener(EventType.HERO_DEAD, self.heroDead)
        end
    end
end
