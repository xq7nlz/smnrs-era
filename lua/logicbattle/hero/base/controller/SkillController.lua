--- @class SkillController
SkillController = Class(SkillController)

--- @return void
--- @param hero BaseHero
function SkillController:Ctor(hero)

    --- @type BaseHero
    self.myHero = hero

    --- @type BaseSkill
    self.activeSkill = nil
    
    --- @type Dictionary --<BaseSkill>
    self.passiveSkills = Dictionary()

    --- @type List<BaseSkill>
    self.itemPassiveSkills = List()

    --- @type boolean
    self.canBeCounterAttack = true
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- this method is called after all stats of hero is calculated
function SkillController:Init()
    self.activeSkill:Init()
    
    ---@param passiveSkill BaseSkill
    for _, passiveSkill in pairs(self.passiveSkills:GetItems()) do
        if passiveSkill ~= nil then
            passiveSkill:Init()
        end
    end

    local i = 1
    while i <= self.itemPassiveSkills:Count() do
        local passiveSkill = self.itemPassiveSkills:Get(i)
        passiveSkill:Init()

        i = i + 1
    end
end

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param skill BaseSkill
function SkillController:AddSkill(id, skill)
    if id == 1 then
        self.activeSkill = skill
    else
        self.passiveSkills:Add(id, skill)
    end
end

--- @return void
--- @param skill BaseSkill
function SkillController:AddItemPassiveSkill(skill)
    self.itemPassiveSkills:Add(skill)
end

--- @return boolean
--- @param canBeCounterAttack boolean
function SkillController:SetCanBeCounterAttack(canBeCounterAttack)
    self.canBeCounterAttack = canBeCounterAttack
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
function SkillController:CanUseActiveSkill()
    if self.myHero.power:IsMax() and self.myHero.effectController:IsSilenced() == false then
        return true
    end
    return false
end

--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function SkillController:GetBlockDamageRate(target, type)
    return 0
end

--- @return boolean
--- @param initiator BaseHero
function SkillController:CanBeCounterAttack(initiator)
    return self.canBeCounterAttack
end

--- @return BaseSkill
--- @param id number
function SkillController:GetPassiveSkill(id)
    return self.passiveSkills:Get(id)
end

--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function SkillController:UseActiveSkill()
    self.myHero.power:SetToMin()

    local results, isEndTurn = self.activeSkill:UseActiveSkill()
    EventUtils.TriggerEventUseActiveSkill(self.myHero, results)

    if results:Count() == 0 then
        self.myHero.power:SetToMax()
    end

    return results, isEndTurn
end