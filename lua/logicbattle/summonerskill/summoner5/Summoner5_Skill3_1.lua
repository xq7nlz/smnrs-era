--- @class Summoner5_Skill3_1 : BaseSkill Ranger
Summoner5_Skill3_1 = Class(Summoner5_Skill3_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill3_1:CreateInstance(id, hero)
    return Summoner5_Skill3_1(id, hero)
end

--- @return void
function Summoner5_Skill3_1:Init()
    local bonusDamageReceive = self.data.bonusDamageReceive

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        ---@type ExtraDamageTakenWhenCC
        local effect = ExtraDamageTakenWhenCC(self.myHero, target)
        effect:SetPersistentType(EffectPersistentType.PERMANENT)
        effect:SetDamageReceiveDebuffAmount(bonusDamageReceive)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Summoner5_Skill3_1