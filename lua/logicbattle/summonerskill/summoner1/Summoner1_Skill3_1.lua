--- @class Summoner1_Skill3_1 : BaseSkill Mage
Summoner1_Skill3_1 = Class(Summoner1_Skill3_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_1:CreateInstance(id, hero)
    return Summoner1_Skill3_1(id, hero)
end

--- @return void
function Summoner1_Skill3_1:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = targetSelector:SelectTarget(self.myHero.battle)

    if self.myHero.randomHelper:RandomRate(self.data.blessingChance) then
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            local effect = Summoner_3_BlessMarkEffect(self.myHero, target)
            effect:SetDuration(self.data.blessingDuration)
            target.effectController:AddEffect(effect)
            i = i + 1
        end
    end
end

return Summoner1_Skill3_1