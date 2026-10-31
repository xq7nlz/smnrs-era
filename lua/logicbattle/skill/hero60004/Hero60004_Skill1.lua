--- @class Hero60004_Skill1 Karos
Hero60004_Skill1 = Class(Hero60004_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill1:CreateInstance(id, hero)
    return Hero60004_Skill1(id, hero)
end

--- @return void
function Hero60004_Skill1:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60004_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    self:FocusTarget(targetList)

    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
--- @param targetList List<BaseHero>
function Hero60004_Skill1:FocusTarget(targetList)
    local i = 1
    while i <= targetList:Count() do
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local targetHero = targetList:Get(i)
            local tauntMark = TauntMark(self.myHero, targetHero, self.effectDuration)
            tauntMark:SetDuration(self.effectDuration)

            if targetHero.effectController:AddEffect(tauntMark) then
                tauntMark:InitToOtherAndMyTeam()
            end
        end
        i = i + 1
    end
end

return Hero60004_Skill1