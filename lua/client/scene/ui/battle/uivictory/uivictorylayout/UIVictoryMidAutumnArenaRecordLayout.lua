--- @class UIVictoryMidAutumnArenaRecordLayout : UIVictoryLayout
UIVictoryMidAutumnArenaRecordLayout = Class(UIVictoryMidAutumnArenaRecordLayout, UIVictoryLayout)

function UIVictoryMidAutumnArenaRecordLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.buttonBattleLog.gameObject:SetActive(true)
end

--- @param data {}
function UIVictoryMidAutumnArenaRecordLayout:ShowData(data)

end