--- @class UIHeroListRaiseLevelLayout
UIHeroListRaiseLevelLayout = Class(UIHeroListRaiseLevelLayout)

--- @return void
function UIHeroListRaiseLevelLayout:Ctor(loopScroll , view)
    ---@type UIRaiseLevelHeroView
    self.view = view
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type Dictionary
    self.raisedSlots = nil
    ---@type PlayerRaiseLevelInbound
    self.playerRaisedLevelInbound = nil

    self.scrollAnchor = loopScroll
    self:InitScroll()
end

function UIHeroListRaiseLevelLayout:OnShow()
    self.playerRaisedLevelInbound = zg.playerData:GetRaiseLevelHero()
    self.raisedSlots = self.playerRaisedLevelInbound.raisedSlots
    self.maxCount = ResourceMgr.GetRaiseHeroConfig():GetBaseConfig():GetMaxSlot()
    self:ShowHeroList()
end

function UIHeroListRaiseLevelLayout:InitScroll()
    --- @param obj RaiseHeroIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        --- @type RaisedSlotData
        local raiseSlot = self.raisedSlots:Get(index + 1)
        obj:SetDataIcon(raiseSlot, index + 1, function(id)
            self.uiScroll:RefreshCells(id)
        end )
        obj:SetActionUpdateRaisedCount(function()
            self.view:UpdateHeroCount() end)
    end
    --- @param obj RaiseHeroIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        --- @type RaisedSlotData
        local raiseSlot = self.raisedSlots:Get(index + 1)
        obj:SetDataIcon(raiseSlot, index + 1,function(id)
            self.uiScroll:RefreshCells(id)
        end)
        obj:SetActionUpdateRaisedCount(function()
            self.view:UpdateHeroCount() end)
    end
    self.uiScroll = UILoopScroll(self.scrollAnchor, UIPoolType.RaiseHeroIconView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
    self.uiScroll:SetSize(self.maxCount)
end

function UIHeroListRaiseLevelLayout:ShowHeroList()
    --- @type List
    -- self.heroList:SortWithMethod(HeroResource.SortLevelStarReverse())
    self.uiScroll:Resize(self.maxCount, self.canPlayMotion)
    if self.canPlayMotion == true then
        self.canPlayMotion = false
        self.uiScroll:PlayMotion()
    end
end
function UIHeroListRaiseLevelLayout:OnHide()
    self.uiScroll:Hide()
end