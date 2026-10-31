
--- @class UIBoxRewardPreviewView : UIBaseView
UIBoxRewardPreviewView = Class(UIBoxRewardPreviewView, UIBaseView)

--- @param model UIBoxRewardPreviewModel
function UIBoxRewardPreviewView:Ctor(model)
	--- @type UIBoxRewardPreviewConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIBoxRewardPreviewModel
	self.model = model
	---@type List
	self.rewardList = nil
end

function UIBoxRewardPreviewView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	
	self:InitScroll()
	self:InitButtons()
end

--- @return void
--- Add reward list from gift box to show inside scroll content
function UIBoxRewardPreviewView:InitScroll()
	--- @param obj ItemIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local reward = self.rewardList:Get(index + 1)
		local type = reward.type
		local id = reward.id
		local number = reward.number
		local data = reward.data
		obj:EnableButton(true)
		obj:SetIconData(ItemIconData.CreateInstance(type, id, number,data))
		obj:RemoveAllListeners()
		obj:AddListener(function ()
			PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = type, ["id"] = id }})
		end)
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem)
end

--- @return void
function UIBoxRewardPreviewView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIBoxRewardPreviewView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("preview_reward")
	self.config.textDescribe.text = LanguageUtils.LocalizeCommon("text_describe_reward")
end

--- @return void
function UIBoxRewardPreviewView:Hide()
	UIBaseView.Hide(self)
end

--- @return void
--- @param data {callbackClose : function}
function UIBoxRewardPreviewView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.config.imageBox.sprite = data.imageBoxChosen
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if data ~= nil then
		self:ShowScroll(data)
	end
end

--- @return void
--- Show scroll list reward from gif box
function UIBoxRewardPreviewView:ShowScroll(data)
	self.rewardList = data.rewardList;
	self.uiScroll:Resize(self.rewardList:Count())
end

