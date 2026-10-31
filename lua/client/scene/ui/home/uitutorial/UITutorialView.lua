require "lua.client.scene.ui.home.uiTutorial.UITutorialNpcView"
require "lua.client.scene.ui.home.uiTutorial.TutorialData"

--- @class UITutorialView : UIBaseView
UITutorialView = Class(UITutorialView, UIBaseView)

--- @return void
--- @param model UITutorialModel
function UITutorialView:Ctor(model)
	---@type UITutorialConfig
	self.config = nil
	---@type List --<TutorialBase>
	self.listTutorial = TutorialData.GetListTutorial()
	---@type TutorialInBound
	self.tutorialInBound = nil
	---@type UITutorialNpcView
	self.npcTopLeft = nil
	---@type UITutorialNpcView
	self.npcBottomLeft = nil
	---@type UITutorialNpcView
	self.npcTopRight = nil
	---@type UITutorialNpcView
	self.npcBottomRight = nil
	---@type UITutorialNpcView
	self.npcCenter = nil
	---@type UITutorialNpcView
	self.npcCenterTop = nil

	---@type UITutorialNpcView
	self.currentNpc = nil

	---@type HeroIconView
	self.heroIconView = nil

	---@type TutorialSingle
	self.currentTutorial = nil
	---@type TutorialSingle
	self.cacheTutorial = nil
	---@type function
	self.isWaitingFocusPosition = false

	---@type UnityEngine_RenderTexture
	self.renderTexture = nil

	---@type boolean
	self.canNextTutorial = true

	---@type UnityEngine_Vector3
	self.positionFocus = nil

	self.sysButton1 = nil
	self.sysButton2 = nil
	self.sysFocus = nil
	self.coroutineShow = nil
	self.currentStep = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UITutorialModel
	self.model = model
end

--- @return void
function UITutorialView:OnReadyCreate()
	---@type UITutorialConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.npcTopLeft = UITutorialNpcView(self.config.tutorialNpcTopLeft)
	self.npcBottomLeft = UITutorialNpcView(self.config.tutorialNpcBottomLeft)
	self.npcTopRight = UITutorialNpcView(self.config.tutorialNpcTopRight)
	self.npcBottomRight = UITutorialNpcView(self.config.tutorialNpcBottomRight)
	self.npcCenter = UITutorialNpcView(self.config.tutorialNpcCenter)
	self.npcCenterTop = UITutorialNpcView(self.config.tutorialNpcCenterTop)

	self.currentNpc = self.npcTopRight

	self.config.buttonBg.onClick:AddListener(function ()
		self:OnClickBG()
	end)
end

--- @return void
function UITutorialView:OnReadyShow(data)
	UIBaseView.tutorial = self
	self.tutorialInBound = zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL)
	UIUtils.SetInteractableButton(self.config.buttonBg, false)
	self:ClearUITutorial()

	---@type CanvasConfig
	local canvasConfig = uiCanvas.config
	if self.uiTransform.parent ~= canvasConfig.uiTutorial then
		self.uiTransform:SetParent(canvasConfig.uiTutorial)
	end
	self:ShowTutorialCanRun(data and data.step or nil)
end

function UITutorialView:ShowTutorialCanRun(step)
	---@type TutorialBase
	local tutorial = TutorialData.GetTutorialCanShow()
	if tutorial ~= nil then
		self.currentStep = tutorial:GetStepId()
		if step == nil then
			self:ShowTutorialStep(tutorial:Start():GetStartNode())
		elseif tutorial:GetStepId() == step then
			self:ShowTutorialStep(tutorial:Continue():GetStartNode())
		else
			self:FinishTutorial(step)
		end
	else
		self:FinishTutorial(step)
	end
end

function UITutorialView:FinishTutorial()
	PopupMgr.HidePopup(UIPopupName.UITutorial)
	XDebug.Log("finish tutorial ..  ")
	RxMgr.finishTutorial:Next()
end

--- @return TutorialNode
function UITutorialView:Continue()
	local node
    ---@param v TutorialBase
	for i, v in ipairs(self.listTutorial:GetItems()) do
		if self.tutorialInBound.listStepTutComplete:IsContainValue(v:GetStepId()) == false and v:CanRunTutorial() == true then
			node = v:Continue()
			self.currentStep = v:GetStepId()
			break
		end
	end
	return node
end

