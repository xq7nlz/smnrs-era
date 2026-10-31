--- @class Summoner2_Skill4_2 : BaseSkill Warrior
Summoner2_Skill4_2 = Class(Summoner2_Skill4_2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill4_2:CreateInstance(id, hero)
    return Summoner2_Skill4_2(id, hero)
end

--- @return void
function Summoner2_Skill4_2:Init()
    self.tankerTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.tankerTargetPosition,
            TargetTeamType.ALLY, self.data.tankerTargetNumber)

    self.bondSkillHelper = Summoner2_Skill4_2_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(true, self.data.bondDuration)

    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner2_Skill4_2:OnStartBattleRound(round)
    if self.data.roundTriggerList:IsContainValue(round.round) then
        self:ExecuteBond()
    end
end

--- @return void
function Summoner2_Skill4_2:ExecuteBond()
    local tankerList = self.tankerTargetSelector:SelectTarget(self.myHero.battle)

    if tankerList:Count() >= 1 then
        local tanker = tankerList:Get(1)
        self.bondSkillHelper:SetTanker(tanker)

        local bond = Summoner2_Bond(self.myHero)
        bond:SetInfo(tanker, self.data.damageSharePercent)

        local otherTargetSelector = TargetSelectorBuilder.Create(tanker, self.data.otherTargetPosition,
                TargetTeamType.ALLY, self.data.otherTargetNumber)
        otherTargetSelector:SetIncludeSelf(false)
        local targetList = otherTargetSelector:SelectTarget(tanker.battle)

        self.bondSkillHelper:UseBondSkill(targetList, bond)
    end
end

return Summoner2_Skill4_2