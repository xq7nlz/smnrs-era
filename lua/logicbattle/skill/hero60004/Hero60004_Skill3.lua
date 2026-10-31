--- @class Hero60004_Skill3 Karos
Hero60004_Skill3 = Class(Hero60004_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.reduceDamageDarkMark = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill3:CreateInstance(id, hero)
    return Hero60004_Skill3(id, hero)
end

--- @return void
function Hero60004_Skill3:Init()
    self.reduceDamageDarkMark = self.data.reduceDamageDarkMark

    self.myHero.hp:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return number damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param totalDamage number
function Hero60004_Skill3:GetReduceDamage(initiator, reason, totalDamage)
    if reason ~= TakeDamageReason.BOND_DAMAGE and
            reason ~= TakeDamageReason.BOND_DAMAGE_DOT and
            reason ~= TakeDamageReason.SPLASH_DAMAGE and
            reason ~= TakeDamageReason.BOUNCING_DAMAGE then
        if initiator.effectController:IsContainEffectType(EffectType.DARK_MARK) == true then
            return totalDamage * (1 - self.reduceDamageDarkMark)
        end
    end

    return totalDamage
end

return Hero60004_Skill3