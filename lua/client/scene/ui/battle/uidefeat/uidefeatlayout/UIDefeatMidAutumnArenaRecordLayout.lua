--- @class UIDefeatMidAutumnArenaRecordLayout : UIDefeatLayout
UIDefeatMidAutumnArenaRecordLayout = Class(UIDefeatMidAutumnArenaRecordLayout, UIDefeatLayout)

function UIDefeatMidAutumnArenaRecordLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.recommendAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {gameMode: GameMode, result, clientLogDetail, isSkip}
function UIDefeatMidAutumnArenaRecordLayout:ShowData(data)

end
