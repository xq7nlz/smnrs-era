--- @class Summoner4_Skill3_2 : BaseSkill Assassin
Summoner4_Skill3_2 = Class(Summoner4_Skill3_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill3_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type TargetPositionType
    self.bondTargetPosition = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill3_2:CreateInstance(id, hero)
    return Summoner4_Skill3_2(id, hero)
end

--- @return void
function Summoner4_Skill3_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    if self.targetSelector.targetPositionType == TargetPositionType.PREFER_HERO_CLASS then
        self.targetSelector:SetAffectedClass(self.data.targetClass)
    end

    self.bondTargetPosition = self.data.bondTargetPosition
    self.bondTargetNumber = self.data.bondTargetNumber

    self.bondShareDamage = self.data.bondShareDamage

    self.bondSkillHelper = BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(true, self.data.bondDuration)

    self.myHero.battleListener:BindingWithSkill3_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner4_Skill3_2:OnStartBattleRound(round)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local initiator = targetList:Get(i)

        local bondTargetSelector = TargetSelectorBuilder.Create(initiator,
                self.bondTargetPosition, TargetTeamType.ALLY, self.bondTargetNumber)
        bondTargetSelector:SetIncludeSelf(false)

        local bond = Summoner4_Bond(initiator)
        bond:SetShareDamagePercent(self.bondShareDamage)

        local bondTargetList = bondTargetSelector:SelectTarget(self.myHero.battle)
        bondTargetList:Insert(initiator, 1)

        self.bondSkillHelper:UseBondSkill(bondTargetList, bond)
        i = i + 1
    end
end

return Summoner4_Skill3_2