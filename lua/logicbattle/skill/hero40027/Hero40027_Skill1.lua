--- @class Hero40027_Skill1 : BaseSkill Ariyuu
Hero40027_Skill1 = Class(Hero40027_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BondSkillHelper
    self.bondSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill1:CreateInstance(id, hero)
    return Hero40027_Skill1(id, hero)
end

--- @return void
function Hero40027_Skill1:Init()
    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.skillDamage)

    self.bondSkillHelper = Hero40027_BondSkillHelper(self)
    self.bondSkillHelper:SetInfo(false, self.data.transformDuration)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40027_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.stunTargetPosition,
            TargetTeamType.ENEMY, self.data.stunTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    self:TransformToDragon()
    self:InflictBondEffect()
    return results, true
end

--- @return void
function Hero40027_Skill1:TransformToDragon()
    local effect = Hero40027_DragonTransformEffect(self.myHero, self.myHero)
    effect:SetDuration(self.data.transformDuration)
    self.myHero.effectController:AddEffect(effect)
    self.myHero:OnTransform(true)
end

--- @return void
--- @param target BaseHero
function Hero40027_Skill1:InflictEffect(target)
    local effect = StunEffect(self.myHero, target)
    effect:SetDuration(self.data.stunDuration)
    target.effectController:AddEffect(effect)
end

--- @return void
function Hero40027_Skill1:InflictBondEffect()
    ---@type List<BaseHero>
    local targetBondageList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero,
            self.data.bondTargetPosition, TargetTeamType.ENEMY, self.data.bondTargetNumber)

    targetBondageList:Insert(self.myHero, 1)
    local bond = Hero40027_Skill1_Bond(self.myHero, true)
    bond:SetInfo(self.data.bondDamagePercent)
    self.bondSkillHelper:UseBondSkill(targetBondageList, bond)

    self.myHero.skillController:OnAddBondEffect(targetBondageList)
end

return Hero40027_Skill1

