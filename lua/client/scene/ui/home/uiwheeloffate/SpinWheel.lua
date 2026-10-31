--- @class SpinWheel
SpinWheel = Class(SpinWheel)

--- @return void
--- @param transform UnityEngine_Transform
function SpinWheel:Ctor(transform)
    ---@type UnityEngine_Transform
    self.transform = transform
    ---@type number
    self.timeDefault = 5
    ---@type number
    self.timeDelaySpin = 0.5
    ---@type number
    self.roundDefault = 8
    ---@type boolean
    self.isValidate = false
    ---@type number
    self.numberItem = 8
    ---@type number
    self.angleItem = 360 / self.numberItem
    ---@type boolean
    self.isSpinning = false
    ---@type number
    self.indexTarget = 0
    --- @type function
    self.callbackRotate = nil
    ---@type function
    self.callbackFinishSpin = nil
    ---@type function
    self.callbackValidate = nil

    ---@type Coroutine
    self._coroutine = nil

    local onAnimationCurveLoaded = function(dataAnimationCurve)
        ---@type UnityEngine_AnimationCurve
        self.animationCurve = dataAnimationCurve.curve[0]
    end
    ResourceLoadUtils.LoadConfig("data_animation_curve", onAnimationCurveLoaded)
end

--- @return void
function SpinWheel:SetNumberItem(number)
    self.numberItem = number
    self.angleItem = 360 / self.numberItem
end

--- @return void
function SpinWheel:Rotate(callbackFinishSpin, callbackValidate)
    self.callbackFinishSpin = callbackFinishSpin
    self.callbackValidate = callbackValidate
    if self.isSpinning == false then
        self._coroutine = Coroutine.start(function()
            self.isSpinning = true
            local isDelaySpine = false
            local localValidate = false
            local startAngle = (self.transform.eulerAngles.z % 360 + 360) % 360
            local currentAngle = 0
            local time = self.timeDefault
            local timer = 0
            local maxAngle = 360 * self.roundDefault
            ---@type UnityEngine_AnimationCurve
            local animationCurve = self.animationCurve
            local angleCheck
            while timer < time and self.isSpinning == true do
                if isDelaySpine == false then
                    currentAngle = maxAngle * animationCurve:Evaluate(timer / time) + startAngle
                    timer = timer + U_Time.deltaTime
                    if localValidate == false and timer > self.timeDelaySpin * self.timeDefault then
                        isDelaySpine = true
                    end
                else
                    currentAngle = currentAngle + maxAngle * (animationCurve:Evaluate(timer / time) - animationCurve:Evaluate((timer - U_Time.deltaTime) / time))
                    if self.isValidate == true then
                        if angleCheck == nil then
                            maxAngle = 360 * self.roundDefault + (self.indexTarget * self.angleItem) - startAngle
                            local angle = maxAngle * animationCurve:Evaluate(timer / time) + startAngle
                            local angle1 = currentAngle % 360
                            local angle2 = angle % 360
                            if angle2 >= angle1 then
                                angleCheck = currentAngle + angle2 - angle1
                            else
                                angleCheck = currentAngle + angle2 - angle1 + 360
                            end
                        end

                        if (currentAngle > angleCheck) then
                            isDelaySpine = false
                            localValidate = true
                            if self.callbackValidate ~= nil then
                                self.callbackValidate()
                            end
                        end
                    end
                end
                self.transform.eulerAngles = U_Vector3(0, 0, currentAngle)
                if self.callbackRotate ~= nil then
                    self.callbackRotate(self.transform.eulerAngles)
                end
                coroutine.waitforendofframe()
            end

            local targetZ = maxAngle + startAngle
            local target = U_Vector3(0, 0, targetZ)
            self.transform.eulerAngles = target
            if self.callbackRotate ~= nil then
                self.callbackRotate(self.transform.eulerAngles)
            end
            self.isSpinning = false
            if self.callbackFinishSpin ~= nil then
                self.callbackFinishSpin()
            end
        end)
        self._coroutine = nil
    end
end

--- @return void
function SpinWheel:Hide()
    self.isSpinning = false
    ClientConfigUtils.KillCoroutine(self._coroutine)
    self.transform.eulerAngles = U_Vector3.zero
end