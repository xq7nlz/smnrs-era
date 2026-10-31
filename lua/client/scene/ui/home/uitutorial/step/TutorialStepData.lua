
--- @class TutorialStepData
TutorialStepData = Class(TutorialStepData)

--- @return void
function TutorialStepData:Ctor()
    ---@type string
    self.text = nil
    ---@type TutorialStep
    self.step = nil
    ---@type TutorialFocus
    self.focus = nil
    ---@type TutorialPivot
    self.pivot = nil
    ---@type OpCode
    self.waitOpCode = nil
    ---@type function
    self.localizeTextButton1 = nil
    ---@type function
    self.localizeTextButton2 = nil
    ---@type number
    self.saveStepId = nil
    ---@type number
    self.saveContinueId = nil
    ---@type number
    self.saveOption1Id = nil
    ---@type number
    self.saveOption2Id = nil
    ---@type number
    self.delay = nil
    ---@type boolean
    self.showNpc = false
    ---@type boolean
    self.hideFocus = false
    ---@type boolean
    self.showTargetFocus = false
    ---@type function
    self.localizeText = nil
    ---@type string
    self.trackingName = nil
    ---@type number
    self.trackingID = nil
    ---@type Subscription
    self.subscriptionOpcode = nil
    ---@type function
    self.callback = nil
end

--- @return void
---@param callback function
function TutorialStepData:SubscriptionOpcode(callback)
    if callback ~= nil then
        if self.subscriptionOpcode ~= nil then
            self.subscriptionOpcode:Unsubscribe()
            self.subscriptionOpcode = nil
        end

        self.subscriptionOpcode = RxUtils.WaitOfCode(self.waitOpCode)
                                         :Subscribe(function ()
            callback()
            self.subscriptionOpcode:Unsubscribe()
            self.subscriptionOpcode = nil
        end)
    end
end

--- @return TutorialStepData
---@param callback function
function TutorialStepData:SetOnFinishStep(callback)
    self.callback = callback
    return self
end

--- @return TutorialStepData
---@param active boolean
function TutorialStepData:ShowNpc(active)
    self.showNpc = active
    return self
end

--- @return TutorialStepData
---@param active boolean
function TutorialStepData:ShowTargetFocus(active)
    self.showTargetFocus = active
    return self
end

--- @return TutorialStepData
---@param hide boolean
function TutorialStepData:HideFocus(hide)
    self.hideFocus = hide
    return self
end

--- @return TutorialStepData
---@param waitOpCode OpCode
function TutorialStepData:WaitOpCode(waitOpCode)
    self.waitOpCode = waitOpCode
    return self
end

--- @return TutorialStepData
function TutorialStepData:Text(text)
    self.text = text
    return self
end

--- @return TutorialStepData
function TutorialStepData:KeyLocalize(npc)
    self.localizeText = function()
        return LanguageUtils.LocalizeTutorial(npc)
    end
    return self
end

--- @return TutorialStepData
function TutorialStepData:GetTextMethod(method)
    self.localizeText = method
    return self
end

--- @return TutorialStepData
--- @param localizeText function
function TutorialStepData:SetLocalizeText(localizeText)
    self.localizeText = localizeText
    return self
end

--- @return TutorialStepData
function TutorialStepData:Step(step)
    self.step = step
    return self
end

--- @return TutorialStepData
function TutorialStepData:Focus(focus)
    self.focus = focus
    return self
end

--- @return TutorialStepData
function TutorialStepData:Pivot(pivot)
    self.pivot = pivot
    return self
end

--- @return TutorialStepData
function TutorialStepData:Text1(textButton1)
    self.localizeTextButton1 = function()
        return LanguageUtils.LocalizeTutorial(textButton1)
    end
    return self
end

--- @return TutorialStepData
function TutorialStepData:Text2(textButton2)
    self.localizeTextButton2 = function()
        return LanguageUtils.LocalizeTutorial(textButton2)
    end
    return self
end

--- @return TutorialStepData
function TutorialStepData:StepId(saveStepId)
    self.saveStepId = saveStepId
    return self
end

--- @return TutorialStepData
function TutorialStepData:ContinueStepId(saveContinueId)
    self.saveContinueId = saveContinueId
    return self
end

--- @return TutorialStepData
function TutorialStepData:Option1Id(saveOption1Id)
    self.saveOption1Id = saveOption1Id
    return self
end

--- @return TutorialStepData
function TutorialStepData:Option2Id(saveOption2Id)
    self.saveOption2Id = saveOption2Id
    return self
end

--- @return TutorialStepData
function TutorialStepData:Delay(delay)
    self.delay = delay
    return self
end

--- @return TutorialStepData
function TutorialStepData:TrackingName(name)
    self.trackingName = name
    return self
end

--- @return TutorialStepData
function TutorialStepData:TrackingID(id)
    self.trackingID = id
    return self
end

--- @return boolean
function TutorialStepData:IsContainTextNpc()
    if self.localizeText ~= nil then
        self:Text(self.localizeText())
        return true
    else
        return false
    end
end

---@type TutorialStepData
---@param npc string
---@param step TutorialStep
---@param focus TutorialFocus
---@param textButton1 string
---@param textButton2 string
---@param saveStepId number
---@param saveOption1Id number
---@param saveOption2Id number
---@param delay number
function TutorialStepData.Create(npc, step, focus, textButton1, textButton2, saveStepId, saveOption1Id, saveOption2Id, delay)
    ---@type TutorialStepData
    local tutorialStepData = TutorialStepData()
    tutorialStepData.text = npc
    tutorialStepData.step = step
    tutorialStepData.focus = focus
    tutorialStepData.localizeTextButton1 = textButton1
    tutorialStepData.localizeTextButton2 = textButton2
    tutorialStepData.saveStepId = saveStepId
    tutorialStepData.saveOption1Id = saveOption1Id
    tutorialStepData.saveOption2Id = saveOption2Id
    tutorialStepData.delay = delay
    return tutorialStepData
end