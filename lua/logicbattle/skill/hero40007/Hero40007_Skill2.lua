--- @class Hero40007_Skill2 Noroth
Hero40007_Skill2 = Class(Hero40007_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40007_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffType = 0
    --- @type number
    self.statBuffAmount = 0
    --- @type number
    self.statBuffDuration = 0

    --- @type StatChanger
    self.statChanger = nil
    --- @type StatChangerEffect
    self.statChangerEffect = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40007_Skill2:CreateInstance(id, hero)
    return Hero40007_Skill2(id, hero)
end

--- @return void
function Hero40007_Skill2:Init()
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    self.statChangerEffect:SetDuration(self.statBuffDuration)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    self.myHero.attackListener:BindingWithSkill_2(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40007_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.myHero.effectController:IsContainEffect(self.statChangerEffect) == false then
        self.statChangerEffect:SetDuration(self.statBuffDuration)

        self.myHero.effectController:AddEffect(self.statChangerEffect)
    end
end

return Hero40007_Skill2