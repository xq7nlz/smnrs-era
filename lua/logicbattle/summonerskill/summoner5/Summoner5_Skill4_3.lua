--- @class Summoner5_Skill4_3 : BaseSkill Ranger
Summoner5_Skill4_3 = Class(Summoner5_Skill4_3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill4_3:CreateInstance(id, hero)
    return Summoner5_Skill4_3(id, hero)
end

--- @return void
function Summoner5_Skill4_3:Init()
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        ---@type BonusDamageExtraTurnAndCC
        local buffEffect = BonusDamageExtraTurnAndCC(self.myHero, target)
        buffEffect:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
        buffEffect:SetInfo(self.data.bonusDamageExtraTurn, self.data.numberExtraTurnAffect)
        buffEffect:SetCCEffectInfo(self.effectType, self.effectDuration)

        target.effectController:AddEffect(buffEffect)
        i = i + 1
    end
end

return Summoner5_Skill4_3