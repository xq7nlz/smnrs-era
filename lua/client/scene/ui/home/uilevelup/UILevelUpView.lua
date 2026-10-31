---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiLevelUp.UILevelUpConfig"

--- @class UILevelUpView : UIBaseView
UILevelUpView = Class(UILevelUpView, UIBaseView)

--- @return void
--- @param model UILevelUpModel
--- @param ctrl UILevelUpCtrl
function UILevelUpView:Ctor(model, ctrl)
	---@type UILevelUpConfig
	self.config = nil
	---@type function
	self.callbackClose = nil
	--- @type Spine_Unity_SkeletonAnimation
	self.skeletonAnim = nil
	--- @type List
	self.listImgNumber = nil
	--- @type boolean
	self.isAllowClose = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UILevelUpModel
	self.model = model
	--- @type UILevelUpCtrl
	self.ctrl = ctrl
end

--- @return void
function UILevelUpView:OnReadyCreate()
	---@type UILevelUpConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.itemsTableView = ItemsTableView(self.config.rewardAnchor)

	self.config.backGround.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.listImgNumber = List()
	self.model.numberPrefab = self.config.numberPrefab
	local imgPrefab = self.config.numberPrefab:GetComponent(ComponentName.UnityEngine_UI_Image)
	self.listImgNumber:Add(imgPrefab)
end

function UILevelUpView:InitLocalization()
	self.config.textReward.text = LanguageUtils.LocalizeCommon("level_up_reward")
end

--- @return void
---@param result {level, listReward}
function UILevelUpView:OnReadyShow(result)
	self.config.textTapToClose:SetActive(false)
	self.isAllowClose = false
	if result ~= nil then
		self:SetLevel(result.level)
		self:SetReward(result.listReward)
		zg.audioMgr:PlaySfxUi(SfxUiType.LEVEL_UP)

		self:PlaySkeletonAnim()
	end
	Coroutine.start(function()
		self.config.cgTextLevelUp.alpha = 0
		coroutine.waitforseconds(10.0 / ClientConfigUtils.FPS)
		self:DoFadeInTextLevelUp()
		coroutine.waitforseconds(2)
		self.isAllowClose = true
		self.config.textTapToClose:SetActive(true)
	end)
end

function UILevelUpView:SetLevel(level)
	local stringLevel = tostring(level)
	if self.listImgNumber:Count() < #stringLevel then
		for i = 1, #stringLevel - self.listImgNumber:Count() do
			self:GetMoreImageNumberInstance()
		end
	end
	for i = 1, #stringLevel do
		--- @type UnityEngine_UI_Image
		local img = self.listImgNumber:Get(i)
		local spriteNumber = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.levelNumber, string.sub(stringLevel, i, i))
		img.sprite = spriteNumber
		img.gameObject:SetActive(true)
	end
end

--- @return void
--- @param listReward List <ItemIconData>
function UILevelUpView:SetReward(listReward)
	self.itemsTableView:SetData(listReward)
	for i = 1, listReward:Count() do
		--- @type ItemIconData
		local reward = listReward:Get(i)
		reward:AddToInventory()
	end
end

function UILevelUpView:SetLayer(layer)
	UIBaseView.SetLayer(self, layer)
	self.config.skeletonAnim.gameObject.layer = layer
	self.config.numberBone.layer = layer
	self.config.levelUpBone.layer = layer
end

function UILevelUpView:Hide()
	if self.isAllowClose ~= true then
		return
	end
	UIBaseView.Hide(self)
	for i = 1, self.listImgNumber:Count() do
		self.listImgNumber:Get(i).gameObject:SetActive(false)
	end
	if self.itemsTableView ~= nil then
		self.itemsTableView:Hide()
	end
end

function UILevelUpView:OnClickBackOrClose()
	if self.isAllowClose ~= true then
		return
	end
	UIBaseView.OnClickBackOrClose(self)
end

function UILevelUpView:PlaySkeletonAnim()
	self.config.skeletonAnim.AnimationState:ClearTracks()
	self.config.skeletonAnim.skeleton:SetToSetupPose()

	local trackEntry = self.config.skeletonAnim.AnimationState:SetAnimation(0, "start", false)
	trackEntry:AddCompleteListenerFromLua(function ()
		self.config.skeletonAnim.AnimationState:SetAnimation(0, "loop", true)
	end)
end

function UILevelUpView:DoFadeInTextLevelUp()
	self.config.cgTextLevelUp.alpha = 0
	DOTweenUtils.DOFade(self.config.cgTextLevelUp, 1, 10.0 / ClientConfigUtils.FPS)
end

--- @return UnityEngine_UI_Image
function UILevelUpView:GetMoreImageNumberInstance()
	--- @type UnityEngine_GameObject
	local newInstance = U_GameObject.Instantiate(self.model.numberPrefab, self.config.numberGroup)
	--- @type UnityEngine_RectTransform
	local trans = newInstance:GetComponent(ComponentName.UnityEngine_RectTransform)
	trans.anchoredPosition3D = U_Vector3.zero
	trans.localScale = U_Vector3.one

	local imgInstance = newInstance:GetComponent(ComponentName.UnityEngine_UI_Image)
	self.listImgNumber:Add(imgInstance)
	return imgInstance
end