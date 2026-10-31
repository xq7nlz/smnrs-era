--- @class UIEventHeroCollectLayout : UIEventQuestLayout
UIEventHeroCollectLayout = Class(UIEventHeroCollectLayout, UIEventQuestLayout)

local BG_TEXT_GLOW_COLOR = U_Color(1, 0.15, 0.098, 0.6)
local OUTLINE_ROUND_COLOR = U_Color(0.75, 0, 0, 1)

function UIEventHeroCollectLayout:SetUpLayout()
    self.config.bgTextGlow.color = BG_TEXT_GLOW_COLOR
    self.config.outLineTextRound.effectColor = OUTLINE_ROUND_COLOR
    UIEventQuestLayout.SetUpLayout(self)
end
