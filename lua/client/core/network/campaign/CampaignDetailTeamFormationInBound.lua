--- @class CampaignDetailTeamFormationInBound
CampaignDetailTeamFormationInBound = Class(CampaignDetailTeamFormationInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function CampaignDetailTeamFormationInBound:ReadBuffer(buffer)
    --- @type boolean
    self.hasDetailTeamFormation = buffer:GetBool()
    --- @type DetailTeamFormation
    self.detailTeamFormation = nil
    if self.hasDetailTeamFormation == true then
        self.detailTeamFormation = DetailTeamFormation.CreateByBuffer(buffer)
    end
end

--- @param uiFormationTeamData UIFormationTeamData
function CampaignDetailTeamFormationInBound:UpdateCampaignTeamFormation(uiFormationTeamData)
    self.hasDetailTeamFormation = true
    self.detailTeamFormation = DetailTeamFormation()
    self.detailTeamFormation.formationId = uiFormationTeamData.formationId
    for i = 1, uiFormationTeamData.heroList:Count() do
        local isFrontLine = uiFormationTeamData.heroList:Get(i).isFrontLine
        local pos = uiFormationTeamData.heroList:Get(i).position
        local heroResource = uiFormationTeamData.heroList:Get(i).heroResource
        if isFrontLine == true then
            self.detailTeamFormation.frontLineDict:Add(pos, heroResource)
        else
            self.detailTeamFormation.backLineDict:Add(pos, heroResource)
        end
    end
end

--- @param callback function
function CampaignDetailTeamFormationInBound.Validate(callback, showWaiting)
    local inBound = zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION)
    if inBound == nil then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION }, callback, SmartPoolUtils.LogicCodeNotification, showWaiting)
    else
        callback()
    end
end