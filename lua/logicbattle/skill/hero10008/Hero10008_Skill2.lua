--- @class Hero10008_Skill2 Mammusk
Hero10008_Skill2 = Class(Hero10008_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10008_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.statBuffType = 0

    --- @type number
    self.statBuffAmount = 0

    --- @type number
    self.powerGainValue = 0

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
function Hero10008_Skill2:CreateInstance(id, hero)
    return Hero10008_Skill2(id, hero)
end

--- @return void
function Hero10008_Skill2:Init()
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.powerGainValue = self.data.powerGainValue

    self.myHero.hp:BindingWithSkill_2(self)
    self.myHero.attackListener:BindingWithSkill_2(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10008_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --- check can heal
    if dodgeType ~= DodgeType.MISS then
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
            self.statChanger:SetAmount(totalPercent)
            self.statChangerEffect:Recalculate()
        end
        self:GainPower()
    end
end

function Hero10008_Skill2:GainPower()
    PowerUtils.GainPower(self.myHero, self.myHero, self.powerGainValue, true)
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero10008_Skill2:OnDead(initiator, reason)
    self.wasAdded = false
end

return Hero10008_Skill2