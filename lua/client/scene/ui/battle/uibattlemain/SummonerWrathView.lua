---COMMENT_CONFIG    require "lua.client.scene.ui.battle.uiBattleMain.SummonerWrathViewConfig"

--- @class SummonerWrathView
SummonerWrathView = Class(SummonerWrathView)
local _tweenDuration = 0.15
local _maxPowerLevel = 5

function SummonerWrathView:Ctor(transform)
    --- @type SummonerWrathViewConfig
    ---@type SummonerWrathViewConfig
    self.config = UIBaseConfig(transform)
    self.config.gameObject:SetActive(true)
    --- @type DG_Tweening_Tweener
    self._tweenPower = nil
    --- @type number
    self.levelPower = 0
end

--- @param spriteAvatar UnityEngine_Sprite
function SummonerWrathView:SetAvatar(spriteAvatar)
    self.config.avatar.sprite = spriteAvatar
end

--- @param powerDataAmount number
function SummonerWrathView:SetPowerData(powerDataAmount, useTween)
    ClientConfigUtils.KillTweener(self._tweenPower)

    local progressVolume = 1 / _maxPowerLevel
    local currentFillAmount = self.config.wrathBarProgress.fillAmount
    local newLevelPower = math.floor(powerDataAmount / progressVolume)
    local newFillAmount = (powerDataAmount - (progressVolume * newLevelPower)) / progressVolume

    if useTween == true then
        if newLevelPower == self.levelPower then
            self._tweenPower = DOTweenUtils.DOFillAmount(self.config.wrathBarProgress, newFillAmount, _tweenDuration, function ()
                self.config.burstEffect:SetActive(powerDataAmount >= 1)
                self._tweenPower = nil
            end)
        else
            local tweenTime = _tweenDuration
            if newFillAmount < currentFillAmount then
                tweenTime = _tweenDuration / 2
            end
            self._tweenPower = DOTweenUtils.DOFillAmount(self.config.wrathBarProgress, 1, tweenTime, function ()
                if newFillAmount < 1 and newLevelPower < _maxPowerLevel then
                    ClientConfigUtils.KillTweener(self._tweenPower)
                    self.config.wrathBarProgress.fillAmount = 0

                    self._tweenPower = DOTweenUtils.DOFillAmount(self.config.wrathBarProgress, newFillAmount, tweenTime, function ()
                        self.config.burstEffect:SetActive(powerDataAmount >= 1)
                        self._tweenPower = nil
                    end)
                else
                    self.config.burstEffect:SetActive(powerDataAmount >= 1)
                    self._tweenPower = nil
                end
            end)
        end
    else
        self.config.wrathBarProgress.fillAmount = newFillAmount
        self.config.burstEffect:SetActive(powerDataAmount >= 1)
    end
    self:EnablePowerBurning(newLevelPower)
    self.levelPower = newLevelPower
end

--- @param level number
function SummonerWrathView:EnablePowerBurning(level)
    local childCount = self.config.powerBurning.childCount
    for i = 1, childCount do
        --- @type UnityEngine_Transform
        local child = self.config.powerBurning:GetChild(i - 1)
        child:GetChild(0).gameObject:SetActive(i <= level)
    end
end