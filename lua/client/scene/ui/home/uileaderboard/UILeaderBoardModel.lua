--- @class UILeaderBoardModel : UIBaseModel
UILeaderBoardModel = Class(UILeaderBoardModel, UIBaseModel)

--- @return void
function UILeaderBoardModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UILeaderBoard, "leader_board")
    --- @type RankingDataInBound
    self.rankingDataInBound = nil

    --- @type UnityEngine_Vector2
    self.scrollSizeWithUserItem = U_Vector2(1280, 585)
    self.scrollSizeWithoutUserItem = U_Vector2(1280, 765)
    
    self.bgDark = true
end

function UILeaderBoardModel:OnHide()
    self.rankingDataInBound = nil
end
