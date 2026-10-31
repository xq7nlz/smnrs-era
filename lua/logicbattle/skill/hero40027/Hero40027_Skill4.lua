--- @class Hero40027_Skill4 : BaseSkill Airyuu
Hero40027_Skill4 = Class(Hero40027_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List(number)
    self.transformRounds = List()

    --- @type Dictionary(number, boolean)
    self.triggerRounds = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill4:CreateInstance(id, hero)
    return Hero40027_Skill4(id, hero)
end

--- @return void
function Hero40027_Skill4:Init()
    self.myHero.hp:BindingWithSkill_4(self)
    self.myHero.skillController:BindingWithSkill_4(self)
end

--- @return void
--- @param isDragonForm boolean
function Hero40027_Skill4:OnTransform(isDragonForm)
    self.myHero.effectController:DispelDebuff()

    local triggerRound = self.myHero.battle.numberRound
    if isDragonForm == false then
        triggerRound = triggerRound + 1
    end

    self.transformRounds:Add(triggerRound)
end

--- @return void
--- @param damage number
function Hero40027_Skill4:OnTakeDamage(damage)
    local round = self.myHero.battle.numberRound
    if self.transformRounds:IsContainValue(round) == true
            and self.triggerRounds:IsContainKey(round) == false then

        local currentHpValue = self.myHero.hp:GetValue()
        if currentHpValue <= damage then
            self.triggerRounds:Add(round, false)
            return currentHpValue - self.data.triggerHp
        end
    end

    return damage
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40027_Skill4:OnAfterTakeDamage(initiator, reason, damage)
    local round = self.myHero.battle.numberRound
    if self.transformRounds:IsContainValue(round) == true
            and self.triggerRounds:IsContainKey(round) == true then

        if self.triggerRounds:Get(round) == false then
            self.triggerRounds:Add(round, true)
            self:RegenHp()
        end
    end
end

--- @return void
function Hero40027_Skill4:RegenHp()
    self.myHero.hp:SetStatPercent(self.data.newHpPercent)
    self.myHero.hp:UpdateStatByPercent(self.data.newHpPercent)

    local healAmount = self.data.newHpPercent * self.myHero.hp:GetMax()
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.AIRYUU_HEAL_SKILL)
end

return Hero40027_Skill4