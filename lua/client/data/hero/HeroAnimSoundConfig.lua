require "lua.client.data.Hero.HeroAnimConfig"

local HERO_ANIM_SOUND_PATH = "csv/client/hero_anim_sound_path_config.json"
local HERO_ANIM_SOUND_DIR = "csv/client/animation_sound/"

---@class AnimSound
AnimSound = Class(AnimSound)

--- @param data table
function AnimSound:Parse(data)
    self.folderPath = data.folder_path
    self.fileName = data.name
    self.animation = data.animation
    self.frame = tonumber(data.frame)

    self:Validate()
end

function AnimSound:Validate()
    if (not (self.folderPath and self.fileName and self.animation and self.frame)) then
        XDebug.Error(LogUtils.ToDetail(self))
    end
end

--- @class HeroAnimSoundConfig : HeroAnimConfig
HeroAnimSoundConfig = Class(HeroAnimSoundConfig, HeroAnimConfig)

function HeroAnimSoundConfig:Ctor()
    HeroAnimConfig.Ctor(self)
    self.heroAnimPath = HERO_ANIM_SOUND_PATH
    self.heroAnimDir = HERO_ANIM_SOUND_DIR
    self:InitCheck()
end

--- @return AnimSound
function HeroAnimSoundConfig:ParseLine(line)
    local data = AnimSound()
    data:Parse(line)
    return data
end

return HeroAnimSoundConfig