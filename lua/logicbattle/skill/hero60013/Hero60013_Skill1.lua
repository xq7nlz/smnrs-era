--- @class Hero60013_Skill1 DarkKnight
Hero60013_Skill1 = Class(Hero60013_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type StealStatSkillHelper
    self.stealStatSkillHelper = nil

    --- @type StatType
    self.stealStatType = nil

    --- @type number
    self.stealStatAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill1:CreateInstance(id, hero)
    return Hero60013_Skill1(id, hero)
end

--- @return void
function Hero60013_Skill1:Init()
    self.stealStatType = self.data.stealStatType
    self.stealStatAmount = self.data.stealStatAmount

    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.stealStatSkillHelper = StealStatSkillHelper(self)
    self.stealStatSkillHelper:SetInfo(self.stealStatType)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60013_Skill1:UseActiveSkill()
    local enemyTargetList = self.enemyTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end
---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param target BaseHero
function Hero60013_Skill1:InflictEffect(target)
    local statToSteal = target:GetStat(self.stealStatType)
    local amount = statToSteal:GetMax() * self.stealStatAmount

    if target:IsBoss() == false then
        self.stealStatSkillHelper:StealStat(target, amount)
        self.stealStatSkillHelper:AddStolenStat(self.myHero, amount)
    end
end

return Hero60013_Skill1