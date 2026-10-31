--- @class Hero60002_Skill3 Bloodseeker
Hero60002_Skill3 = Class(Hero60002_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healPercent = nil

    --- @type List<BaseHero>
    self.heroTriggerList = List()

    --- @type boolean
    self.isInTurn = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill3:CreateInstance(id, hero)
    return Hero60002_Skill3(id, hero)
end

--- @return void
function Hero60002_Skill3:Init()
    self.healPercent = self.data.healPercent

    self.myHero.hp:BindingWithSkill_3(self)
    self.myHero.battleListener:BindingWithSkill_3(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero60002_Skill3:OnStartBattleRound(round)
    self.isInTurn = false
end

--- @return void
--- @param round BattleRound
function Hero60002_Skill3:OnStartBattleTurn(round)
    self.isInTurn = true
end

--- @return void
--- @param eventData table
function Hero60002_Skill3:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if self.myHero:IsAlly(target) == false then
            if self.heroTriggerList:IsContainValue(target) == false then
                local healAmount = target.hp:GetMax() * self.healPercent
                HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
                self.heroTriggerList:Add(target)
            end
        end
    end
end

--- return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero60002_Skill3:OnDead(initiator, reason)
    self.heroTriggerList:Clear()
end

return Hero60002_Skill3