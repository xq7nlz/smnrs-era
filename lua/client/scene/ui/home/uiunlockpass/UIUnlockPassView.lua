
--- @class UIUnlockPassView : UIBaseView
UIUnlockPassView = Class(UIUnlockPassView, UIBaseView)

--- @param model UIUnlockPassModel
function UIUnlockPassView:Ctor(model)
	--- @type UIUnlockPassConfig
	self.config = nil
	--- @type function
	self.onClickBuy = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
	UIBaseView.Ctor(self, model)
	--- @type UIUnlockPassModel
	self.model = model
end

--- @return void
function UIUnlockPassView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.itemsTableView = ItemsTableView(self.config.itemReward)

	self:InitButtonListener()
end

function UIUnlockPassView:InitButtonListener()
	self.config.bgNone.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBuy.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if self.onClickBuy ~= nil then
			self.onClickBuy()
		end
	end)
end

--- @param data {title, content, listReward : List, textUnlock, price, onClickBuy}
function UIUnlockPassView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

	local title = data.title
	self.config.textTitleContent.text = title

	local content = data.content
	self.config.textContent.text = content

	local textUnlock = data.textUnlock
	self.config.textUnlock.text = textUnlock

	local price = data.price
	self.config.textPrice.text = price

	self.onClickBuy = data.onClickBuy
	self:ShowListReward(data.listReward)
end

function UIUnlockPassView:Hide()
	UIBaseView.Hide(self)
	self.itemsTableView:Hide()
	self.onClickBuy = nil
end

--- @param listRewardInBound List
function UIUnlockPassView:ShowListReward(listRewardInBound)
	self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end
