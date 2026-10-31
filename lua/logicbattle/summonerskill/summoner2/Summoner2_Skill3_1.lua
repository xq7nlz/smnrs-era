--- @class Summoner2_Skill3_1 : BaseSkill Warrior
Summoner2_Skill3_1 = Class(Summoner2_Skill3_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill3_1:CreateInstance(id, hero)
    return Summoner2_Skill3_1(id, hero)
end

--- @return void
function Summoner2_Skill3_1:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local reduceDamageWhenCC = ReduceDamageTakenWhenCC(self.myHero, target)
        reduceDamageWhenCC:SetPersistentType(EffectPersistentType.PERMANENT)
        reduceDamageWhenCC:SetDamageReduceAmount(self.data.damageReduceWhenCC)

        target.effectController:AddEffect(reduceDamageWhenCC)
        i = i + 1
    end
end

return Summoner2_Skill3_1