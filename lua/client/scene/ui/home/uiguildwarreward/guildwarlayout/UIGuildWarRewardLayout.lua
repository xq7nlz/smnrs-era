--- @class UIGuildWarRewardLayout
UIGuildWarRewardLayout = Class(UIGuildWarRewardLayout)

--- @param view UIGuildWarRewardView
--- @param anchor UnityEngine_RectTransform
function UIGuildWarRewardLayout:Ctor(view, anchor)
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIGuildWarRewardView
    self.view = view
    --- @type UILoopScroll
    self.uiScroll = self.view.uiScroll
    --- @type UIGuildWarRewardConfig
    self.config = view.config

    self:_InitConfig()

    self:InitLocalization()
end

function UIGuildWarRewardLayout:_InitConfig()

end

function UIGuildWarRewardLayout:OnShow()
    self:SetUpLayout()
end

function UIGuildWarRewardLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
end

function UIGuildWarRewardLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end

function UIGuildWarRewardLayout:OnClaimSuccess()

end

function UIGuildWarRewardLayout:InitLocalization()

end