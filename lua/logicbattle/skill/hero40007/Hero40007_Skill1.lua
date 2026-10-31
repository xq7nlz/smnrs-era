--- @class Hero40007_Skill1 Noroth
Hero40007_Skill1 = Class(Hero40007_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40007_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type number

    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil
    --- @type number
    self.statBuffDuration = 0
    --- @type StatChangerCalculationType
    self.statCalculationType = nil
    --- @type StatType
    self.statBuffType = 0
    --- @type number
    self.statBuffAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40007_Skill1:CreateInstance(id, hero)
    return Hero40007_Skill1(id, hero)
end

--- @return void
function Hero40007_Skill1:Init()
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)

    self.statBuffDuration = self.data.statBuffDuration
    self.statCalculationType = self.data.statCalculationType
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40007_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    self:BuffAlly()

    return results, isEndTurn
end

--- @return void
function Hero40007_Skill1:BuffAlly()
    local targetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.statBuffType, self.statCalculationType, self.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChanger)
        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40007_Skill1