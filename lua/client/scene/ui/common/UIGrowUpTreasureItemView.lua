
--- @class UIGrowUpTreasureItemView : MotionIconView
UIGrowUpTreasureItemView = Class(UIGrowUpTreasureItemView, MotionIconView)

--- @return void
function UIGrowUpTreasureItemView:Ctor()
    ---@type QuestUnitInBound
    self.questUnit = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIGrowUpTreasureItemView:SetPrefabName()
    self.prefabName = 'new_server_grow_up_treasure_item'
    self.uiPoolType = UIPoolType.UIGrowUpTreasureItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIGrowUpTreasureItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UITreasureItemConfig
    self.config = UIBaseConfig(transform)

end

---@param questUnit QuestUnitInBound
function UIGrowUpTreasureItemView:SetData(questUnit ,callbackSelect)
    if callbackSelect ~= nil then
        self.callbackSelect = callbackSelect
    end
    self.questUnit = questUnit;
    self.config.textQuestContent.text = string.format(LanguageUtils.LocalizeCommon("reach_level"),
            self.questUnit.config:GetRequirements():Get(1))
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.callbackSelect ~= nil then
            self.callbackSelect()
        end
    end)
    self:UpdateState()
end

function UIGrowUpTreasureItemView:UpdateState()
    self.config.arrow:SetActive(false)
    self.config.lock:SetActive(false)
    self.config.canClaim:SetActive(false)
    self.config.claimed:SetActive(false)
    self.config.arrow:SetActive(self.questUnit.isCurrentDoing)
    if self.questUnit.questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.canClaim:SetActive(true)
    elseif self.questUnit.questState == QuestState.COMPLETED then
        self.config.claimed:SetActive(true)
    else
        self.config.lock:SetActive(true)
    end
end
return UIGrowUpTreasureItemView