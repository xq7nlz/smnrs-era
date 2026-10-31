--- @class Summoner1_Skill1_3 : BaseSkill Mage
Summoner1_Skill1_3 = Class(Summoner1_Skill1_3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill1_3:CreateInstance(id, hero)
    return Summoner1_Skill1_3(id, hero)
end

--- @return void
function Summoner1_Skill1_3:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)

    self.baseDamage = self.data.baseDamage
    self.bonusDamageEnemyDie = self.data.bonusDamageEnemyDie

    self.dispelChance = self.data.dispelChance
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner1_Skill1_3:UseActiveSkill()
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
    --- @type List<BaseHero>
    local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId):GetHeroList()
    local multiDamageEnemyDie = 0
    local i = 1
    while i <= enemyTeam:Count() do
        if enemyTeam:Get(i):IsDead() then
            multiDamageEnemyDie = multiDamageEnemyDie + 1
        end
        i = i + 1
    end

    self.damageSkillHelper:SetDamage(self.baseDamage + multiDamageEnemyDie * self.bonusDamageEnemyDie)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner1_Skill1_3:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.dispelChance) then
        target.effectController:DispelBuff()
    end
end

return Summoner1_Skill1_3