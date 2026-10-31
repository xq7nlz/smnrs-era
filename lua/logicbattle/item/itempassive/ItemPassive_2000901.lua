--- @class ItemPassive_2000901 Talent passive Less power
ItemPassive_2000901 = Class(ItemPassive_2000901, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000901:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.powerGainPercent = nil

end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000901:CreateInstance(id, hero)
    return ItemPassive_2000901(id, hero)
end

--- @return void
function ItemPassive_2000901:Init()
    self.powerGainPercent = tonumber(self.data.fields.power_gain_percent)

    self.myHero.attackController:AddItemPassive(self)

    local effect = TalentLessPowerEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(effect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
function ItemPassive_2000901:CalculatePowerGain(target)
    if target.effectController:IsContainRemovableDeBuffEffect() then
        local lessPowerResult = ChangeLessPowerActionResult(self.myHero, target)
        ActionLogUtils.AddLog(self.myHero.battle, lessPowerResult)
        return self.powerGainPercent
    end

    return 1
end

return ItemPassive_2000901