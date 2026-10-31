--- @class ProgressBarView : IconView
ProgressBarView = Class(ProgressBarView, UIPrefabView)

SIZE_BAR_DEFAULT = U_Vector2(634,32)

--- @return void
function ProgressBarView:SetPrefabName()
    self.prefabName = 'progress_bar'
    self.uiPoolType = UIPoolType.ProgressBarView
end

--- @return void
--- @param transform UnityEngine_Transform
function ProgressBarView:SetConfig(transform)
    ---@type ProgressBarConfig
    self.config = UIBaseConfig(transform)
end

--- @param data
function ProgressBarView:SetData(data)
    self:SetProgressValue(data.progressValue, data.maxProgressValue)
    self:SetBarSize(data.sizeDelta)
    self:SetResourceIcon(data.iconData)
end

--- @param scale UnityEngine_Vector2
function ProgressBarView:SetBarSize(sizeDelta)
    if sizeDelta == nil then
        return
    end
    self.config.progressBarContainer.sizeDelta = sizeDelta
end

function ProgressBarView:SetProgressValue(progressValue, maxProgressValue)
    if progressValue == nil or maxProgressValue == nil then
        return
    end
    local ratioProgress = progressValue / maxProgressValue
    self.config.textProgress.text = string.format("%d/%d", progressValue, maxProgressValue)
    self.config.progressBarGreen.gameObject:SetActive(true)
    self.config.progressBarGreen.fillAmount = ratioProgress
end

function ProgressBarView:SetResourceIcon(iconData)
    self.config.imageResource.sprite = ResourceLoadUtils.LoadMoneyIcon(iconData.itemId)
end

function ProgressBarView:ReturnPool()
    self:SetBarSize(SIZE_BAR_DEFAULT)
    UIPrefabView.ReturnPool(self)
end

return ProgressBarView


