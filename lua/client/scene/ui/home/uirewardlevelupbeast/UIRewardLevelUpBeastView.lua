--- @class UIRewardLevelUpBeastView : UIBaseView
UIRewardLevelUpBeastView = Class(UIRewardLevelUpBeastView, UIBaseView)

--- @param model UIRewardLevelUpBeastModel
function UIRewardLevelUpBeastView:Ctor(model)
    --- @type UIRewardLevelUpBeastConfig
    self.config = nil
    --- @type ItemsTableView
    self.tableInstanceReward = nil
    --- @type ItemsTableView
    self.tableRandomReward = nil
    UIBaseView.Ctor(self, model)
    --- @type UIRewardLevelUpBeastModel
    self.model = model
end

function UIRewardLevelUpBeastView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()

    self.tableInstanceReward = ItemsTableView(self.config.instanceRewardAnchor)
    self.tableRandomReward = ItemsTableView(self.config.randomRewardAnchor)
end

function UIRewardLevelUpBeastView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("reward")
	self.config.textInstanceReward.text = LanguageUtils.LocalizeCommon("instant_reward")
	self.config.textRandomReward.text = LanguageUtils.LocalizeCommon("random_reward")
end

function UIRewardLevelUpBeastView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @param data {listInstanceReward : List, listRandomReward : List}
function UIRewardLevelUpBeastView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.tableInstanceReward:SetData(RewardInBound.GetItemIconDataList(data.listInstanceReward))
	self.tableRandomReward:SetData(RewardInBound.GetItemIconDataList(data.listRandomReward))
end

function UIRewardLevelUpBeastView:Hide()
    UIBaseView.Hide(self)
    self.tableRandomReward:Hide()
    self.tableInstanceReward:Hide()
end
