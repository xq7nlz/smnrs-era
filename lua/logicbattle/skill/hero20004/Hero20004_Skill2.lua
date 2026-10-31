--- @class Hero20004_Skill2 Defronowe
Hero20004_Skill2 = Class(Hero20004_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20004_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type @number
    self.stealStatType = 0

    --- @type @number
    self.stealStatAmount = 0

    --- @type StealStatSkillHelper
    self.stealStatSkillHelper = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20004_Skill2:CreateInstance(id, hero)
    return Hero20004_Skill2(id, hero)
end

--- @return void
function Hero20004_Skill2:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.stealStatType = self.data.stealStatType
    self.stealStatAmount = self.data.stealStatAmount

    self.myHero.attackListener:BindingWithSkill_2(self)

    self.stealStatSkillHelper = StealStatSkillHelper(self)
    self.stealStatSkillHelper:SetInfo(self.stealStatType)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20004_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local statToSteal = enemyDefender:GetStat(self.stealStatType)
        local amount = statToSteal:GetMax() * self.stealStatAmount

        if enemyDefender:IsBoss() == false then
            self.stealStatSkillHelper:StealStat(enemyDefender, amount)
            self.stealStatSkillHelper:AddStolenStat(self.myHero, amount)
        end
    end
end

return Hero20004_Skill2