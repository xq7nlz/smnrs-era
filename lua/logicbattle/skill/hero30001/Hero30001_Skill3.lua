--- @class Hero30001_Skill3 Charon
Hero30001_Skill3 = Class(Hero30001_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<BaseHero>
    self.targetList = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill3:CreateInstance(id, hero)
    return Hero30001_Skill3(id, hero)
end

--- @return void
function Hero30001_Skill3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)
    self.targetList = targetSelector:SelectTarget(self.myHero.battle)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)

    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    self.statChangerSkillHelper:SetInfo(false, EffectConstants.INFINITY_DURATION)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30001_Skill3:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if self.myHero:IsAlly(target) then
            for i = 1, self.targetList:Count() do
                local enemy = self.targetList:Get(i)
                self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, enemy)
            end
        end
    end
end

return Hero30001_Skill3