--- @class UIDefeatChristmasRecordLayout : UIDefeatLayout
UIDefeatChristmasRecordLayout = Class(UIDefeatChristmasRecordLayout, UIDefeatLayout)

function UIDefeatChristmasRecordLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.recommendAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {gameMode: GameMode, result, clientLogDetail, isSkip}
function UIDefeatChristmasRecordLayout:ShowData(data)

end
