--- @class MagicShield : BaseEffect
MagicShield = Class(MagicShield, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param blockChance number
--- @param blockRate number
function MagicShield:Ctor(initiator, target, blockChance, blockRate)
    BaseEffect.Ctor(self, initiator, target, EffectType.MAGIC_SHIELD, true)

    --- @type number
    self.blockChance = blockChance

    --- @type number
    self.blockRate = blockRate
end

--- @return number
function MagicShield:GetBlockDamageRate()
    local isBlock = self.initiator.randomHelper:RandomRate(self.blockChance)
    if isBlock == true then
        return self.blockRate
    end

    return 0
end

--- @return string
function MagicShield:ToDetailString()
    return string.format("%s, blockChance = %s, blockRate = %s", self:ToString(),
            self.blockChance, self.blockRate)
end