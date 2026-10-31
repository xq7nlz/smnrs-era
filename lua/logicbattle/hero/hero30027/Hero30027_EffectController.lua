--- @class Hero30027_EffectController
Hero30027_EffectController = Class(Hero30027_EffectController, EffectController)

--- @return void
function Hero30027_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30027_EffectController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Manage effects ----------------------------------------
--- @return boolean
--- @param effect BaseEffect
--- @param isCanShare boolean
function Hero30027_EffectController:AddEffect(effect, isCanShare)
    if self.myHero:IsDead() then
        return false
    end

    if self:CanAdd(effect) == false then
        ActionLogUtils.CreateResistEffectResult(effect.initiator, self.myHero, effect.type)
        return false
    end

    ActionLogUtils.CreateEffectChangeResult(self.myHero, effect, EffectChangeType.ADD)
    effect:OnEffectAdd(self.myHero)

    if self:CanAdd(effect) == false then
        ActionLogUtils.CreateResistEffectResult(effect.initiator, self.myHero, effect.type)
        return false
    end

    if effect:GetPersistentType() == EffectPersistentType.PERMANENT then
        self.permanentEffectList:Add(effect)
    else
        self.effectList:Add(effect)
        self.myHero.battle.statisticsController:OnEffectAdd(effect)

        if effect:IsCCEffect() then
            self.effectListener:OnTakeCCEffect(effect)
        end

        if isCanShare == nil or isCanShare == true then
            self.myHero.battle.bondManager:OnTakeEffect(effect)
        end
    end

    return true
end

--- @return boolean
--- @param effect BaseEffect
function Hero30027_EffectController:CanAdd(effect)
    local baseResult = EffectController.CanAdd(self, effect)

    if self.skill_4 ~= nil then
        if self.skill_4:CanBeTargeted() == false then
            return false
        end
    end

    return baseResult
end

--- @return void dispel all buffs
--- only remove non-persistent debuff
function Hero30027_EffectController:DispelAllDebuff()
    local effectsToRemove = List()
    local i = 1
    while i <= self.effectList:Count() do
        local effect = self.effectList:Get(i)
        if effect.isBuff == false then
            effectsToRemove:Add(effect)
        end
        i = i + 1
    end
    self:_RemoveEffects(effectsToRemove)
end