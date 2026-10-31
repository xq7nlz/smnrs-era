--- @class Hero30006_Skill4 Thanatos
Hero30006_Skill4 = Class(Hero30006_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimitToKill = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill4:CreateInstance(id, hero)
    return Hero30006_Skill4(id, hero)
end

--- @return void
function Hero30006_Skill4:Init()
    self.hpLimitToKill = self.data.hpLimitToKill

    local listener = EventListener(nil, self, self.OnOtherHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
--- @param eventData table
function Hero30006_Skill4:OnOtherHeroTakeDamage(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if self.myHero:IsAlly(target) == false then
            if target:IsDead() == false and target.hp:GetStatPercent() < self.hpLimitToKill then
                if target:IsBoss() == false then
                    local result
                    local instantKillResult = target.hp:Dead(self.myHero, TakeDamageReason.INSTANT_KILL)
                    if instantKillResult == true then
                        result = InstantKillResult(self.myHero, target)
                    else
                        result = ResistInstantKillResult(self.myHero, target)
                    end

                    ActionLogUtils.AddLog(self.myHero.battle, result)
                end
            end
        end
    end
end

return Hero30006_Skill4