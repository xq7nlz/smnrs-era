--- @class Hero60007_Skill2 Rannantos
Hero60007_Skill2 = Class(Hero60007_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60007_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60007_Skill2:CreateInstance(id, hero)
    return Hero60007_Skill2(id, hero)
end

--- @return void
function Hero60007_Skill2:Init()
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60007_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:InflictDiseaseMark(enemyDefender)
        self:InflictCurseMark(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero60007_Skill2:InflictDiseaseMark(target)
    if EffectUtils.CanAddEffect(target, EffectType.DISEASE_MARK, false) == false then
        return
    end

    local currentMarkList = target.effectController:GetEffectWithType(EffectType.DISEASE_MARK)
    if currentMarkList:Count() == 0 then
        local diseaseMark = DiseaseMark(self.myHero, target)
        diseaseMark:SetDuration(self.effectDuration)
        target.effectController:AddEffect(diseaseMark)
    else
        local currentMark = currentMarkList:Get(1)
        if self.effectDuration > currentMark.duration then
            currentMark:SetDuration(self.effectDuration)
        end
    end
end

--- @return void
--- @param target BaseHero
function Hero60007_Skill2:InflictCurseMark(target)
    EffectUtils.CreateCurseEffect(self.myHero, target, EffectType.CURSE_MARK, self.effectDuration)
end

return Hero60007_Skill2