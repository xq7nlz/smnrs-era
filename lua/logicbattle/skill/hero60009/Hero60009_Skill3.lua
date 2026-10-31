--- @class Hero60009_Skill3 Khann
Hero60009_Skill3 = Class(Hero60009_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60009_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.markDuration = nil

    --- @type number
    self.damageReceiveDebuffAmount = nil

    --- @type number
    self.damageReceiveDebuffDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60009_Skill3:CreateInstance(id, hero)
    return Hero60009_Skill3(id, hero)
end

--- @return void
function Hero60009_Skill3:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.markDuration = self.data.markDuration

    self.damageReceiveDebuffAmount = self.data.damageReceiveDebuffAmount
    self.damageReceiveDebuffDuration = self.data.damageReceiveDebuffDuration

    self.myHero.attackController:SetSelector(self.targetSelector)

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60009_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:InflictDiseaseMark(enemyDefender)
        self:InflictDamageReceiveByDiseaseMark(enemyDefender)
    end
end

--- @return void
--- @param target BaseHero
function Hero60009_Skill3:InflictDiseaseMark(target)
    if EffectUtils.CanAddEffect(target, EffectType.DISEASE_MARK, false) == false then
        return
    end

    local currentMarkList = target.effectController:GetEffectWithType(EffectType.DISEASE_MARK)
    if currentMarkList:Count() == 0 then
        local diseaseMark = DiseaseMark(self.myHero, target)
        diseaseMark:SetDuration(self.markDuration)
        target.effectController:AddEffect(diseaseMark)
    else
        local currentMark = currentMarkList:Get(1)
        if self.markDuration > currentMark.duration then
            currentMark:SetDuration(self.markDuration)
        end
    end
end

--- @return void
--- @param target BaseHero
function Hero60009_Skill3:InflictDamageReceiveByDiseaseMark(target)
    local damageReceiveDebuff = ExtraDamageTaken(self.myHero, target)
    damageReceiveDebuff:SetDuration(self.damageReceiveDebuffDuration)
    damageReceiveDebuff:SetDamageReceiveDebuffAmount(self.damageReceiveDebuffAmount)

    target.effectController:AddEffect(damageReceiveDebuff)
end

return Hero60009_Skill3