--- @class Hero50003_Skill3 LifeKeeper
Hero50003_Skill3 = Class(Hero50003_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type @number
    self.stealStatType = 0

    --- @type @number
    self.stealStatAmount = 0

    --- @type StealStatSkillHelper
    self.stealStatSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50003_Skill3:CreateInstance(id, hero)
    return Hero50003_Skill3(id, hero)
end

--- @return void
function Hero50003_Skill3:Init()
    self.stealStatType = self.data.stealStatType
    self.stealStatAmount = self.data.stealStatAmount

    self.myHero.attackListener:BindingWithSkill_3(self)

    self.stealStatSkillHelper = StealStatSkillHelper(self)
    self.stealStatSkillHelper:SetInfo(self.stealStatType)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50003_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local statToSteal = enemyDefender:GetStat(self.stealStatType)
        local amount = statToSteal:GetMax() * self.stealStatAmount

        if enemyDefender:IsBoss() == false then
            self.stealStatSkillHelper:StealStat(enemyDefender, amount)
            self.stealStatSkillHelper:AddStolenStat(self.myHero, amount)
        end
    end
end

return Hero50003_Skill3