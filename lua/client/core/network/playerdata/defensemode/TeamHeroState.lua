require "lua.client.core.network.playerData.common.HeroStateInBound"

--- @class TeamHeroState
TeamHeroState = Class(TeamHeroState)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TeamHeroState:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TeamHeroState:ReadBuffer(buffer)
    ---@type List --<HeroStateInBound>
    self.heroStates = List()
    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            self.heroStates:Add(HeroStateInBound.CreateByBuffer(buffer))
        end
    end
end

function TeamHeroState:GetArgHp()
    if self.heroStates:Count() == 0 then
        return 0
    end
    local total = 0
    for i = 1, self.heroStates:Count() do
        --- @type HeroStateInBound
        local heroStateInBound = self.heroStates:Get(i)
        total = total + heroStateInBound.hp
    end
    return MathUtils.RoundDecimal(total / self.heroStates:Count(), 1)
end