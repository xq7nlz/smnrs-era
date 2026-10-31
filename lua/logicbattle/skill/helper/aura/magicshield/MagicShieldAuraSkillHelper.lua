--- @class MagicShieldAuraSkillHelper : BaseAuraSkillHelper
MagicShieldAuraSkillHelper = Class(MagicShieldAuraSkillHelper, BaseAuraSkillHelper)

--- @return void
--- @param skill BaseSkill
--- @param aura BaseAura
--- @param blockChance number
--- @param blockRate number
function MagicShieldAuraSkillHelper:Ctor(skill, aura, blockChance, blockRate)
    BaseAuraSkillHelper.Ctor(self, skill, aura)

    --- @type number
    self.blockChance = blockChance

    --- @type number
    self.blockRate = blockRate
end

--- @return void
function MagicShieldAuraSkillHelper:Init()
    local targetList = self:GetTargetList()

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        ---@type MagicShield
        local magicShield = MagicShield(self.myHero, target, self.blockChance, self.blockRate)
        magicShield:SetPersistentType(EffectPersistentType.DEPEND_ON_AURA)

        self.aura:AddEffect(target, magicShield)
        i = i + 1
    end
end