--- @class UIDefeatBossChallengeLayout : UIDefeatLayout
UIDefeatBossChallengeLayout = Class(UIDefeatBossChallengeLayout, UIDefeatLayout)

function UIDefeatBossChallengeLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.buttonBattleLog.gameObject:SetActive(false)
    self.config.rewardAnchor.gameObject:SetActive(false)
    self.config.recommendAnchor.gameObject:SetActive(false)
    self.config.pveAnchor.gameObject:SetActive(false)
    self.config.arenaAnchor.gameObject:SetActive(false)
    self.config.localizeReward.gameObject:SetActive(false)
    self.config.localizeReward2.gameObject:SetActive(false)
end
