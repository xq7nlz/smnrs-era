--- @class Hero50006_DamageSkillHelper : DamageSkillHelper
Hero50006_DamageSkillHelper = Class(Hero50006_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero50006_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50006_DamageSkillHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return List<UseDamageSkillResult>
--- @param targetList List<BaseHero>
function Hero50006_DamageSkillHelper:UseDamageSkill(targetList)
    local results = List()

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target:IsDead() == false then
            local result = self:OnUseDamageSkill(target, self.damageMultiplier)

            if self.skill_2 ~= nil then
                self.skill_2:OnDealDamageToEnemy(target, result.damage)
            end

            results:Add(result)
        end
        i = i + 1
    end

    if self.skill_2 ~= nil then
        self.skill_2:StartBouncing()
    end

    i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        self:TriggerUseSkillListener(result)
        self:TriggerCritListener(result)
        i = i + 1
    end

    return results
end