--- @class Summoner3_Skill1_3 : BaseSkill Priest
Summoner3_Skill1_3 = Class(Summoner3_Skill1_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type BaseTargetSelector
    self.bondTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type Summoner3_Skill1_3_BondSkillHelper
    self.bondSkillHelper = nil

    --- @type List<BaseHero>
    self.enemyList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_3:CreateInstance(id, hero)
    return Summoner3_Skill1_3(id, hero)
end

--- @return void
function Summoner3_Skill1_3:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.bondTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.bondTargetPosition,
            TargetTeamType.ALLY, self.data.bondTargetNumber)

    self.bondSkillHelper = Summoner3_Skill1_3_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(false, self.data.bondDuration)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner3_Skill1_3:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    self:ExecuteBond()

    local isEndTurn = true

    return results, isEndTurn
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Summoner3_Skill1_3:ExecuteBond()
    local targetList = self.bondTargetSelector:SelectTarget(self.myHero.battle)

    if targetList:Count() > 1 then
        local bond = Summoner3_Bond(self.myHero)
        self.bondSkillHelper:UseBondSkill(targetList, bond)
    end
    self.enemyList:Clear()
end

return Summoner3_Skill1_3