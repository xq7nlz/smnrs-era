--- @class ButtonCommunity
ButtonCommunity = Class(ButtonCommunity)

function ButtonCommunity:Ctor(anchor)
    --- @type ButtonCommunityConfig
    self.config = UIBaseConfig(anchor)
end

function ButtonCommunity:AddOnClickListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

function ButtonCommunity:SetText(text)
    self.config.textCommunity.text = text
end

function ButtonCommunity:EnableNotify(isEnable)
    self.config.notify:SetActive(isEnable)
end

function ButtonCommunity:SetIcon(sprite)
    self.config.icon.sprite = sprite
    --self.config.icon:SetNativeSize()
end

