--- @class Hero50014_Skill4 Hweston
Hero50014_Skill4 = Class(Hero50014_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50014_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffChance = 0

    --- @type number
    self.statBuffType = 0

    --- @type number
    self.statBuffAmount = 0

    --- @type StatChanger
    self.statChanger = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil

    --- @type boolean
    self.wasAdded = false
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50014_Skill4:CreateInstance(id, hero)
    return Hero50014_Skill4(id, hero)
end

--- @return void
function Hero50014_Skill4:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.myHero.hp:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50014_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --- check can heal
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        if self.wasAdded == false then
            self.statChanger = StatChanger(true)
            self.statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)
            self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
            self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
            self.statChangerEffect:AddStatChanger(self.statChanger)
            self.myHero.effectController:AddEffect(self.statChangerEffect)
            self.wasAdded = true
        else
            local totalPercent = self.statChanger:GetAmount() + self.statBuffAmount
            self.statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, totalPercent)
            self.statChangerEffect:Recalculate()
        end
    end
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero50014_Skill4:Dead(initiator, reason)
    self.wasAdded = false
end

return Hero50014_Skill4