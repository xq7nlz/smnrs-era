--- @class Hero60002_Skill1 Bloodseeker
Hero60002_Skill1 = Class(Hero60002_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StealStatAndReturnSkillHelper
    self.stealAndReturnHelper = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.statStealAmount = nil
    --- @type number
    self.stealDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60002_Skill1:CreateInstance(id, hero)
    return Hero60002_Skill1(id, hero)
end

--- @return void
function Hero60002_Skill1:Init()
    self.statTypeToSteal = self.data.statTypeToSteal
    self.statStealAmount = self.data.statStealAmount
    self.stealDuration = self.data.stealDuration

    self.stealAndReturnHelper = StealStatAndReturnSkillHelper(self)
    self.stealAndReturnHelper:AddSteal(self.statTypeToSteal, self.statStealAmount)
    self.stealAndReturnHelper:SetDuration(self.stealDuration)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)

    self.myHero.battleListener:BindingWithSkill_1(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60002_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero60002_Skill1:InflictEffect(target)
    local targetList = List()
    targetList:Add(self.myHero)
    self.stealAndReturnHelper:StealStat(target, targetList)
end

--- @return void
--- @param eventData table
function Hero60002_Skill1:OnHeroDead(eventData)
    self.stealAndReturnHelper:OnDead(eventData)
end

--- @return void
function Hero60002_Skill1:OnEndBattleRound()
    self.stealAndReturnHelper:OnEndBattleRound()
end

return Hero60002_Skill1