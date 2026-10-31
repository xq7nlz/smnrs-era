--- @class BondSkillHelper
BondSkillHelper = Class(BondSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function BondSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type boolean
    self.isBuff = nil

    --- @type number
    self.duration = nil
end

--- @return void
--- @param isBuff boolean
--- @param duration number
function BondSkillHelper:SetInfo(isBuff, duration)
    self.isBuff = isBuff
    self.duration = duration
end

---------------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
--- @param bond BaseBond
function BondSkillHelper:UseBondSkill(targetList, bond)
    local numberCanBeBonded = self:GetNumberCanBeBonded(targetList)

    if numberCanBeBonded > 1 then
        self.myHero.battle.bondManager:AddBond(bond)

        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            ---@type BondEffect
            local effect = self:CreateBondEffect(self.myHero, target, self.isBuff, bond)
            effect:SetDuration(self.duration)

            if target.effectController:AddEffect(effect) then
                effect:BindingWithBond(bond)
                bond:AddBondedHero(target)
            end
            i = i + 1
        end

        self:CreateResult(bond)
    end
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
--- @param bond BaseBond
function BondSkillHelper:CreateBondEffect(initiator, target, isBuff, bond)
    return BondEffect(initiator, target, isBuff, bond)
end

--- @return void
--- @param targetList List<BaseHero>
function BondSkillHelper:GetNumberCanBeBonded(targetList)
    local numberCanBeBonded = 0
    local i = 1
    while i <= targetList:Count() do
        ---@type BaseHero
        local target = targetList:Get(i)

        local bondEffect = BondEffect(self.myHero, target, self.isBuff)
        if target.effectController:CanAdd(bondEffect) == true then
            numberCanBeBonded = numberCanBeBonded + 1
        else
            -- to create resist effect result
            target.effectController:AddEffect(bondEffect)
        end
        i = i + 1
    end
    return numberCanBeBonded
end

--- @return void
--- @param bond BaseBond
function BondSkillHelper:CreateResult(bond)
    local result = BondCreatedResult(self.myHero, bond, self.duration)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end