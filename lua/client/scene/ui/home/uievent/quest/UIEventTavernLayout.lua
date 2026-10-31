--- @class UIEventTavernLayout : UIEventQuestLayout
UIEventTavernLayout = Class(UIEventTavernLayout, UIEventQuestLayout)

local BG_TEXT_GLOW_COLOR = U_Color(0.64, 0.3, 0.4, 1)
local OUTLINE_ROUND_COLOR = U_Color(0.47, 0.21, 1, 1)

function UIEventTavernLayout:SetUpLayout()
    self.config.bgTextGlow.color = BG_TEXT_GLOW_COLOR
    self.config.outLineTextRound.effectColor = OUTLINE_ROUND_COLOR
    UIEventQuestLayout.SetUpLayout(self)
end
