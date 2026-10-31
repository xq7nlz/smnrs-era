--- @class Summoner3_Skill1_3_BondSkillHelper : BondSkillHelper
Summoner3_Skill1_3_BondSkillHelper = Class(Summoner3_Skill1_3_BondSkillHelper, BondSkillHelper)

--- @return void
--- @param skill BaseSkill
function Summoner3_Skill1_3_BondSkillHelper:Ctor(skill)
    BondSkillHelper.Ctor(self, skill)

    --- @type List
    self.listEffectBond = List()
end

---------------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
--- @param bond BaseBond
function Summoner3_Skill1_3_BondSkillHelper:UseBondSkill(targetList, bond)
    local numberCanBeBonded = self:GetNumberCanBeBonded(targetList)
    if numberCanBeBonded > 1 then
        local i = 1
        while i <= self.listEffectBond:Count() do
            --- @type BondEffect
            local bondEffect = self.listEffectBond:Get(i)
            if bondEffect.myHero.effectController:IsContainEffect(bondEffect) then
                bondEffect.myHero.effectController:ForceRemove(bondEffect)
            end
            i = i + 1
        end
        self.listEffectBond:Clear()

        self.myHero.battle.bondManager:AddBond(bond)
        i = 1
        while i <= targetList:Count() do
            ---@type BaseHero
            local target = targetList:Get(i)
            ---@type BondEffect
            local effect = BondEffect(self.myHero, target, self.isBuff)
            effect:SetDuration(self.duration)

            if target.effectController:AddEffect(effect) then
                self.listEffectBond:Add(effect)
                effect:BindingWithBond(bond)
                bond:AddBondedHero(target)
            end
            i = i + 1
        end
        self:CreateResult(bond)
    end
end