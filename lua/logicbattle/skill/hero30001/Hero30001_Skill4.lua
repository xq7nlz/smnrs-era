--- @class Hero30001_Skill4 Charon
Hero30001_Skill4 = Class(Hero30001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statType = nil

    --- @type number
    self.numberStack = 0

    --- @type boolean
    self.isAddEffect = false

    --- @type number
    self.bonusAmount = nil

    --- @type number
    self.bonusLimit = nil

    --- @type StatChanger
    self.statChanger = nil

    --- @type StatChangerEffect
    self.effect = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30001_Skill4:CreateInstance(id, hero)
    return Hero30001_Skill4(id, hero)
end

--- @return void
function Hero30001_Skill4:Init()
    self.statType = self.data.statType
    self.bonusAmount = self.data.bonusAmount
    self.bonusLimit = self.data.bonusLimit

    self.statChanger = StatChanger(true)

    self.effect = StatChangerEffect(self.myHero, self.myHero, true)
    self.effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.effect:AddStatChanger(self.statChanger)

    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)

    self.myHero.hp:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Hero30001_Skill4:OnHeroTakeDamage()
    if self.myHero:IsDead() == false then
        self.numberStack = self.numberStack + 1

        local amount = self.bonusAmount * self.numberStack
        if amount > self.bonusLimit then
            amount = self.bonusLimit
        end

        self.statChanger:SetInfo(self.statType, StatChangerCalculationType.PERCENT_ADD, amount)
        if self.isAddEffect == false then
            self.isAddEffect = true
            self.myHero.effectController:AddEffect(self.effect)
        else
            self.effect:Recalculate()
        end
    end
end

--- @return void
function Hero30001_Skill4:OnDead()
    self.numberStack = 0
    self.isAddEffect = false
end

return Hero30001_Skill4