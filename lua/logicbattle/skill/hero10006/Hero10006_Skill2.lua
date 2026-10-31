--- @class Hero10006_Skill2 Aqualord
Hero10006_Skill2 = Class(Hero10006_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10006_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type BondSkillHelper
    self.bondSkillHelper = nil

    --- @type number
    self.damageSharePercent = nil

    --- @type number
    self.bondDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10006_Skill2:CreateInstance(id, hero)
    return Hero10006_Skill2(id, hero)
end

--- @return void
function Hero10006_Skill2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)
    self.targetSelector:SetIncludeSelf(false)

    self.damageSharePercent = self.data.damageSharePercent

    self.bondSkillHelper = Hero10006_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(true, self.data.bondDuration)

    self.myHero.battleListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero10006_Skill2:OnStartBattleRound(round)
    if self.myHero:IsDead() == false then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        targetList:Insert(self.myHero, 1)

        local bond = Hero10006_Skill2_Bond(self.myHero)
        bond:SetShareDamagePercent(self.damageSharePercent)

        self.bondSkillHelper:UseBondSkill(targetList, bond)
    end
end

return Hero10006_Skill2