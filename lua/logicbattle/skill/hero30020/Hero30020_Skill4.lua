--- @class Hero30020_Skill4 Thanatos
Hero30020_Skill4 = Class(Hero30020_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30020_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChanger
    self.statChanger = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type boolean
    self.isTriggerEffect = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30020_Skill4:CreateInstance(id, hero)
    return Hero30020_Skill4(id, hero)
end

--- @return void
function Hero30020_Skill4:Init()
    self.statBuffAmount = self.data.statBuffAmount

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.data.statType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.LOST_WHEN_DEAD)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30020_Skill4:OnHeroDead(eventData)
    if self.myHero:IsDead() == false then
        if self.isTriggerEffect then
            self.statChanger:SetAmount(self.statChanger.amount + self.statBuffAmount)
            self.statChangerEffect:Recalculate()
        else
            self.isTriggerEffect = true
            self.statChanger:SetAmount(self.statBuffAmount)
            self.myHero.effectController:AddEffect(self.statChangerEffect)
        end
    else
        self.isTriggerEffect = false
    end
end

return Hero30020_Skill4