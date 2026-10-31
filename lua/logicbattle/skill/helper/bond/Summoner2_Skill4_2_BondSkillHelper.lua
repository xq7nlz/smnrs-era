--- @class Summoner2_Skill4_2_BondSkillHelper : BondSkillHelper
Summoner2_Skill4_2_BondSkillHelper = Class(Summoner2_Skill4_2_BondSkillHelper, BondSkillHelper)

--- @return void
--- @param skill BaseSkill
function Summoner2_Skill4_2_BondSkillHelper:Ctor(skill)
    BondSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.tanker = nil
end

--- @return void
--- @param tanker BaseHero
function Summoner2_Skill4_2_BondSkillHelper:SetTanker(tanker)
    self.tanker = tanker
end

---------------------------------------- Use Bond skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
--- @param bond BaseBond
function Summoner2_Skill4_2_BondSkillHelper:UseBondSkill(targetList, bond)
    local numberCanBeBonded = self:GetNumberCanBeBonded(targetList)

    if numberCanBeBonded > 0 then
        self.myHero.battle.bondManager:AddBond(bond)

        local i = 1
        while i <= targetList:Count() do
            ---@type BaseHero
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
--- @param bond BaseBond
function Summoner2_Skill4_2_BondSkillHelper:CreateResult(bond)
    local result = BondCreatedResult(self.tanker, bond, self.duration)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end