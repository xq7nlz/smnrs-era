--- @class Hero10006_BondSkillHelper : BondSkillHelper
Hero10006_BondSkillHelper = Class(Hero10006_BondSkillHelper, BondSkillHelper)

---------------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
--- @param bond BaseBond
function Hero10006_BondSkillHelper:CreateBondEffect(initiator, target, isBuff, bond)
    return Hero10006_BondEffect(initiator, target, isBuff, bond)
end

--- @return void
--- @param targetList List<BaseHero>
function Hero10006_BondSkillHelper:GetNumberCanBeBonded(targetList)
    local numberCanBeBonded = 0
    ---@type Hero10006_BondEffect
    local aqualordBondEffect = Hero10006_BondEffect(self.myHero, self.myHero, self.isBuff)
    if self.myHero.effectController:CanAdd(aqualordBondEffect) == true then
        local i = 1
        while i <= targetList:Count() do
            ---@type BaseHero
            local target = targetList:Get(i)
            ---@type Hero10006_BondEffect
            local bondEffect = Hero10006_BondEffect(self.myHero, target, self.isBuff)
            if target.effectController:CanAdd(bondEffect) then
                numberCanBeBonded = numberCanBeBonded + 1
            end
            i = i + 1
        end
    else
        -- to create resist effect result
        self.myHero.effectController:AddEffect(aqualordBondEffect)
    end

    return numberCanBeBonded
end