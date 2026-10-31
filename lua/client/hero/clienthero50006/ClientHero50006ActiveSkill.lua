--- @class ClientHero50006ActiveSkill : BaseSkillShow
ClientHero50006ActiveSkill = Class(ClientHero50006ActiveSkill, BaseSkillShow)

function ClientHero50006ActiveSkill:DeliverCtor()
    self.fxImpactName = "impact_water"
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    --- @type ClientTurnDetail
    self.currentTurnDetail = nil

    --- @type Dictionary
    self.projectileIdDict = nil
    --- @type Dictionary
    self.nextProjectileTargetId = nil

    --- @type Dictionary
    self.triggeredActionResultDict = Dictionary()
end

function ClientHero50006ActiveSkill:OnEndTurn()
    if self.currentTurnDetail == nil then
        self.clientHero:FinishActionTurn()
    end
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero50006ActiveSkill:SetClientTurnDetail(clientTurnDetail)
    self.currentTurnDetail = clientTurnDetail
    local clientActionType = clientTurnDetail.actionType

    if self.listTargetHero:Count() > 0 then
        BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    end

    self:GetListTargetFromActions(clientTurnDetail.actionList)

    if clientActionType == ClientActionType.USE_SKILL then

        self.triggeredActionResultDict = Dictionary()

        self:DoAnimation()

        self:CreateProjectileIdDict(clientTurnDetail.actionList)

        self:DoCoverBattle(1.5, 1.5, 0.3)
    elseif clientActionType == ClientActionType.BOUNCING_DAMAGE then
        self:DoBouncing(clientTurnDetail)

        self:DoCoverBattle(0.5, 0, 0)
    end
end

--- @par listBaseActionResult List
function ClientHero50006ActiveSkill:CreateProjectileIdDict(listBaseActionResult)
    self.projectileIdDict = Dictionary()

    self.nextProjectileTargetId = Dictionary()

    for i = 1, self.listTargetHero:Count() do
        local projectile = self:GetMoreProjectileById(i)
        projectile:SetActive(false)
        self.nextProjectileTargetId:Add(i, self.listTargetHero:Get(i))
    end
end

function ClientHero50006ActiveSkill:GetMoreProjectileById(projectileId)
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
    self.projectileIdDict:Add(projectileId, projectile)
    return projectile
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero50006ActiveSkill:DoBouncing(clientTurnDetail)
    self.nextProjectileTargetId = Dictionary()

    for i = 1, clientTurnDetail.actionList:Count() do
        --- @type BouncingDamageResult
        local bouncingDamageResult = clientTurnDetail.actionList:Get(i)
        if bouncingDamageResult.type == ActionResultType.BOUNCING_DAMAGE then
            local projectileId = bouncingDamageResult.bouncingId
            local target = bouncingDamageResult.target

            self.nextProjectileTargetId:Add(projectileId, target)
            local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(target)
                                         .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
            --- @type ClientEffect
            local projectile = self.projectileIdDict:Get(projectileId)
            if projectile then
                projectile:DoMoveTween(bounceToPosition, 0.5, function()
                    self:OnTriggerActionResult(clientTurnDetail.clientTurn)
                end)
            end
        end
    end

    --- @param v ClientEffect
    for k, v in pairs(self.projectileIdDict:GetItems()) do
        if self.nextProjectileTargetId:IsContainKey(k) == false then
            v:ReturnPool()
            self.projectileIdDict:RemoveByKey(k)
        end
    end
end

--- @param clientTurn number
function ClientHero50006ActiveSkill:OnTriggerActionResult(clientTurn)
    --print("OnTriggerActionResult  ", clientTurn)
    if self.triggeredActionResultDict:IsContainKey(clientTurn) then
        --print("Already ")
        if self.currentTurnDetail ~= nil then
            local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
            local clientActionType = self.currentTurnDetail.actionType
            --print("extraTurnInfo ", LogUtils.ToDetail(extraTurnInfo))
            if clientActionType == ClientActionType.BOUNCING_DAMAGE then
                extraTurnInfo = self.currentTurnDetail.extraTurnInfo
                if extraTurnInfo.numberBonusTurn == 0 then
                    self:ReleaseProjectile()
                end
            elseif clientActionType == ClientActionType.USE_SKILL then
                extraTurnInfo = self.currentTurnDetail.extraTurnInfo
                if extraTurnInfo == nil then
                    self.currentTurnDetail = nil
                    self:ReleaseProjectile()
                end
            end
        else
            self:ReleaseProjectile()
        end
        return
    end
    self.triggeredActionResultDict:Add(clientTurn, true)
    BaseSkillShow.OnTriggerActionResult(self)
    local clientActionType = self.currentTurnDetail.actionType
    if clientActionType == ClientActionType.BOUNCING_DAMAGE then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo.numberBonusTurn == 0 then
            self:ReleaseProjectile()
        end
        self.clientHero:FinishActionTurn()
    elseif clientActionType == ClientActionType.USE_SKILL then
        local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
        if extraTurnInfo ~= nil then
            self.clientHero:FinishActionTurn()
        else
            self.currentTurnDetail = nil
            self:ReleaseProjectile()
        end
    end
end

function ClientHero50006ActiveSkill:OnCastEffect()
    if self.currentTurnDetail ~= nil then
        local clientTurn = self.currentTurnDetail.clientTurn

        --- @param v BaseHero
        for k, v in pairs(self.nextProjectileTargetId:GetItems()) do
            --- @type ClientEffect
            local projectile = self.projectileIdDict:Get(k)
            local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(v)
                                         .components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
            projectile:SetPosition(self.projectileLaunchPos.position)
            projectile:Play()
            projectile:DoMoveTween(bounceToPosition, 0.5, function()
                self:OnTriggerActionResult(clientTurn)
            end)
        end
    end
end

--- @param killAction boolean
function ClientHero50006ActiveSkill:ReleaseProjectile(killAction)
    if self.projectileIdDict ~= nil then
        --- @param v ClientEffect
        for _, v in pairs(self.projectileIdDict:GetItems()) do
            if killAction then
                v:KillAction()
                v:ReturnPool()
            else
                v:Release()
            end
        end
        self.projectileIdDict:Clear()
    end

    if self.nextProjectileTargetId ~= nil then
        self.nextProjectileTargetId:Clear()
    end

    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
end