--- @return void
---@param nextTutorial TutorialNode
function UITutorialView:NextTutorial(nextTutorial,duplicateTrackingSummonTut)
	UIUtils.SetInteractableButton(self.config.buttonBg, false)
	self:ClearUITutorial()
	if self.currentStep ~= nil and self.currentTutorial.tutorialStepData.trackingID ~= nil then
		self:SaveStep(self.currentStep + self.currentTutorial.tutorialStepData.trackingID)
		--if self.log == nil then
		--	self.log = "id,step" .. '\n'
		--end
		--self.log = self.log .. self.currentStep + self.currentTutorial.tutorialStepData.trackingID .. "," .. (self.currentTutorial.tutorialStepData.trackingName or "") .. '\n'
	end
	self:SaveStep(self.currentTutorial.tutorialStepData.saveStepId,duplicateTrackingSummonTut)
	if self.currentTutorial.tutorialStepData.callback ~= nil then
		self.currentTutorial.tutorialStepData.callback()
	end
	local next = nextTutorial
	if next == nil then
		next = self.currentTutorial:Next()
	end
	if next == nil then
		if self.cacheTutorial == nil then
			next = self:Continue()
		else
			self.currentTutorial = self.cacheTutorial
			self.cacheTutorial = nil
			self.isWaitingFocusPosition = true
			return
		end
	end
	if next ~= nil and zg.sceneMgr.gameMode ~= GameMode.TUT_BATTLE then
		local a = next:GetStartNode()
		self:ShowTutorialStep(a)
	else
		self:FinishTutorial()
	end
end


--- @return void
---@param tutorial TutorialBase
function UITutorialView:InsertTutorial(tutorial)
	if self.tutorialInBound.listStepTutComplete:IsContainValue(tutorial:GetStepId()) == false and
			tutorial:CanRunTutorial() == true and self.cacheTutorial == nil then
		self.cacheTutorial = self.currentTutorial
		self:ShowTutorialStep(tutorial:Start():GetStartNode())
	end
end

--- @return void
---@param node TutorialSingle
function UITutorialView:ShowTutorialStep(node)
	if node ~= nil then
		--self:ClearUITutorial()
		if node.tutorialStepData ~= nil then
			self.currentTutorial = node
			self.config.buttonBg.gameObject:SetActive(true)
			UIUtils.SetInteractableButton(self.config.buttonBg, false)
			self.config.imageBg.color = U_Color(1,1,1,0)
			--if self.config.aqualords.gameObject.activeInHierarchy then
			--	self.config.aqualords.gameObject:SetActive(false)
			--end

			self.isWaitingFocusPosition = false

			self.config.focus.gameObject:SetActive(false)
			if self.currentNpc ~= nil then
				self.currentNpc:Hide()
			end

			local show = function()
				UIUtils.SetInteractableButton(self.config.buttonBg, true)
				if self.currentTutorial.tutorialStepData.focus == nil then
					self:ViewNpcCurrentTutorial()
				end
			end

			if self.currentTutorial.tutorialStepData.delay == nil then
				show()
			else
				Coroutine.start(function ()
					coroutine.waitforseconds(self.currentTutorial.tutorialStepData.delay)
					show()
				end)
			end

			if self.currentTutorial.tutorialStepData.focus ~= nil then
				self.isWaitingFocusPosition = true
				RxMgr.tutorialFocus:Next(self.currentTutorial.tutorialStepData.step)

			end

		else
			XDebug.Log(LogUtils.ToDetail(node))
		end
	else
		self:FinishTutorial()
	end
end

--- @return void
function UITutorialView:OnClickBG()
	if self.canNextTutorial == true then
		if self.currentTutorial ~= nil and self.currentTutorial.tutorialStepData ~= nil and self.currentTutorial.tutorialStepData.focus == nil and
				self.currentTutorial.tutorialStepData.localizeTextButton1 == nil and self.currentTutorial.tutorialStepData.localizeTextButton2 == nil then
			self:NextTutorial()
		end
	elseif self.currentNpc ~= nil then
		self.currentNpc:SkipNpc()
	end
end

--- @return void
function UITutorialView:GetHandType(default)
	local handType = nil
	if self.currentTutorial.tutorialStepData.focus ~= TutorialFocus.TAP_TO_CLICK and
			self.currentTutorial.tutorialStepData.focus ~= TutorialFocus.AUTO_NEXT then
		handType = default
	end
	return handType
