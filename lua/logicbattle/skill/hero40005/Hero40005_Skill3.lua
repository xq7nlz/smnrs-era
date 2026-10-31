--- @class Hero40005_Skill3 Yang
Hero40005_Skill3 = Class(Hero40005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberStacks = 0

    --- @type boolean
    self.isAddToHero = false

    --- @type StatType
    self.statType = nil

    --- @type number
    self.statAmountPerUseSkill = nil

    --- @type StatChanger
    self.statChanger = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill3:CreateInstance(id, hero)
    return Hero40005_Skill3(id, hero)
end

--- @return void
function Hero40005_Skill3:Init()
    self.statType = self.data.statType
    self.statAmountPerUseSkill = self.data.statAmountPerUseSkill

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.statType, StatChangerCalculationType.PERCENT_ADD, 0)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    self.myHero.hp:BindingWithSkill_3(self)

    local listener = EventListener(self.myHero, self, self.OnActiveSkillUsed)
    self.myHero.battle.eventManager:AddListener(EventType.USE_ACTIVE_SKILL, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Hero40005_Skill3:OnDead()
    self.numberStacks = 0
    self.isAddToHero = false
end

--- @return void
--- @param eventData table
function Hero40005_Skill3:OnActiveSkillUsed(eventData)
    self.numberStacks = self.numberStacks + 1
    self.statChanger:SetInfo(self.statType, StatChangerCalculationType.PERCENT_ADD,
            self.numberStacks * self.statAmountPerUseSkill)

    if self.isAddToHero then
        self.statChangerEffect:Recalculate()
    else
        self.isAddToHero = true
        self.myHero.effectController:AddEffect(self.statChangerEffect)
    end
end

return Hero40005_Skill3