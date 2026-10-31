--- @class StatChangerAuraSkillHelper : BaseAuraSkillHelper
StatChangerAuraSkillHelper = Class(StatChangerAuraSkillHelper, BaseAuraSkillHelper)

--- @return void
--- @param skill BaseSkill
--- @param aura BaseAura
--- @param statBonuses List<StatBonus>
function StatChangerAuraSkillHelper:Ctor(skill, aura, statBonuses)
    BaseAuraSkillHelper.Ctor(self, skill, aura)

    --- @type List<StatBonus>
    self.bonuses = statBonuses
end

---------------------------------------- Manage ----------------------------------------
--- @return void
function StatChangerAuraSkillHelper:AddEffectToAura()
    local targetList = self:GetTargetList()

    for i = 1, self.bonuses:Count() do
        local bonus = self.bonuses:Get(i)

        for j = 1, targetList:Count() do
            local target = targetList:Get(j)

            local effect = StatChangerEffect(self.myHero, target, self.aura.isBuff)
            effect:SetPersistentType(EffectPersistentType.DEPEND_ON_AURA)

            local statChanger = StatChanger(self.aura.isBuff)
            statChanger:SetInfo(bonus.statType, bonus.calculationType, bonus.amount)
            effect:AddStatChanger(statChanger)

            self.aura:AddEffect(target, effect)
        end
    end
end