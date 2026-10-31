--- @class UIHeroForHireView : UIBaseView
UIHeroForHireView = Class(UIHeroForHireView, UIBaseView)

--- @return void
function UIHeroForHireView:Ctor(model)
    ---@type UIHeroForHireConfig
    self.config = nil

    ---@type UISelect
    self.uiScroll = nil
    UIBaseView.Ctor(self, model)

    self.model = model
    self.inbound = nil

    self.heroLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig()
end

function UIHeroForHireView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitScroll()
    self:InitButtons()
end

function UIHeroForHireView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("hero_support_for_friends")
end

function UIHeroForHireView:OnReadyShow()
    ---@type PlayerFriendInBound
    self.inbound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    self.heroSupportList = self.inbound.supportHeroList
    self:ShowHeroList()
end

function UIHeroForHireView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function ()
        self:OnClickBackOrClose()
    end)
end

function UIHeroForHireView:InitScroll()
    local addFunction = function(inventoryId)
        self:AddHeroSupportData(inventoryId)
    end

    local removeFunction = function(inventoryId)
        self:RemoveHeroSupportData(inventoryId)
    end

    local onUpdateItemHeroCard = function(obj, index)
    end
    ----- @param heroItem UIHeroForHireItem
    ----- @param heroIndex number
    local onCreateItemHeroCard = function(heroItem, index)
        heroItem:SetupCallBackAndDataList(addFunction, removeFunction, self.inbound.supportHeroList)
        if index + 1 <= self.inbound.supportHeroList:Count() then
            heroItem:UpdateIconHero(self.inbound.supportHeroList:Get(index + 1).inventoryId)
        else
            heroItem:UpdateIconHero()
        end
    end
    self.uiScroll = UILoopScrollAsync(self.config.scroll, UIPoolType.HeroForHireItem, onCreateItemHeroCard, onUpdateItemHeroCard)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 4))
end

function UIHeroForHireView:ShowHeroList()
    local count = self.heroLinkingTierConfig.numberHeroSupport
    self.uiScroll:Resize(count)
    self.uiScroll:PlayMotion()
end

--- @return void
function UIHeroForHireView:AddHeroSupportData(inventoryId)
    self.inbound:AddSupportHero(inventoryId)
end

--- @return void
function UIHeroForHireView:RemoveHeroSupportData(inventoryId)
    self.inbound:RemoveSupportHero(inventoryId)
end

--- @return void
function UIHeroForHireView:Hide()
    UIBaseView.Hide(self)
    --self.uiScroll:Hide()
    self.selectedId = nil
end