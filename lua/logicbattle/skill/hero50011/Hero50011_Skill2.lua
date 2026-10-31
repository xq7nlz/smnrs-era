--- @class Hero50011_Skill2 Ignatius
Hero50011_Skill2 = Class(Hero50011_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.buffStat = nil

    --- @type number
    self.buffAmount = nil

    --- @type number
    self.maxStack = nil

    --- @type List<BaseEffect>
    self.buffEffects = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill2:CreateInstance(id, hero)
    return Hero50011_Skill2(id, hero)
end

--- @return void
function Hero50011_Skill2:Init()
    self.buffStat = self.data.buffStat
    self.buffAmount = self.data.buffAmount

    self.maxStack = self.data.maxStack

    self.myHero.effectController:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param effect BaseEffect
function Hero50011_Skill2:OnEffectAdded(effect)
    if self.myHero:IsDead() == false and effect.isBuff == false then
        if self.myHero.battle.battlePhase ~= BattlePhase.PREPARE_BATTLE then
            self:TriggerSkill()
        end
    end
end

--- @return void
function Hero50011_Skill2:TriggerSkill()
    if self:CalculateStackedEffect() < self.maxStack then
        self.statChanger = StatChanger(true)
        self.statChanger:SetInfo(self.buffStat, StatChangerCalculationType.PERCENT_ADD, self.buffAmount)

        self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
        self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
        self.statChangerEffect:AddStatChanger(self.statChanger)

        self.myHero.effectController:AddEffect(self.statChangerEffect)
        self.buffEffects:Add(self.statChangerEffect)
    end
end

--- @return void
function Hero50011_Skill2:CalculateStackedEffect()
    local result = 0

    local removedEffects = List()
    for i = 1, self.buffEffects:Count() do
        local effect = self.buffEffects:Get(i)

        if self.myHero.effectController:IsContainEffect(effect) then
            result = result + 1
        else
            removedEffects:Add(effect)
        end
    end

    for i = 1, removedEffects:Count() do
        local effect = removedEffects:Get(i)

        self.myHero.effectController:ForceRemove(effect)
    end

    return result
end

return Hero50011_Skill2