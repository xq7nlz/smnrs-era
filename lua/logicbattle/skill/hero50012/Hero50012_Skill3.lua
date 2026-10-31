--- @class Hero50012_Skill3 Alvar
Hero50012_Skill3 = Class(Hero50012_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.statBuffType_1 = nil
    --- @type number
    self.statBuffAmount_1 = nil
    --- @type EffectType
    self.statBuffType_2 = nil
    --- @type number
    self.statBuffAmount_2 = nil
    --- @type number
    self.statBuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill3:CreateInstance(id, hero)
    return Hero50012_Skill3(id, hero)
end

--- @return void
function Hero50012_Skill3:Init()
    self.statBuffType_1 = self.data.statBuffType_1
    self.statBuffAmount_1 = self.data.statBuffAmount_1

    self.statBuffType_2 = self.data.statBuffType_2
    self.statBuffAmount_2 = self.data.statBuffAmount_2

    self.statBuffDuration = self.data.statBuffDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero50012_Skill3:OnDealCritDamage(enemyDefender, totalDamage)
    local statChanger_1 = StatChanger(true)
    statChanger_1:SetInfo(self.statBuffType_1, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount_1)
    local statChanger_2 = StatChanger(true)
    statChanger_2:SetInfo(self.statBuffType_2, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount_2)

    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetDuration(self.statBuffDuration)
    effect:AddStatChanger(statChanger_1)
    effect:AddStatChanger(statChanger_2)
    effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
    self.myHero.effectController:AddEffect(effect)
end

return Hero50012_Skill3