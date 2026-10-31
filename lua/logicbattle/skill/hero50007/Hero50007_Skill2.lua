--- @class Hero50007_Skill2 Celestia
Hero50007_Skill2 = Class(Hero50007_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StealStatAndReturnSkillHelper
    self.stealAndReturnHelper = nil

    --- @type BaseTargetSelector
    self.stealBuffTargetSelector = nil

    --- @type number
    self.stealChance = 0

    --- @type number
    self.stealStatType_1 = 0
    --- @type number
    self.stealStatAmount_1 = 0

    --- @type number
    self.stealStatType_2 = 0
    --- @type number
    self.stealStatAmount_2 = 0

    --- @type number
    self.stealDuration = 0

    --- @type List<BaseHero>
    self.targetList = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill2:CreateInstance(id, hero)
    return Hero50007_Skill2(id, hero)
end

--- @return void
function Hero50007_Skill2:Init()
    self.stealChance = self.data.stealChance

    self.stealBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.stealAndReturnHelper = StealStatAndReturnSkillHelper(self)
    self.stealAndReturnHelper:SetDuration(self.data.stealDuration)
    self.stealAndReturnHelper:AddSteal(self.data.stealStatType_1, self.data.stealStatAmount_1)
    self.stealAndReturnHelper:AddSteal(self.data.stealStatType_2, self.data.stealStatAmount_2)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.battleListener:BindingWithSkill_2(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50007_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.stealChance) then
        self:InflictEffect(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero50007_Skill2:InflictEffect(target)
    if self.targetList == nil then
        self.targetList = self.stealBuffTargetSelector:SelectTarget(self.myHero.battle)
    end

    self.stealAndReturnHelper:StealStat(target, self.targetList)
end

--- @return void
--- @param eventData table
function Hero50007_Skill2:OnHeroDead(eventData)
    self.stealAndReturnHelper:OnDead(eventData)
end

--- @return void
function Hero50007_Skill2:OnEndBattleRound()
    self.stealAndReturnHelper:OnEndBattleRound()
    self.targetList = nil
end

return Hero50007_Skill2