end

--- @return void
function UITutorialView:ShowHandType()
	if self.handType ~= nil then
		if self.renderTexture == nil then
			self.renderTexture = U_RenderTexture(U_Screen.width, U_Screen.height, 24, U_RenderTextureFormat.ARGB32)
			self.config.cam.targetTexture = self.renderTexture
			self.config.rawImage.texture = self.renderTexture
		end
		if self.handType == TutorialHandType.CLICK then
			self.callbackUpdatePositionFocus = function()
				self.config.rootHand.position = self.config.cam:ScreenToWorldPoint(
						uiCanvas.camUI:WorldToScreenPoint(self.positionFocus + U_Vector3.up * 0.2))
			end
			self.config.skeletonHand.AnimationState:SetAnimation(0, "Guide", true)
		elseif self.handType == TutorialHandType.MOVE_CLICK then
			self.callbackUpdatePositionFocus = function()
				self.config.handStart.position = self.config.cam:ScreenToWorldPoint(
						uiCanvas.camUI:WorldToScreenPoint(self.positionFocus + U_Vector3(2, -1.5, 0)))
				self.config.handEnd.position = self.config.cam:ScreenToWorldPoint(
						uiCanvas.camUI:WorldToScreenPoint(self.positionFocus))
			end
			self.config.skeletonHand.AnimationState:SetAnimation(0, "Guide4", true)
		elseif self.handType == TutorialHandType.MULTIPLE_CLICK then
			self.callbackUpdatePositionFocus = function()
				self.config.rootHand.position = self.config.cam:ScreenToWorldPoint(
						uiCanvas.camUI:WorldToScreenPoint(self.positionFocus + U_Vector3.up * 0.3))
			end
			self.config.skeletonHand.AnimationState:SetAnimation(0, "Guide3", true)
		elseif self.handType == TutorialHandType.CLICK_BOTTOM then
			self.callbackUpdatePositionFocus = function()
				self.config.rootHand.position = self.config.cam:ScreenToWorldPoint(
						uiCanvas.camUI:WorldToScreenPoint(self.positionFocus + U_Vector3.down * 0.9))
			end
			self.config.skeletonHand.AnimationState:SetAnimation(0, "Guide", true)
		end

		if self.callbackUpdatePositionFocus ~= nil then
			self.callbackUpdatePositionFocus()
		end
		Coroutine.start(function ()
			coroutine.waitforendofframe()
			self.config.rawImage.gameObject:SetActive(true)
		end)
	else
		self.config.rawImage.gameObject:SetActive(false)
	end
end

--- @return void
function UITutorialView:DelayNextTutorial()
	self.config.focus.onClick:RemoveAllListeners()
	self.config.buttonFocus.onClick:RemoveAllListeners()
	self.config.buttonFocus2.onClick:RemoveAllListeners()
	self.config.focus.gameObject:SetActive(false)
end

--- @return void
function UITutorialView:UpdatePositionFocus(position)
	if self.currentTutorial.tutorialStepData.focus ~= TutorialFocus.TAP_TO_CLICK then
		self.config.focus.transform.position = position
	end
	self.positionFocus = position
	if self.callbackUpdatePositionFocus ~= nil then
		self.callbackUpdatePositionFocus()
	end
end

