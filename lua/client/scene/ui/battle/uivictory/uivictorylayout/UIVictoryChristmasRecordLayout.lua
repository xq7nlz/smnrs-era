--- @class UIVictoryChristmasRecordLayout : UIVictoryPveLayout
UIVictoryChristmasRecordLayout = Class(UIVictoryChristmasRecordLayout, UIVictoryLayout)

function UIVictoryChristmasRecordLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {}
function UIVictoryChristmasRecordLayout:ShowData(data)

end