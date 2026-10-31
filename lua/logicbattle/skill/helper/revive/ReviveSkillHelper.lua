--- @class ReviveSkillHelper : BaseSkillHelper
ReviveSkillHelper = Class(ReviveSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function ReviveSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type number
    self.reviveChance = 1
end

--- @return void
--- @param reviveChance number
function ReviveSkillHelper:SetReviveChance(reviveChance)
    self.reviveChance = reviveChance
end

---------------------------------------- Use skill ----------------------------------------
--- @return boolean
--- @param target BaseHero
function ReviveSkillHelper:UseReviveSkill(target)
    if self.myHero.randomHelper:RandomRate(self.reviveChance) == true then
        if target.hp:Revive(self.myHero) == true then
            local result = ReviveActionResult(self.myHero, target)
            ActionLogUtils.AddLog(self.myHero.battle, result)

            return true, result
        end
    end
    return false, nil
end

--- @return boolean
--- @param target BaseHero
function ReviveSkillHelper:IsCanRevive(target)
    if self.myHero:IsDead() == true then
        --print("MyHero is dead")
        return false
    end

    if target:IsDead() == false then
        --print("Target is alive")
        return false
    end

    if target.hp:CanRevive() == false then
        --print("Can't revive")
        return false
    end

    if self.myHero:IsAlly(target) == false then
        --print("Not same team")
        return false
    end

    --print("Can revive")
    return true
end