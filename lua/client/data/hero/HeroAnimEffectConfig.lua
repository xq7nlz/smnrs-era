require "lua.client.data.Hero.HeroAnimConfig"

local HERO_ANIM_EFFECT_PATH = "csv/client/hero_anim_effect_path_config.json"
local HERO_ANIM_EFFECT_DIR = "csv/client/animation_effect/"

--- @class AnimEffect
AnimEffect = Class(AnimEffect)

--- @param data table
function AnimEffect:Parse(data)
    self.effectName = data.effect_name
    self.effectType = data.effect_type
    self.parentPath  = data.parent
    self.animation = data.animation
    self.frame = tonumber(data.frame)

    self:Validate()
end

function AnimEffect:Validate()
    if not (self.effectName and self.effectType and self.parentPath and self.animation and self.frame) then
        XDebug.Error(LogUtils.ToDetail(self))
    end
end

--- @class HeroAnimEffectConfig : HeroAnimConfig
HeroAnimEffectConfig = Class(HeroAnimEffectConfig, HeroAnimConfig)

function HeroAnimEffectConfig:Ctor()
    HeroAnimConfig.Ctor(self)
    self.heroAnimPath = HERO_ANIM_EFFECT_PATH
    self.heroAnimDir = HERO_ANIM_EFFECT_DIR
    self:InitCheck()
end

--- @return AnimEffect
function HeroAnimEffectConfig:ParseLine(line)
    local data = AnimEffect()
    data:Parse(line)
    return data
end

return HeroAnimEffectConfig