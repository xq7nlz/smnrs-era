--- @class StatChangerSkillHelper : BaseSkillHelper
StatChangerSkillHelper = Class(StatChangerSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
--- @param statBonuses List<StatBonus>
function StatChangerSkillHelper:Ctor(skill, statBonuses)
    BaseSkillHelper.Ctor(self, skill)

    --- @type List<StatBonus>
    self.bonuses = statBonuses

    --- @type boolean
    self.isBuff = true

    --- @type boolean
    self.duration = EffectConstants.INFINITY_DURATION

    --- @type boolean
    self.persistentType = EffectPersistentType.PERMANENT

    --- @type StatChangerEffect
    self.statChangerEffect = nil
end

--- @return void
--- @param isBuff boolean
--- @param duration number
function StatChangerSkillHelper:SetInfo(isBuff, duration)
    self.isBuff = isBuff
    self.duration = duration
end

--- @return void
--- @param persistentType EffectPersistentType
function StatChangerSkillHelper:SetPersistentType(persistentType)
    self.persistentType = persistentType
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function StatChangerSkillHelper:AddStatChangerEffect(initiator, target)
    self.statChangerEffect = StatChangerEffect(initiator, target, self.isBuff)
    self.statChangerEffect:SetPersistentType(self.persistentType)
    self.statChangerEffect:SetDuration(self.duration)

    local i = 1
    while i <= self.bonuses:Count() do
        local statChanger = StatChanger(self.isBuff)
        local bonus = self.bonuses:Get(i)
        statChanger:SetInfo(bonus.statType, bonus.calculationType, bonus.amount)

        self.statChangerEffect:AddStatChanger(statChanger)
        i = i + 1
    end

    target.effectController:AddEffect(self.statChangerEffect)
    return self.statChangerEffect
end