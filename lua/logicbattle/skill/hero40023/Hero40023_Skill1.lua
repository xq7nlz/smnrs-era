--- @class Hero40023_Skill1 HoundMaster
Hero40023_Skill1 = Class(Hero40023_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40023_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.dotChance = 0

    --- @type EffectType
    self.dotType = 0

    --- @type number
    self.dotDuration = 0

    --- @type number
    self.dotAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40023_Skill1:CreateInstance(id, hero)
    return Hero40023_Skill1(id, hero)
end

--- @return void
function Hero40023_Skill1:Init()
    self.dotChance = self.data.dotChance
    self.dotType = self.data.dotType
    self.dotDuration = self.data.dotDuration
    self.dotAmount = self.data.dotAmount

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40023_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero40023_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.dotChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.dotType, self.dotDuration, self.dotAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero40023_Skill1