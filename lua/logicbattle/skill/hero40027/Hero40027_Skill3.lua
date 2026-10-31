--- @class Hero40027_Skill3 : BaseSkill Ariyuu
Hero40027_Skill3 = Class(Hero40027_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40027_Skill3:CreateInstance(id, hero)
    return Hero40027_Skill3(id, hero)
end

--- @return void
function Hero40027_Skill3:Init()
    self.myHero.skillController:BindingWithSkill_3(self)
    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

function Hero40027_Skill3:AddPoisonEffect(target)
    if target ~= self.myHero then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.data.effectType, self.data.effectDuration, self.data.effectAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

--- @return void
function Hero40027_Skill3:OnAddBondEffect(targetBondageList)
    for _, hero in pairs(targetBondageList:GetItems()) do
       self:AddPoisonEffect(hero)
    end
end

return Hero40027_Skill3