--- @return void
---@param button UnityEngine_UI_Button
---@param scale number
---@param position UnityEngine_Vector3
---@param delayNext boolean
---@param handType TutorialHandType
function UITutorialView:ViewFocusCurrentTutorial(button, scale, position, delayNext, handType)
	self.callbackUpdatePositionFocus = nil
	local show = function()
		self.isWaitingFocusPosition = false
		if self.coroutineShow ~= nil then
			Coroutine.stop(self.coroutineShow)
			self.coroutineShow = nil
		end
		if self.sysFocus ~= nil then
			Coroutine.stop(self.sysFocus)
			self.sysFocus = nil
		end
		if position == nil and button ~= nil then
			self:UpdatePositionFocus(button.transform.position)
			self.sysFocus = Coroutine.start(function ()
				while button.gameObject.activeInHierarchy do
					coroutine.waitforendofframe()
					self:UpdatePositionFocus(button.transform.position)
				end
			end)
		elseif position ~= nil then
			if type(position) == "function" then
				self:UpdatePositionFocus(position())
				self.sysFocus = Coroutine.start(function ()
					while self.config.gameObject.activeInHierarchy do
						coroutine.waitforendofframe()
						self:UpdatePositionFocus(position())
					end
				end)
			else
				if position.position ~= nil then
					self:UpdatePositionFocus(position.position)
					self.sysFocus = Coroutine.start(function ()
						while position.gameObject.activeInHierarchy do
							coroutine.waitforendofframe()
							self:UpdatePositionFocus(position.position)
						end
					end)
				else
					self:UpdatePositionFocus(position)
				end
			end
		end
		if scale ~= nil then
			if type(scale) == "number" then
				self.config.focus1.gameObject:SetActive(true)
				self.config.focus2.gameObject:SetActive(false)
				self.config.focus1.transform.localScale = U_Vector3.one * scale
			else
				self.config.focus1.gameObject:SetActive(false)
				self.config.focus2.gameObject:SetActive(true)
				self.config.focus2.sizeDelta = scale
			end
		end
		self.config.focus.onClick:RemoveAllListeners()
		local clickFocus = function ()
			if button ~= nil then
				button.onClick:Invoke()
			end
			if delayNext == true then
				self:DelayNextTutorial()
			elseif self.currentTutorial.tutorialStepData.waitOpCode ~= nil then
				self.config.rawImage.gameObject:SetActive(false)
				self:DelayNextTutorial()

				self.currentTutorial.tutorialStepData:SubscriptionOpcode(function ()
					self:NextTutorial()
				end)
			else
				self:NextTutorial()
			end
		end

		self.handType = handType
		self:ViewNpcCurrentTutorial()

		if self.currentTutorial.tutorialStepData.focus == TutorialFocus.FOCUS_CLICK then
			self.config.buttonFocus.onClick:RemoveAllListeners()
			self.config.buttonFocus2.onClick:RemoveAllListeners()
			self.config.buttonFocus.onClick:AddListener(function ()
				self.config.buttonFocus.onClick:RemoveAllListeners()
				clickFocus()
			end)
			self.config.buttonFocus2.onClick:AddListener(function ()
				self.config.buttonFocus2.onClick:RemoveAllListeners()
				clickFocus()
			end)
		elseif self.currentTutorial.tutorialStepData.focus == TutorialFocus.AUTO_NEXT then
			clickFocus()
		elseif self.currentTutorial.tutorialStepData.focus == TutorialFocus.TAP_TO_CLICK then
			if handType == nil then
				self.config.focus.transform.position = U_Vector3(-50, -50, self.config.focus.transform.position.z)
			end
			self.config.buttonFocus.gameObject:SetActive(false)
			self.config.buttonFocus2.gameObject:SetActive(false)
			if self.currentTutorial.tutorialStepData.localizeTextButton1 == nil and self.currentTutorial.tutorialStepData.localizeTextButton2 == nil then
				self.config.focus.onClick:AddListener(function ()
					self.config.focus.onClick:RemoveAllListeners()
					clickFocus()
				end)
			end
		else
			self.config.buttonFocus.gameObject:SetActive(false)
			self.config.buttonFocus2.gameObject:SetActive(false)
			if self.currentTutorial.tutorialStepData.localizeTextButton1 == nil and self.currentTutorial.tutorialStepData.localizeTextButton2 == nil then
				self.config.focus.onClick:AddListener(function ()
					self.config.focus.onClick:RemoveAllListeners()
					self:NextTutorial(nil, true)
				end)
			end
		end
	end

	--self:ClearUITutorial()
	if self.currentTutorial.tutorialStepData.delay == nil then
		show()
	else
		self.coroutineShow = Coroutine.start(function ()
			coroutine.waitforseconds(self.currentTutorial.tutorialStepData.delay)
			show()
		end)
	end
end

