--- @class Hero40005_Skill4 Yang
Hero40005_Skill4 = Class(Hero40005_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberBlockDamage = 0

    --- @type number
    self.blockLimit = nil

    --- @type number
    self.blockRate = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill4:CreateInstance(id, hero)
    return Hero40005_Skill4(id, hero)
end

--- @return void
function Hero40005_Skill4:Init()
    self.blockLimit = self.data.blockLimit
    self.blockRate = self.data.blockRate

    self.myHero.hp:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40005_Skill4:TakeDamage(initiator, reason, damage)
    if self.numberBlockDamage < self.blockLimit then
        self.numberBlockDamage = self.numberBlockDamage + 1

        damage = damage - damage * self.blockRate
        damage = MathUtils.Clamp(damage, 0, damage)

        local result = MagicShieldResult(self.myHero, initiator, reason, damage)
        ActionLogUtils.AddLog(self.myHero.battle, result)
    end

    return damage
end

return Hero40005_Skill4