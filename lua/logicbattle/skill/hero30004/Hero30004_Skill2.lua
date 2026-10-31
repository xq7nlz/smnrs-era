--- @class Hero30004_Skill2 Stheno
Hero30004_Skill2 = Class(Hero30004_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30004_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectAmount = nil
    --- @type number
    self.effectDuration = nil

    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffDuration = nil
    --- @type number
    self.statDebuffAmount = nil

    --- @type StatChangerCalculationType
    self.statDebuffCalculationType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30004_Skill2:CreateInstance(id, hero)
    return Hero30004_Skill2(id, hero)
end

--- @return void
function Hero30004_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration

    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffCalculationType = self.data.statDebuffCalculationType
    self.statDebuffDuration = self.data.statDebuffDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30004_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:InflictEffect(enemyDefender, totalDamage)
        self:DebuffStat(enemyDefender, totalDamage)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero30004_Skill2:InflictEffect(enemyDefender, totalDamage)
    local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType,
            self.effectDuration, self.effectAmount)
    enemyDefender.effectController:AddEffect(dotEffect)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero30004_Skill2:DebuffStat(enemyDefender, totalDamage)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

    local effect = StatChangerEffect(self.myHero, enemyDefender, false)
    effect:SetDuration(self.statDebuffDuration)
    effect:AddStatChanger(statChanger)

    enemyDefender.effectController:AddEffect(effect)
end

return Hero30004_Skill2