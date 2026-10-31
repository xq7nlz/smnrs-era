--- @class BattleRewardChest
BattleRewardChest = Class(BattleRewardChest)

function BattleRewardChest:Ctor(anchor)
    --- @type BattleRewardChestConfig
    self.config = UIBaseConfig(anchor)
end

function BattleRewardChest:OnShow(pos, fallPos, flyPos, onClick)
    self.config.transform.position = pos

    self.fallPos = fallPos
    self.flyPos = flyPos

    self.config.gameObject:SetActive(true)
    self.onClick = onClick

    self:DoFall()
end

function BattleRewardChest:DoFall()
    self:UpdateLayer(self.fallPos.y)
    self.config.bone9.position = self.config.transform.position
    self.config.move.position = self.fallPos

    self.config.anim.AnimationState:SetAnimation(0, "Chest_fall", false)
    local trackEntry = self.config.anim.AnimationState:SetAnimation(0, "Chest_fall", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.config.anim.AnimationState:SetAnimation(1, "idle", true)
    end)

    Coroutine.start(function ()
        coroutine.waitforseconds(3)
        self:OnClick()
    end)
end

function BattleRewardChest:OnClick()
    self.config.bone9.position = self.flyPos

    local trackEntry = self.config.anim.AnimationState:SetAnimation(1, "Chest_fly", false)
    trackEntry:AddCompleteListenerFromLua(function()
        if self.onClick then
            self.onClick()
        end
        self:OnHide()
    end)
end

function BattleRewardChest:OnHide()
    self.onClick = nil
end

function BattleRewardChest:UpdateLayer(posY)
    self.config.meshRenderer.sortingOrder = ClientConfigUtils.CalculateBattleLayer(posY, 0)
end