--- @return void
---@param position1 UnityEngine_Transform
---@param position2 UnityEngine_Transform
function UITutorialView:ViewDragCurrentTutorial(position1, position2, down, drag, upSuccess, upFail, checkDown, checkUp, callbackFailedDrag)
	local show = function()
		self:ViewNpcCurrentTutorial(function ()
			local selected = false
			local finishDrag = function()
				UIUtils.SetInteractableButton(self.config.focus, true)
				UIUtils.SetInteractableButton(self.config.buttonFocus, true)
				UIUtils.SetInteractableButton(self.config.buttonFocus2, true)
				self:NextTutorial()

				if self.listenerApplicationPause ~= nil then
					self.listenerApplicationPause:Unsubscribe()
					self.listenerApplicationPause = nil
				end
			end

			if self.renderTexture == nil then
				self.renderTexture = U_RenderTexture(U_Screen.width, U_Screen.height, 24, U_RenderTextureFormat.ARGB32)
				self.config.cam.targetTexture = self.renderTexture
				self.config.rawImage.texture = self.renderTexture
			end
			self.config.handTarget.position = self.config.cam:ScreenToWorldPoint(position2)
			self.config.arrowRoot.position = self.config.cam:ScreenToWorldPoint(position1)
			local p1 = uiCanvas.camIgnoreBlur:ScreenToWorldPoint(position1)
			local p2 = uiCanvas.camIgnoreBlur:ScreenToWorldPoint(position2)
			self.config.focus.transform.position = (p1 + p2)/2
			UIUtils.SetInteractableButton(self.config.focus, false)
			self.config.focus1.gameObject:SetActive(true)
			self.config.focus2.gameObject:SetActive(false)
			self.config.focus.gameObject:SetActive(true)
			self.config.focus1.transform.localScale = U_Vector3.one * 2
			self.config.skeletonHand.AnimationState:SetAnimation(0, "UI_NPC_Tutorial", true)
			self.config.rawImage.gameObject:SetActive(true)
			self.isWaitingFocusPosition = false
			self.config.drag.gameObject:SetActive(true)
			self.config.imageBg.color = U_Color(1, 1, 1, 0)
			self.config.drag.triggers:Clear()

			--- TODO
			if U_Rect == nil then
				local coroutineDragFailed = Coroutine.start(function ()
					coroutine.waitforseconds(2)
					if callbackFailedDrag ~= nil then
						if selected == true then
							if upFail ~= nil then
								upFail()
							end
							selected = false
						end
						callbackFailedDrag(true, 2, false, 2)
						finishDrag()
					end
				end)
			else
				--- @param status PauseStatus
				self.pauseCallback = function (status)
					if status == PauseStatus.PAUSE or status == PauseStatus.FOCUS then
						if upFail ~= nil then
							upFail()
						end
						selected = false
					end
				end
				self.listenerApplicationPause = nil

				local entryPointerDown = U_EventSystems.EventTrigger.Entry()
				entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
				entryPointerDown.callback:AddListener(function(data)
					local position = data.position
					if checkDown(position, true, 2) then
						if down ~= nil then
							down(position)
						end
						selected = true
						if self.listenerApplicationPause == nil then
							self.listenerApplicationPause = RxMgr.applicationPause:Subscribe(RxMgr.CreateFunction(self, self.pauseCallback))
						end
					else
						selected = false
					end
				end)
				self.config.drag.triggers:Add(entryPointerDown)

				local entryPointerUp = U_EventSystems.EventTrigger.Entry()
				entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
				entryPointerUp.callback:AddListener(function(data)
					local position = data.position
					if selected == true then
						if checkUp(position, false, 2) then
							if upSuccess ~= nil and upSuccess(position) == true then
								finishDrag()
								if coroutineDragFailed ~= nil then
									Coroutine.stop(coroutineDragFailed)
									coroutineDragFailed = nil
								end
							end
						else
							if upFail ~= nil then
								upFail(position)
							end
						end
						selected = false
					end
				end)
				self.config.drag.triggers:Add(entryPointerUp)

				local entryPointerExit = U_EventSystems.EventTrigger.Entry()
				entryPointerExit.eventID = U_EventSystems.EventTriggerType.PointerExit
				entryPointerExit.callback:AddListener(function(data)
					if upFail ~= nil then
						upFail()
					end
					selected = false
				end)
				self.config.drag.triggers:Add(entryPointerExit)

				--- calculate and drag slot hero
				--- @type UnityEngine_EventSystems_EventTrigger_Entry
				local entryDrag = U_EventSystems.EventTrigger.Entry()
				entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
				entryDrag.callback:AddListener(function(data)
					local position = data.position
					if selected == true then
						if drag ~= nil then
							drag(position)
						end
					end
				end)
				self.config.drag.triggers:Add(entryDrag)
			end
		end)
	end

	--self:ClearUITutorial()
	if self.currentTutorial.tutorialStepData.delay == nil then
		show()
	else
		Coroutine.start(function ()
			coroutine.waitforseconds(self.currentTutorial.tutorialStepData.delay)
			show()
		end)
	end
