--- @class ToggleView
ToggleView = Class(ToggleView)

--- @param anchor UnityEngine_Transform
function ToggleView:Ctor(anchor, onClick, localizeFunc)
    --- @type  ToggleConfig
    self.config = UIBaseConfig(anchor)
    --- @type function
    self.onClick = onClick
    --- @type function
    self.updateLocalizeFunction = localizeFunc

    self.config.toggle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClick then
            self.onClick()
        end
    end)
end

function ToggleView:OnShow(stateDefault)
    self:SetState(stateDefault)

    self:UpdateLocalize()
end

function ToggleView:SetState(isEnable)
    self.config.iconTick:SetActive(isEnable)
end

function ToggleView:UpdateLocalize()
    if self.updateLocalizeFunction then
        self.config.textContent.text = self.updateLocalizeFunction()
    end
end

function ToggleView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end