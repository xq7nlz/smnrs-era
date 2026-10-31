--- @class SkinChallengeNodeView : MotionIconView
SkinChallengeNodeView = Class(SkinChallengeNodeView, MotionIconView)

function SkinChallengeNodeView:Ctor(transform)
    MotionIconView.Ctor(self, transform)
end

--- @return void
function SkinChallengeNodeView:SetPrefabName()
    self.prefabName = 'skin_challenge_icon_node'
    self.uiPoolType = UIPoolType.UIEventSkinChallengeNodeView
end

--- @return void
--- @param transform UnityEngine_Transform
function SkinChallengeNodeView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type SkinChallengeNodeConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param transform UnityEngine_Transform
function SkinChallengeNodeView:SetData(data)
    self:SetState(data.rewardState)
    self.config.lineAnchor.gameObject:SetActive(false)
    self.config.textNode.text = tostring(data.dayId)

    if data.lineAngles ~= nil then
        self.config.lineAnchor.gameObject:SetActive(true)
        self.config.lineAnchor.localEulerAngles = data.lineAngles
    end
end

function SkinChallengeNodeView:AddListener(func)
    self.config.buttonNode.onClick:RemoveAllListeners()
    self.config.buttonNode.onClick:AddListener(function()
        func()
    end)
end

function SkinChallengeNodeView:SetState(rewardState)
    self:SetDefaultState()
    if rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM then
        UIUtils.SetActiveColorDisable(self.config.gameObject, false)
    elseif rewardState == RewardState.AVAILABLE_TO_CLAIM then
        self.config.noti:SetActive(true)
        UIUtils.SetActiveColorDisable(self.config.gameObject, true)
    elseif rewardState == RewardState.CLAIMED then
        self.config.textNode.gameObject:SetActive(false)
        UIUtils.SetActiveColorDisable(self.config.gameObject, false)
        self:ActiveTickSelect(true, U_Vector2(183, 158))
    else
        UIUtils.SetActiveColorDisable(self.config.gameObject, true)
    end
end

function SkinChallengeNodeView:SetDefaultState()
    self.config.noti:SetActive(false)
    UIUtils.SetActiveColorDisable(self.config.gameObject, false)
    self:ActiveMaskSelect(false)
    self:ActiveTickSelect(false)
    self.config.textNode.gameObject:SetActive(true)
end