end

--- @return void
function UITutorialView:ClearUITutorial()
	self.handType = nil
	self.config.rawImage.gameObject:SetActive(false)
	self.config.drag.gameObject:SetActive(false)
	self.config.button1.gameObject:SetActive(false)
	self.config.button2.gameObject:SetActive(false)

	if self.coroutineShow ~= nil then
		Coroutine.stop(self.coroutineShow)
		self.coroutineShow = nil
	end
	if self.sysFocus ~= nil then
		Coroutine.stop(self.sysFocus)
		self.sysFocus = nil
	end
end

--- @return void
function UITutorialView:ViewNpcCurrentTutorial(callbackShow)
	local showFocus = function()
		if self.currentTutorial.tutorialStepData.hideFocus == true then
			self.config.imageFocus1.color = U_Color(1,1,1,0)
			self.config.imageFocus2.color = U_Color(1,1,1,0)
		else
			self.config.imageFocus1.color = U_Color(1,1,1,1)
			self.config.imageFocus2.color = U_Color(1,1,1,1)
		end

		if self.currentTutorial.tutorialStepData.focus == TutorialFocus.FOCUS_CLICK then
			self.config.buttonFocus.gameObject:SetActive(true)
			self.config.buttonFocus2.gameObject:SetActive(true)
			self.config.focus.gameObject:SetActive(true)
			self.config.imageBg.color = U_Color(1,1,1,0)
		elseif self.currentTutorial.tutorialStepData.focus == TutorialFocus.FOCUS or
				self.currentTutorial.tutorialStepData.focus == TutorialFocus.TAP_TO_CLICK then
			self.config.focus.gameObject:SetActive(true)
			self.config.imageBg.color = U_Color(1,1,1,0)
		end
		UIUtils.SetInteractableButton(self.config.button1, true)
		UIUtils.SetInteractableButton(self.config.button2, true)
		if self.currentTutorial.tutorialStepData.focus ~= TutorialFocus.AUTO_NEXT then
			self:ShowHandType()
		end
		self.config.targetFocus:SetActive(self.currentTutorial.tutorialStepData.showTargetFocus == true)
		if callbackShow ~= nil then
			callbackShow()
		end

		UIUtils.SetInteractableButton(self.config.focus, true)
		UIUtils.SetInteractableButton(self.config.buttonFocus, true)
		UIUtils.SetInteractableButton(self.config.buttonFocus2, true)
	end

	if self.currentTutorial.tutorialStepData:IsContainTextNpc() then
		self.canNextTutorial = false
		if self.currentTutorial.tutorialStepData.hideFocus == false then
			self.config.imageBg.color = U_Color(1,1,1,1)
		end
		UIUtils.SetInteractableButton(self.config.focus, false)
		UIUtils.SetInteractableButton(self.config.buttonFocus, false)
		UIUtils.SetInteractableButton(self.config.buttonFocus2, false)
		local node1 = self.currentTutorial:Option1()
		local callbackButton1 = function()
				self:SaveStep(self.currentTutorial.tutorialStepData.saveOption1Id)
				if self.currentStep ~= nil then
					self:SaveStep(self.currentStep + 900)
					--TrackingUtils.SetTutorial(self.currentStep, "click_option1")
				end
				if node1 ~= nil then
					self:ShowTutorialStep(node1:GetStartNode())
				else
					self:NextTutorial()
				end
			end

		local node2 = self.currentTutorial:Option2()
		local callbackButton2 = function()
			self:SaveStep(self.currentTutorial.tutorialStepData.saveOption2Id)
			if self.currentStep ~= nil then
				--TrackingUtils.SetTutorial(self.currentStep, "click_option2")
				self:SaveStep(self.currentStep + 901)
			end
			if node2 ~= nil then
				self:ShowTutorialStep(node2:GetStartNode())
			else
				self:NextTutorial()
			end
		end
		local callbackTalkSuccess = function()
			showFocus()
			self.canNextTutorial = true
		end
		if self.currentTutorial.tutorialStepData.localizeTextButton1 ~= nil or
				self.currentTutorial.tutorialStepData.localizeTextButton2 ~= nil then
			self.currentNpc = self.npcBottomLeft
		else
			if self.currentTutorial.tutorialStepData.pivot == TutorialPivot.BOTTOM_LEFT then
				self.currentNpc = self.npcBottomLeft
			elseif self.currentTutorial.tutorialStepData.pivot == TutorialPivot.BOTTOM_RIGHT then
				self.currentNpc = self.npcBottomRight
			elseif self.currentTutorial.tutorialStepData.pivot == TutorialPivot.TOP_LEFT then
				self.currentNpc = self.npcTopLeft
			elseif self.currentTutorial.tutorialStepData.pivot == TutorialPivot.TOP_RIGHT then
				self.currentNpc = self.npcTopRight
			elseif self.currentTutorial.tutorialStepData.pivot == TutorialPivot.CENTER then
				self.currentNpc = self.npcCenter
			elseif self.currentTutorial.tutorialStepData.pivot == TutorialPivot.CENTER_TOP then
				self.currentNpc = self.npcCenterTop
			end
		end
		if self.currentNpc ~= nil then
			self.currentNpc:ShowTutorial(self.currentTutorial.tutorialStepData, callbackButton1, callbackButton2, callbackTalkSuccess)
		end
	else
		showFocus()
		if self.currentNpc ~= nil then
			self.currentNpc:Hide()
		end
	end
