--- @class Hero10007_Skill2 Osse
Hero10007_Skill2 = Class(Hero10007_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10007_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BondSkillHelper
    self.bondSkillHelper = nil

    --- @type number
    self.damagePercent = nil

    --- @type number
    self.bondDamagePercent = nil

    --- @type number
    self.bondCcChance = nil

    --- @type List<BaseHero>
    self.enemyList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10007_Skill2:CreateInstance(id, hero)
    return Hero10007_Skill2(id, hero)
end

--- @return void
function Hero10007_Skill2:Init()
    self.damagePercent = self.data.damagePercent

    self.bondDamagePercent = self.data.bondDamagePercent
    self.bondCcChance = self.data.bondCcChance

    self.bondSkillHelper = Hero10007_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(false, self.data.bondDuration)

    local skill = self.myHero.skillController.passiveSkills:Get(3)
    self.bondSkillHelper:BindingWithSkill_3(skill)

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.myHero.battleListener:BindingWithSkill_2(self)
    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10007_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self.enemyList:Add(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero10007_Skill2:CalculateAttackResult(target)
    return self.damagePercent
end

--- @return void
--- @param turn BattleTurn
function Hero10007_Skill2:OnStartBattleTurn(turn)
    self.enemyList:Clear()
end

--- @return void
--- @param turn BattleTurn
function Hero10007_Skill2:OnEndBattleTurn(turn)
    local targetList = List()
    local i = 1
    while i <= self.enemyList:Count() do
        local hero = self.enemyList:Get(i)
        if hero:IsDead() == false then
            targetList:Add(hero)
        end
        i = i + 1
    end

    if targetList:Count() > 1 then
        local bond = Hero10007_Skill2_Bond(self.myHero)
        bond:SetInfo(self.bondDamagePercent, self.bondCcChance)
        self.bondSkillHelper:UseBondSkill(targetList, bond)
    end
    self.enemyList:Clear()
end

return Hero10007_Skill2