--- @class Hero10007_Skill3 Osse
Hero10007_Skill3 = Class(Hero10007_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10007_Skill3:CreateInstance(id, hero)
    return Hero10007_Skill3(id, hero)
end

--- @return void
function Hero10007_Skill3:Init()
end

--- @return BaseEffect
--- @param target BaseHero
function Hero10007_Skill3:OnCreateBondEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.data.statType, self.data.calculationType, self.data.effectAmount)

    local statChangerEffect = StatChangerEffect(self.myHero, target, false)
    statChangerEffect:AddStatChanger(statChanger)
    statChangerEffect:SetPersistentType(EffectPersistentType.DEPEND_ON_BOND)

    return statChangerEffect
end

return Hero10007_Skill3