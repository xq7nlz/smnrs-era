--- @class UIDefeatKazetsuLayout : UIDefeatLayout
UIDefeatKazetsuLayout = Class(UIDefeatKazetsuLayout, UIDefeatLayout)

function UIDefeatKazetsuLayout:Ctor(view, anchor)
    --- @type AvatarGameOverView
    self.avatar1 = nil
    --- @type AvatarGameOverView
    self.avatar2 = nil
    UIDefeatLayout.Ctor(self, view, anchor)
end

function UIDefeatKazetsuLayout:InitLayoutConfig()
    --- @type UIDefeatArenaConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
end

function UIDefeatKazetsuLayout:InitLocalization()
    UIDefeatLayout.InitLocalization(self)
end

function UIDefeatKazetsuLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.rewardAnchor.gameObject:SetActive(false)
    self.config.recommendAnchor.gameObject:SetActive(false)
    self.config.pveAnchor.gameObject:SetActive(false)
    self.config.arenaAnchor.gameObject:SetActive(false)
    self.config.localizeReward.gameObject:SetActive(false)
    self.config.localizeReward2.gameObject:SetActive(false)

end