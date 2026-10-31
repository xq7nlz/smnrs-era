--- @class Hero60014_Skill1 ShiShil
Hero60014_Skill1 = Class(Hero60014_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60014_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BondSkillHelper
    self.bondSkillHelper = nil

    --- @type List<BaseHero>
    self.enemyList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60014_Skill1:CreateInstance(id, hero)
    return Hero60014_Skill1(id, hero)
end

--- @return void
function Hero60014_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.bondSkillHelper = BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(false, self.data.bondDuration)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.myHero.battleListener:BindingWithSkill_1(self)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60014_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end
---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param target BaseHero
function Hero60014_Skill1:InflictEffect(target)
    self.enemyList:Add(target)
end

--- @return void
--- @param turn BattleTurn
function Hero60014_Skill1:OnStartBattleTurn(turn)
    self.enemyList:Clear()
end

--- @return void
--- @param turn BattleTurn
function Hero60014_Skill1:OnEndBattleTurn(turn)
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
        local bond = Hero60014_Skill1_Bond(self.myHero)
        self.bondSkillHelper:UseBondSkill(targetList, bond)
    end
    self.enemyList:Clear()
end

return Hero60014_Skill1