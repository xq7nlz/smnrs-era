--- @class UILeaderBoardLayout
UILeaderBoardLayout = Class(UILeaderBoardLayout)

--- @param view UILeaderBoardView
function UILeaderBoardLayout:Ctor(view)
    --- @type UILeaderBoardView
    self.view = view
    --- @type UILeaderBoardConfig
    self.config = view.config
    --- @type { IsAvailableToRequest : boolean}
    self.rankingData = nil
end

function UILeaderBoardLayout:InitLocalization()

end

function UILeaderBoardLayout:OnShow()
    self:SetUpLayout()
    self:CheckDataOnOpen()
end

function UILeaderBoardLayout:CheckDataOnOpen()
    if self:IsNeedRequestData() then
        self.config.loading:SetActive(true)
    else
        self:OnLoadedLeaderBoardData()
    end
end

function UILeaderBoardLayout:IsNeedRequestData()
    return self.rankingData == nil or self.rankingData:IsAvailableToRequest()
end

function UILeaderBoardLayout:SetUpLayout()

end

function UILeaderBoardLayout:OnFinishAnimation()
    if self:IsNeedRequestData() then
        self:LoadLeaderBoardData()
    end
end

function UILeaderBoardLayout:LoadLeaderBoardData()

end

function UILeaderBoardLayout:OnLoadedLeaderBoardData()
    self.config.loading:SetActive(false)
    self:ShowLeaderBoardData()
end

function UILeaderBoardLayout:ShowLeaderBoardData()

end

function UILeaderBoardLayout:OnHide()

end

function UILeaderBoardLayout:OnClickNextPage()

end

function UILeaderBoardLayout:OnClickPrevPage()

end