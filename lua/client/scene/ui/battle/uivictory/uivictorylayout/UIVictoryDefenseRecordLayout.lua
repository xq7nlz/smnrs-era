--- @class UIVictoryDefenseRecordLayout : UIVictoryLayout
UIVictoryDefenseRecordLayout = Class(UIVictoryDefenseRecordLayout, UIVictoryLayout)

function UIVictoryDefenseRecordLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.buttonBattleLog.gameObject:SetActive(false)
end

--- @param data {}
function UIVictoryDefenseRecordLayout:ShowData(data)

end