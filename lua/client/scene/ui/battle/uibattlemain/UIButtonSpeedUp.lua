--- @class UIButtonSpeedUp
UIButtonSpeedUp = Class(UIButtonSpeedUp)

function UIButtonSpeedUp:Ctor(transform, speedScale)
    --- @type UIButtonSpeedUpConfig
    self.config = UIBaseConfig(transform)
    self:SetSpeedScale(speedScale)
end

function UIButtonSpeedUp:SetSpeedScale(speedScale)
    self.config.textSpeed.text = "x" .. speedScale
end

function UIButtonSpeedUp:AddOnClickListener(listener)
    self.config.buttonSpeedUp.onClick:RemoveAllListeners()
    self.config.buttonSpeedUp.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

--- @param isEnable boolean
function UIButtonSpeedUp:EnableState(isEnable)
    self.config.effectOn.gameObject:SetActive(isEnable)
end