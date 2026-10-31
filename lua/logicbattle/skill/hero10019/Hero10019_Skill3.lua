--- @class Hero10019_Skill3 Tidus
Hero10019_Skill3 = Class(Hero10019_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10019_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type StatType
    self.statDebuffType = nil

    ---@type number
    self.statDebuffChance = nil

    ---@type number
    self.statDebuffAmount = nil

    ---@type number
    self.statDebuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10019_Skill3:CreateInstance(id, hero)
    return Hero10019_Skill3(id, hero)
end

--- @return void
function Hero10019_Skill3:Init()
    self.statDebuffChance = self.data.statDebuffChance
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffAmount = self.data.statDebuffAmount

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10019_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
        self:InflictEffect(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero10019_Skill3:InflictEffect(target)
    local statChangerEffect = StatChangerEffect(self.myHero, target, false)
    statChangerEffect:SetDuration(self.statDebuffDuration)

    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

    statChangerEffect:AddStatChanger(statChanger)
    target.effectController:AddEffect(statChangerEffect)
end

return Hero10019_Skill3