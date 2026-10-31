--- @class SkinSelectItemView
SkinSelectItemView = Class(SkinSelectItemView)

--- @return void
function SkinSelectItemView:Ctor(transform)
    self.id = nil
    self.skinId = nil
    self.dataId = nil
    self:SetConfig(transform)
end

--- @return void
--- @param transform UnityEngine_Transform
function SkinSelectItemView:SetConfig(transform)
    if transform == nil then
        XDebug.Error("SkinSelectItemView => transform is nil")
    end
    ---@type SkinChallengeSelectItem
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param moneyType MoneyType
function SkinSelectItemView:SetIconData(id,skinId,dataId,onSelect)
    self.id = id
    self.skinId = skinId
    self.dataId = dataId
    self.config.iconImage.sprite = ResourceLoadUtils.LoadSkinChallengeImage(self.skinId,self.dataId)
    self.config.iconImage:SetNativeSize()
    self.config.textSkinName.text = LanguageUtils.LocalizeSkinName(self.skinId)
    self:AddListener(onSelect)
end


--- @return void
function SkinSelectItemView:RemoveListener()
    self.config.selectButton.onClick:RemoveAllListeners()
end

--- @return void
---@param func function
function SkinSelectItemView:AddListener(func)
    self:RemoveListener()
    self.config.selectButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func(self.id)
        end
    end)
end

--- @return void
function SkinSelectItemView:UpdateView()

end

return SkinSelectItemView

