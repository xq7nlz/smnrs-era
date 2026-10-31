---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiTutorial.UITutorialNpcConfig"

--- @class UITutorialNpcView
UITutorialNpcView = Class(UITutorialNpcView)

--- @return void
function UITutorialNpcView:Ctor(transform)
    ---@type UITutorialNpcConfig
    self.config = UIBaseConfig(transform)
    self.position = self.config.skeletonGraphic.transform.position
    ---@type TutorialStepData
    self.tutorialStepData = nil
    self.callbackTalkSuccess = nil
    self.canSkipNpc = false
end

--- @return void
---@param data TutorialStepData
function UITutorialNpcView:ShowTutorial(data, callbackClick1, callbackClick2, callbackTalkSuccess)
    self.tutorialStepData = data
    self.callbackTalkSuccess = callbackTalkSuccess
    self.canSkipNpc = false
    self.config.tap:SetActive(true)
    self.config.skeletonGraphic.gameObject:SetActive(data.showNpc)

    self:Clear()

    self.coroutine = Coroutine.start(function()
        self.config.button1.transform.parent.gameObject:SetActive(false)
        self.config.skeletonGraphic.transform.position = U_Vector3(-10000, -10000, 0)
        self.config.gameObject:SetActive(true)

        self.config.horizontal.transform.position = U_Vector3(10000, 10000, 0)
        self.config.textChat.text = data.text
        self.config.sizeFilter.enabled = true
        self.config.horizontal.enabled = true
        --self.config.vertical.enabled = true

        coroutine.waitforendofframe()

        self.config.skeletonGraphic.transform.position = self.position
        local animationStartFinish = false
        if self.config.skeletonGraphic.AnimationState ~= nil then
            if data.pivot == TutorialPivot.CENTER then
                if data.showNpc == true then
                    if self.config.skeletonGraphic.AnimationState ~= nil then
                        self.config.skeletonGraphic.AnimationState:ClearTracks()
                    end
                    if self.config.skeletonGraphic.Skeleton ~= nil then
                        self.config.skeletonGraphic.Skeleton:SetToSetupPose()
                    end
                    self.config.skeletonGraphic.AnimationState:SetAnimation(0, "start", false)
                    self.config.skeletonGraphic.AnimationState:AddAnimation(0, "idle", true, 0)
                    self.config.effectStart:SetActive(true)
                    coroutine.waitforendofframe()
                    coroutine.waitforseconds(2)
                    --self.config.skeletonGraphic.AnimationState:SetAnimation(1, "talk", true)
                end
                animationStartFinish = true
            else
                animationStartFinish = true
                if data.showNpc == true then
                    --self.config.skeletonGraphic.AnimationState:SetAnimation(1, "talk", true)
                    if self.config.skeletonGraphic.AnimationState:GetCurrent(0) == nil then
                        self.config.skeletonGraphic.AnimationState:SetAnimation(0, "idle", true)
                        self.config.effectIdle:SetActive(true)
                    end
                end
            end
        else
            animationStartFinish = true
        end

        while animationStartFinish == false do
            coroutine.waitforendofframe()
        end

        self.config.sizeFilter.enabled = false
        self.config.horizontal.enabled = false
        --self.config.vertical.enabled = false
        ---@type UnityEngine_Transform
        local transformBox = self.config.vertical.transform
        self.config.horizontal.transform.localPosition = U_Vector3.zero
        self.config.textChat.text = ""
        transformBox.localScale = U_Vector3(0.8, 0.8, 0.8)

        local showText = function()
            self.coroutineText = Coroutine.start(function()
                local time = string.len(data.text) * 0.015
                self.mySequence = CS.DG.Tweening.DOTween.Sequence()
                self.mySequence:Append(self.config.textChat:DOText(data.text, time))
                coroutine.waitforseconds(time)
                self:Finish()
            end)
        end
        DOTweenUtils.DOScale(transformBox, U_Vector3(1, 1, 1), 0.5, U_Ease.OutBounce, function()
            showText()
            self.canSkipNpc = true
        end)
    end)

    if data.localizeTextButton1 ~= nil and callbackClick1 ~= nil then
        self.config.button1.gameObject:SetActive(true)
        self.config.textButton1.text = data.localizeTextButton1()
        self.config.button1.onClick:RemoveAllListeners()
        self.config.button1.onClick:AddListener(function()
            callbackClick1()
        end)
    else
        self.config.button1.gameObject:SetActive(false)
    end
    if data.localizeTextButton2 ~= nil and callbackClick2 ~= nil then
        self.config.button2.gameObject:SetActive(true)
        self.config.textButton2.text = data.localizeTextButton2()
        self.config.button2.onClick:RemoveAllListeners()
        self.config.button2.onClick:AddListener(function()
            callbackClick2()
        end)
    else
        self.config.button2.gameObject:SetActive(false)
    end
end

--- @return void
function UITutorialNpcView:SkipNpc()
    if self.canSkipNpc == true then
        self:Clear()
        self:Finish()
        self.canSkipNpc = false
    end
end

--- @return void
function UITutorialNpcView:Clear()
    ClientConfigUtils.KillCoroutine(self.coroutine)
    ClientConfigUtils.KillCoroutine(self.coroutineText)

    if self.mySequence ~= nil then
        self.mySequence:Kill()
        self.mySequence = nil
    end
end

--- @return void
function UITutorialNpcView:Finish()
    if self.tutorialStepData.focus == TutorialFocus.FOCUS_CLICK
            or self.tutorialStepData.focus == TutorialFocus.DRAG
            or self.tutorialStepData.localizeTextButton1 ~= nil
            or self.tutorialStepData.localizeTextButton2 ~= nil then
        self.config.tap:SetActive(false)
    end
    self.config.textChat.text = self.tutorialStepData.text
    if self.callbackTalkSuccess ~= nil and self.config.gameObject.activeInHierarchy then
        self.callbackTalkSuccess()
    end
    self.config.button1.transform.parent.gameObject:SetActive(true)
end

--- @return void
function UITutorialNpcView:Hide()
    self.config.gameObject:SetActive(false)
end