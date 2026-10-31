--- @class DetailTeamFormation
DetailTeamFormation = Class(DetailTeamFormation)

--- @return void
function DetailTeamFormation:Ctor()
    --- @type number
    self.formationId = 1
    --- @type Dictionary {positionId, HeroResource}
    self.frontLineDict = Dictionary()
    --- @type Dictionary {positionId, HeroResource}
    self.backLineDict = Dictionary()
end

--- @return DetailTeamFormation
--- @param buffer UnifiedNetwork_ByteBuf
function DetailTeamFormation.CreateByBuffer(buffer)
    local data = DetailTeamFormation()
    data.formationId = buffer:GetByte()
    local size = buffer:GetByte()
    for i = 1, size do
        data.frontLineDict:Add(buffer:GetByte(), HeroResource.CreateInstanceByBuffer(buffer))
    end
    size = buffer:GetByte()
    for i = 1, size do
        data.backLineDict:Add(buffer:GetByte(), HeroResource.CreateInstanceByBuffer(buffer))
    end
    return data
end

--- @return string
function DetailTeamFormation:ToString()
    local str = "DetailTeamFormation " .. "formationId" .. self.formationId
    str = str .. "\n frontLineDict"
    for i, v in ipairs(self.frontLineDict:GetItems()) do
        str = str .. string.format("k:%s, v: %s", i, LogUtils.ToDetail(v))
    end
    str = str .. "\n backLineDict"
    for i, v in ipairs(self.backLineDict:GetItems()) do
        str = str .. string.format("k:%s, v: %s", i, LogUtils.ToDetail(v))
    end
    return str
end

--- @return DetailTeamFormation
--- @param teamData TeamFormationInBound
function DetailTeamFormation.CreateByTeamFormationInBound(teamData, listHeroResource)
    local data = DetailTeamFormation()
    data.formationId = teamData.formationId
    ---@param v HeroFormationInBound
    for _, v in pairs(teamData.backLine:GetItems()) do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId, listHeroResource)
        data.backLineDict:Add(v.positionId, heroResource)
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(teamData.frontLine:GetItems()) do
        data.frontLineDict:Add(v.positionId, InventoryUtils.GetHeroResourceByInventoryId(v.heroInventoryId, listHeroResource))
    end

    if teamData.defenseFormation ~= nil then
        --- @type FormationData
        local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(teamData.formationId)
        for i, v in pairs(teamData.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                ---@type DefenderHeroStatConfig
                local heroDefense = ResourceMgr.GetDefenseModeConfig():GetDefenderHeroStatConfig(teamData.defenseFormation.teamStat)
                if heroDefense ~= nil then
                    local heroResource = heroDefense:CreateHeroResource(v, i)
                    if formationData.frontLine >= i then
                        data.frontLineDict:Add(i, heroResource)
                    else
                        data.backLineDict:Add(i - formationData.frontLine, heroResource)
                    end
                else
                    XDebug.Warning("NIL DefenderHeroStatConfig " .. v)
                end
            end
        end
    end

    return data
end

--- @return HeroResource
--- @param isFrontLine boolean
--- @param positionId number
function DetailTeamFormation:GetHeroResourceByPosition(isFrontLine, positionId)
    --- @type Dictionary
    local lineDict
    --- @type HeroResource
    local heroResource
    if isFrontLine then
        lineDict = self.frontLineDict
    else
        lineDict = self.backLineDict
    end
    if lineDict ~= nil then
        if lineDict:IsContainKey(positionId) then
            heroResource = lineDict:Get(positionId)
        end
    end
    return heroResource
end

--- @param heroResource HeroResource
--- @param isFrontLine boolean
--- @param positionId number
function DetailTeamFormation:SetHeroResourceByPosition(heroResource, isFrontLine, positionId)
    if isFrontLine == true then
        if heroResource ~= nil then
            self.frontLineDict:Add(positionId, heroResource)
        else
            self.frontLineDict:RemoveByKey(positionId)
        end
    else
        if heroResource ~= nil then
            self.backLineDict:Add(positionId, heroResource)
        else
            self.backLineDict:RemoveByKey(positionId)
        end
    end
end