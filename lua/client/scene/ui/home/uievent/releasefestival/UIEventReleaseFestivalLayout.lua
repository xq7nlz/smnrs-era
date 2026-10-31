--- @class UIEventReleaseFestivalLayout : UIEventLayout
UIEventReleaseFestivalLayout = Class(UIEventReleaseFestivalLayout, UIEventLayout)

local cellSize = U_Vector2(1137, 185)
local spacing = U_Vector2(0, 10)

function UIEventReleaseFestivalLayout:Ctor(view)
    self.claimableIndex = nil
    --- @type EventReleaseFestivalConfig
    self.eventConfig = nil
    --- @type EventReleaseFestivalModel
    self.eventPopupModel = nil
    UIEventLayout.Ctor(self, view)
end

--- @param eventPopupModel EventReleaseFestivalModel
function UIEventReleaseFestivalLayout:OnShow(eventPopupModel)
    self.eventConfig = eventPopupModel:GetConfig()
    self.eventPopupModel = eventPopupModel
    self.claimableIndex = nil
    self:InitScrollContent()
    self:ResizeLoopScrollContent(self.eventConfig:GetConfig():Count())
    if self.claimableIndex ~= nil then
        self.view.scrollLoopContent:ScrollToCell(self.claimableIndex, 4500)
    end
end

function UIEventReleaseFestivalLayout:OnHide()
    UIEventLayout.OnHide(self)
    UIEventLayout.EnableLoopScrollContent(self, false)
end

function UIEventReleaseFestivalLayout:InitScrollContent()
    self.view:SetGridContentSize(cellSize, spacing, 1)

    --- @param obj UIEventReleaseFestivalItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type {numberPlayer : number, rewardInBound : RewardInBound}
        local itemConfig = self.eventConfig:GetItemConfigByIndex(dataIndex)
        --- @type boolean
        local isClaim = self.eventPopupModel:GetClaimStatusByMilestone(itemConfig.numberPlayer)
        obj:SetData(self.eventPopupModel.numberOfPlayer, itemConfig, isClaim)
        if isClaim == true then
            obj:SetAsClaimed()
        elseif self.eventPopupModel.numberOfPlayer >= itemConfig.numberPlayer then
            obj:AddOnClaimListener(function()
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
                local onSuccess = function()
                    self.eventPopupModel:ClaimMilestoneByMilestone(itemConfig.numberPlayer)
                    itemConfig.rewardInBound:AddToInventory()
                    SmartPoolUtils.ShowReward1Item(itemConfig.rewardInBound:GetIconData())
                    obj:SetAsClaimed()
                    RxMgr.notificationEventPopup:Next(self.eventPopupModel:GetType())
                end
                EventReleaseFestivalModel.RequestClaim(itemConfig.numberPlayer, onSuccess)
            end)
        else
            obj:SetAsNotEnough()
        end
    end
    self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.UIEventReleaseFestivalItem, onCreateItem)
    self.view.scrollLoopContent:SetUpMotion(MotionConfig())
end
