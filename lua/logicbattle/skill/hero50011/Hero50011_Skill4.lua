--- @class Hero50011_Skill4 Ignatius
Hero50011_Skill4 = Class(Hero50011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil

    --- @type StatType
    self.buffStat = nil

    --- @type number
    self.buffAmount = nil

    --- @type number
    self.maxStack = nil

    --- @type number
    self.buffDuration = nil

    --- @type List<BaseEffect>
    self.buffEffects = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill4:CreateInstance(id, hero)
    return Hero50011_Skill4(id, hero)
end

--- @return void
function Hero50011_Skill4:Init()
    self.triggerChance = self.data.triggerChance

    self.buffStat = self.data.buffStat
    self.buffAmount = self.data.buffAmount
    self.buffDuration = self.data.buffDuration

    self.maxStack = self.data.maxStack

    self.myHero:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Hero50011_Skill4:OnDoAction()
    if self.myHero:IsDead() == false then
        if self.myHero.battle.battlePhase ~= BattlePhase.PREPARE_BATTLE then
            if self.myHero.randomHelper:RandomRate(self.triggerChance) then
                self:TriggerSkill()
            end
        end
    end
end

--- @return void
function Hero50011_Skill4:TriggerSkill()
    if self:CalculateStackedEffect() < self.maxStack then
        self.statChanger = StatChanger(true)
        self.statChanger:SetInfo(self.buffStat, StatChangerCalculationType.PERCENT_ADD, self.buffAmount)

        self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
        self.statChangerEffect:SetDuration(self.buffDuration)
        self.statChangerEffect:AddStatChanger(self.statChanger)

        self.myHero.effectController:AddEffect(self.statChangerEffect)
        self.buffEffects:Add(self.statChangerEffect)
    end
end

--- @return void
function Hero50011_Skill4:CalculateStackedEffect()
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

return Hero50011_Skill4