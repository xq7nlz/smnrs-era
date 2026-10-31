--- @class UIHeroSummonTabItem
UIHeroSummonTabItem = Class(UIHeroSummonTabItem)


--- @param transform UnityEngine_Transform
function UIHeroSummonTabItem:Ctor(transform, tabIndex, callback)
    --- @type UIHeroSummonTabItemConfig
    self.config = UIBaseConfig(transform)
    self.tabIndex = tabIndex
    self:SetListener(callback)
end

--- @param listener function
function UIHeroSummonTabItem:SetListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener(self.tabIndex)
    end)
end

function UIHeroSummonTabItem:SetTabState(isChoose)
    self.config.chooseImage.gameObject:SetActive(isChoose)
end

return UIHeroSummonTabItem