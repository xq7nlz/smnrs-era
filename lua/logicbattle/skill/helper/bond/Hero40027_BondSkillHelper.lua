--- @class Hero40027_BondSkillHelper : BondSkillHelper
Hero40027_BondSkillHelper = Class(Hero40027_BondSkillHelper, BondSkillHelper)

---------------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
--- @param bond BaseBond
function Hero40027_BondSkillHelper:CreateBondEffect(initiator, target, isBuff, bond)
    return Hero40027_BondEffect(initiator, target, isBuff, bond)
end

--- @return void
--- @param targetList List<BaseHero>
function Hero40027_BondSkillHelper:GetNumberCanBeBonded(targetList)
    local numberCanBeBonded = 0
    local ariyuuBondEffect = Hero40027_BondEffect(self.myHero, self.myHero, self.isBuff)
    ariyuuBondEffect:SetDuration(self.duration)
    if self.myHero.effectController:CanAdd(ariyuuBondEffect) == true then
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            local bondEffect = Hero40027_BondEffect(self.myHero, target, self.isBuff)
            bondEffect:SetDuration(self.duration)
            if target.effectController:CanAdd(bondEffect) then
                numberCanBeBonded = numberCanBeBonded + 1
            end
            i = i + 1
        end
    else
        -- to create resist effect result
        self.myHero.effectController:AddEffect(ariyuuBondEffect)
    end
    return numberCanBeBonded
end