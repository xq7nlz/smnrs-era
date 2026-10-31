--- @class Summoner4_Skill3_3 : BaseSkill Assassin
Summoner4_Skill3_3 = Class(Summoner4_Skill3_3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill3_3:CreateInstance(id, hero)
    return Summoner4_Skill3_3(id, hero)
end

--- @return void
function Summoner4_Skill3_3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local damage = self.data.damage

    local targetList = targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local debuffEffect = ExtraDotWhenCC(self.myHero, target, damage)
        debuffEffect:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

        target.effectController:AddEffect(debuffEffect)
        i = i + 1
    end
end

return Summoner4_Skill3_3