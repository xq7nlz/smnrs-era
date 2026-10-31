--- @class Summoner2_Skill1_2 : BaseSkill Warrior
Summoner2_Skill1_2 = Class(Summoner2_Skill1_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill1_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.buffTargetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill1_2:CreateInstance(id, hero)
    return Summoner2_Skill1_2(id, hero)
end

--- @return void
function Summoner2_Skill1_2:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.buffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.buffTargetPosition,
            TargetTeamType.ALLY, self.data.buffTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.statBuffType = self.data.statBuffType
    self.statBuffChance = self.data.statBuffChance
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffCalculation = self.data.statBuffCalculation
    self.statBuffAmount = self.data.statBuffAmount
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner2_Skill1_2:UseActiveSkill()
    local targetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    self:BuffStat()

    return results, isEndTurn
end

function Summoner2_Skill1_2:BuffStat()
    local targetList = self.buffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.statBuffType, self.statBuffCalculation, self.statBuffAmount)
        local effect = StatChangerEffect(self.myHero, target, true)

        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChanger)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Summoner2_Skill1_2