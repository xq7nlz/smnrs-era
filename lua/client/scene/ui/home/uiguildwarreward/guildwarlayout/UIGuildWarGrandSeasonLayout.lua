--- @class UIGuildWarGrandSeasonLayout : UIGuildWarRewardLayout
UIGuildWarGrandSeasonLayout = Class(UIGuildWarGrandSeasonLayout, UIGuildWarRewardLayout)

--- @param view UIGuildWarRewardView
function UIGuildWarGrandSeasonLayout:Ctor(view, anchor)
    --- @type GuildWarListRankingRewardConfig
    self.guildWarListRankingRewardConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarSeasonRewardConfig()
    --- @type UnityEngine_Vector2
    self.scrollSize = U_Vector2(1334, 780)

    UIGuildWarRewardLayout.Ctor(self, view, anchor)
end

function UIGuildWarGrandSeasonLayout:_InitConfig()

end

function UIGuildWarGrandSeasonLayout:OnShow()
    UIGuildWarRewardLayout.OnShow(self)
    self:ShowData()
end

function UIGuildWarGrandSeasonLayout:SetUpLayout()
    UIGuildWarRewardLayout.SetUpLayout(self)

    self.config.rewardView.anchoredPosition3D = U_Vector3(0, 20, 0)

    self.config.rectScroll.sizeDelta = self.scrollSize
end

function UIGuildWarGrandSeasonLayout:ShowData()
    self:SetData()

    self.uiScroll:Resize(self.view.listGuildReward:Count())
end

function UIGuildWarGrandSeasonLayout:SetData()
    self.view:OnUpDateListRewards(self.guildWarListRankingRewardConfig.listRangeRankingReward)
end

function UIGuildWarGrandSeasonLayout:RefreshView()
    self:SetData()
    self.uiScroll:RefreshCells()
end

function UIGuildWarGrandSeasonLayout:InitLocalization()
    UIGuildWarRewardLayout.InitLocalization(self)
    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end
