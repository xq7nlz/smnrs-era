--- @class Hero20006_Skill3 Finde
Hero20006_Skill3 = Class(Hero20006_Skill3, BaseSkill)

--- @return BaseSkill
function Hero20006_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberRound = 0
end

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20006_Skill3:CreateInstance(id, hero)
    return Hero20006_Skill3(id, hero)
end

--- @return void
function Hero20006_Skill3:Init()
    self.myHero.battleListener:BindingWithSkill_3(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

--- @return void
--- @param round BattleRound
function Hero20006_Skill3:OnStartBattleRound(round)
    if self.myHero:IsDead() == false then
        self.numberRound = self.numberRound + 1
        if self.numberRound >= self.data.numberRoundToBuff then
            self.numberRound = 0

            local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
            statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
            statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
        end
    end
end

--- @return void
--- @param eventData table
function Hero20006_Skill3:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        self.numberRound = 0
    end
end

return Hero20006_Skill3