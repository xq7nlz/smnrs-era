--- @class ItemPassive_290404:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290404 = Class(ItemPassive_290404, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290404:Ctor(id, hero)
	BaseItemPassiveSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290404:CreateInstance(id, hero)
	return ItemPassive_290404(id, hero)
end

--- @return void
function ItemPassive_290404:Init()
	self.healPercent = tonumber(self.data.fields.heal_percent)
	self.damagePercent = tonumber(self.data.fields.damage_percent)
	self.myHero.battleHelper:AddDamageItemPassive(self)

	local bonusHealEffect = BonusHealEffect(self.myHero, self.myHero)
	bonusHealEffect:SetPersistentType(EffectPersistentType.PERMANENT)
	bonusHealEffect:SetBonusHeal(self.healPercent)
	self.myHero.effectController:AddEffect(bonusHealEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @param totalDamage number
--- @param type DamageFormulaType
--- @param reason TakeDamageReason (only for dot effect)
function ItemPassive_290404:CalculateDamage(totalDamage, type, reason)
	if  type ~=  DamageFormulaType.DOT_EFFECT then
		return totalDamage
	end

	if reason == TakeDamageReason.POISON then
		return totalDamage * (1 + self.damagePercent)
	end
	return totalDamage
end

return ItemPassive_290404