--- @class Summoner4_Skill4_3 : BaseSkill Assassin
Summoner4_Skill4_3 = Class(Summoner4_Skill4_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatChanger
    self.statChanger = nil

    --- @type List<BaseEffect>
    self.statChangerEffectList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill4_3:CreateInstance(id, hero)
    return Summoner4_Skill4_3(id, hero)
end

--- @return void
function Summoner4_Skill4_3:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.buffPerPower = self.data.buffPerPower
    self.statBuffAmount = self.data.statBuffAmount

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.data.statBuffType, StatChangerCalculationType.PERCENT_ADD, 0)

    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
        effect:AddStatChanger(self.statChanger)

        target.effectController:AddEffect(effect)

        self.statChangerEffectList:Add(effect)
        i = i + 1
    end

    self.myHero.power:BindingWithSkill4_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
function Summoner4_Skill4_3:OnPowerChange()
    local numberBuff = math.floor(self.myHero.power:GetValue() / self.buffPerPower)
    self.statChanger:SetAmount(numberBuff * self.statBuffAmount)

    local i = 1
    while i <= self.statChangerEffectList:Count() do
        local effect = self.statChangerEffectList:Get(i)
        effect:Recalculate()
        i = i + 1
    end
end

return Summoner4_Skill4_3