end

--- @return void
---@param button UnityEngine_UI_Button
---@param pos UnityEngine_Transform
function UITutorialView:AddCallbackButton(button, pos, size, callback)
	UIUtils.SetInteractableButton(button, false)
	local sysPosition
    if pos.position ~= nil then
		button.transform.position = pos.position
		sysPosition = Coroutine.start(function ()
			while pos.gameObject.activeInHierarchy do
				coroutine.waitforendofframe()
				button.transform.position = pos.position
			end
		end)
	else
		button.transform.position = pos
	end
	---@type UnityEngine_RectTransform
	local rectTransform = button.gameObject:GetComponent(ComponentName.UnityEngine_RectTransform)
	rectTransform.sizeDelta = size
	button.onClick:RemoveAllListeners()
	if callback ~= nil then
		button.onClick:AddListener(function ()
			callback()
		end)
	end
	UIUtils.SetInteractableButton(button, false)
	button.gameObject:SetActive(true)
	return sysPosition
end

--- @return void
function UITutorialView:AddCallbackButton1(pos, size, callback)
	if self.sysButton1 ~= nil then
		Coroutine.stop(self.sysButton1)
	end
	self.sysButton1 = self:AddCallbackButton(self.config.button1, pos, size, callback)
end

--- @return void
function UITutorialView:AddCallbackButton2(pos, size, callback)
	if self.sysButton2 ~= nil then
		Coroutine.stop(self.sysButton2)
	end
	self.sysButton2 = self:AddCallbackButton(self.config.button2, pos, size, callback)
end

function UITutorialView.RequestTutorialSetStep(step)
	NetworkUtils.Request(OpCode.TUTORIAL_NEW_STEP_SET, UnknownOutBound.CreateInstance(PutMethod.Short , 1, PutMethod.Int, step))
	---@type TutorialInBound
	local tutorialInBound = zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL)
	tutorialInBound.listStepTutComplete:Add(step)
end

--- @return boolean
function UITutorialView:SaveStep(step,duplicateTrackingSummonTut)
	if step ~= nil and step % 1000 == 0 then
		--TrackingUtils.SetTutorial(step)
		UITutorialView.RequestTutorialSetStep(step)
		if (duplicateTrackingSummonTut ~= true or step ~= TutorialStepID.TUTORIAL_SUMMON_10) then
			TrackingUtils.TrackingTutorial(FBProperties.STEP,step)
		end
		if step == TutorialCampaign3.stepId then
			--XDebug.Log("Finish Tutorial")
			TrackingUtils.CompleteTutorial()
		end
	end
end

--- @return void
function UITutorialView:Hide()
	UIBaseView.tutorial = nil
	UIBaseView.Hide(self)
	UIUtils.SetInteractableButton(self.config.buttonBg, true)
	UIUtils.SetInteractableButton(self.config.focus, true)
	UIUtils.SetInteractableButton(self.config.buttonFocus, true)
	UIUtils.SetInteractableButton(self.config.buttonFocus2, true)
	UIUtils.SetInteractableButton(self.config.button1, true)
	UIUtils.SetInteractableButton(self.config.button2, true)
end

