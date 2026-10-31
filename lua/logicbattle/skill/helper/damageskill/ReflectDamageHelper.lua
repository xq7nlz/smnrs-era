--- @class ReflectDamageHelper : BaseSkillHelper
ReflectDamageHelper = Class(ReflectDamageHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function ReflectDamageHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type nil
    self.reflectChance = nil

    --- @type number
    self.reflectDamage = nil
end

--- @return void
--- @param reflectChance number
--- @param reflectDamage number
function ReflectDamageHelper:SetInfo(reflectChance, reflectDamage)
    self.reflectChance = reflectChance
    self.reflectDamage = reflectDamage
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function ReflectDamageHelper:ReflectDamage(target, totalDamage)
    --- check can inflict effect
    if target:IsSummoner() == false and totalDamage > 0 then
        if self.myHero.randomHelper:RandomRate(self.reflectChance) then
            local result = ReflectDamageResult(self.myHero, target)
            ActionLogUtils.AddLog(self.myHero.battle, result)

            local damage = totalDamage * self.reflectDamage
            damage = target.hp:TakeDamage(self.myHero, TakeDamageReason.REFLECT_DAMAGE, damage)

            result:SetDamage(damage)
            result:RefreshHeroStatus()
        end
    end
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function ReflectDamageHelper:ReflectDamageFromOther(initiator, target, totalDamage)
    --- check can inflict effect
    if target:IsSummoner() == false and totalDamage > 0 then
        if initiator.randomHelper:RandomRate(self.reflectChance) then
            local result = ReflectDamageResult(initiator, target)
            ActionLogUtils.AddLog(self.myHero.battle, result)

            local damage = totalDamage * self.reflectDamage
            damage = target.hp:TakeDamage(initiator, TakeDamageReason.REFLECT_DAMAGE, damage)

            result:SetDamage(damage)
            result:RefreshHeroStatus()
        end
    end
end