--- @class ReflectAuraSkillHelper : BaseAuraSkillHelper
ReflectAuraSkillHelper = Class(ReflectAuraSkillHelper, BaseAuraSkillHelper)

--- @return void
--- @param skill BaseSkill
--- @param aura BaseAura
function ReflectAuraSkillHelper:Ctor(skill, aura)
    BaseAuraSkillHelper.Ctor(self, skill, aura)

    --- @type Dictionary<BaseHero, BaseEffect>
    self.effectMap = Dictionary()
end

--- @return void
function ReflectAuraSkillHelper:Init()
    local targetList = self:GetTargetList()

    local i = 1
    while i <= targetList:Count() do
        ---@type BaseHero
        local target = targetList:Get(i)
        ---@type Hero60004_ReflectEffect
        local reflectEffect = Hero60004_ReflectEffect(self.myHero, target)
        reflectEffect:SetPersistentType(EffectPersistentType.DEPEND_ON_AURA)

        self.effectMap:Add(target,reflectEffect)
        self.aura:AddEffect(target, reflectEffect)
        i = i + 1
    end
end