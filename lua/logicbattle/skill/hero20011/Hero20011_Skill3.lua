--- @class Hero20011_Skill3 Labord
Hero20011_Skill3 = Class(Hero20011_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffChance = 0

    --- @type number
    self.statBuffType = 0

    --- @type number
    self.statBuffAmount = 0

    --- @type number
    self.statBuffDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill3:CreateInstance(id, hero)
    return Hero20011_Skill3(id, hero)
end

--- @return void
function Hero20011_Skill3:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20011_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
        statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
        statChangerEffect:AddStatChanger(statChanger)
        statChangerEffect:SetDuration(self.statBuffDuration)

        self.myHero.effectController:AddEffect(statChangerEffect)
    end
end

return Hero20011_Skill3