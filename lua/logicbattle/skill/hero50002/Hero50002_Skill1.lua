--- @class Hero50002_Skill1 HolyKnight
Hero50002_Skill1 = Class(Hero50002_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.statDebuffChance = 0

    --- @type number
    self.statDebuffDuration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill1:CreateInstance(id, hero)
    return Hero50002_Skill1(id, hero)
end

--- @return void
function Hero50002_Skill1:Init()
    self.statDebuffChance = self.data.statDebuffChance
    self.statDebuffDuration = self.data.statDebuffDuration

    self.effect_type = self.data.effect_type
    self.effect_chance = self.data.effect_chance
    self.effect_duration = self.data.effect_duration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50002_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50002_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
        self.statChangerEffect = StatChangerEffect(self.myHero, target, false)
        self.statChangerEffect:SetDuration(self.statDebuffDuration)

        local i = 1
        while i <= self.data.debuffs:Count() do
            local statChanger = StatChanger(false)
            local debuff = self.data.debuffs:Get(i)
            statChanger:SetInfo(debuff.statType, debuff.calculationType, debuff.amount)

            self.statChangerEffect:AddStatChanger(statChanger)
            i = i + 1
        end

        target.effectController:AddEffect(self.statChangerEffect)
    end

    if self.myHero.randomHelper:RandomRate(self.effect_chance) then
        local holyMark = HolyMark(self.myHero, target)
        holyMark:SetDuration(self.effect_duration)
        target.effectController:AddEffect(holyMark)
    end
end

return Hero50002_Skill1