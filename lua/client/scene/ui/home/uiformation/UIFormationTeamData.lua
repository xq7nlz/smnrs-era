--- @class UIFormationTeamData
UIFormationTeamData = Class(UIFormationTeamData)

--- @return void
--- @param formationId number
--- @param heroList List
function UIFormationTeamData:Ctor(summonerId, formationId, heroList)
    --- @type number
    self.summonerId = summonerId
    --- @type number
    self.formationId = formationId
    --- @type List -- {heroResource:HeroResource, isFrontLine : boolean, position:number}
    self.heroList = heroList
end

--- @return string
function UIFormationTeamData:ToString()
    local str = string.format("formation: %d\n", self.formationId)
    for i, v in ipairs(self.heroList:GetItems()) do
        str = str .. LogUtils.ToDetail(v) .. "\n"
    end
    return str
end

--- @return UIFormationTeamData
--- @param team BattleTeamInfo
function UIFormationTeamData.CreateByBattleTeamInfo(team)
    local heroList = List()
    --- @param hero HeroBattleInfo
    for i, hero in ipairs(team.listHeroInfo:GetItems()) do
        local heroResource = HeroResource.CreateInstanceByHeroBattleInfo(hero)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = hero.isFrontLine, ['position'] = hero.position})
    end
    return UIFormationTeamData(team.summonerBattleInfo.summonerId, team.formation, heroList)
end

--- @return UIFormationTeamData
--- @param team TeamFormationInBound
function UIFormationTeamData.CreateByTeamFormationInBound(team, listHeroResource)
    local heroList = List()
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.frontLine:GetItems()) do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(hero.heroInventoryId, listHeroResource)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = true, ['position'] = hero.positionId})
    end
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.backLine:GetItems()) do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(hero.heroInventoryId, listHeroResource)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = false, ['position'] = hero.positionId})
    end
    if team.defenseFormation ~= nil then
        --- @type FormationData
        local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(team.formationId)
        for i, v in pairs(team.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                ---@type DefenderHeroStatConfig
                local heroDefense = ResourceMgr.GetDefenseModeConfig():GetDefenderHeroStatConfig(v)
                if heroDefense ~= nil then
                    local heroResource = heroDefense:CreateHeroResource(v, i)
                    local isFrontLine = formationData.frontLine >= i
                    local position = i
                    if isFrontLine == false then
                        position = i - formationData.frontLine
                    end
                    heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = isFrontLine, ['position'] = position})
                end
            end
        end
    end
    return UIFormationTeamData(team.summonerId, team.formationId, heroList)
end

--- @return UIFormationTeamData
--- @param team TeamFormationInBound
function UIFormationTeamData.CreateByKazetsuTrialTeamFormationInBound(team, listHeroResource)
    local heroList = List()
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.frontLine:GetItems()) do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(hero.heroInventoryId, listHeroResource)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = true, ['position'] = hero.positionId})
    end
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.backLine:GetItems()) do
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(hero.heroInventoryId, listHeroResource)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = false, ['position'] = hero.positionId})
    end
    if team.defenseFormation ~= nil then
        --- @type FormationData
        local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(team.formationId)
        for i, v in pairs(team.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                ---@type DefenderHeroStatConfig
                local heroDefense = ResourceMgr.GetDefenseModeConfig():GetDefenderHeroStatConfig(v)
                if heroDefense ~= nil then
                    local heroResource = heroDefense:CreateHeroResource(v, i)
                    local isFrontLine = formationData.frontLine >= i
                    local position = i
                    if isFrontLine == false then
                        position = i - formationData.frontLine
                    end
                    heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = isFrontLine, ['position'] = position})
                end
            end
        end
    end
    return UIFormationTeamData(team.summonerId, team.formationId, heroList)
end

--- @return UIFormationTeamData
--- @param team TeamFormationInBound
--- @param listHeroResource List
function UIFormationTeamData.CreateByTeamFormationInBoundAndListHeroResource(team, listHeroResource)
    local heroList = List()
    local getHeroResource = function(id)
        ---@param v HeroResource
        for i, v in ipairs(listHeroResource:GetItems()) do
            if v.inventoryId == id then
                return v
            end
        end
        return nil
    end
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.frontLine:GetItems()) do
        local heroResource = getHeroResource(hero.heroInventoryId)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = true, ['position'] = hero.positionId})
    end
    --- @param hero HeroFormationInBound
    for i, hero in ipairs(team.backLine:GetItems()) do
        local heroResource = getHeroResource(hero.heroInventoryId)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = false, ['position'] = hero.positionId})
    end
    if team.defenseFormation ~= nil then
        --- @type FormationData
        local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(team.formationId)
        for i, v in pairs(team.defenseFormation.dictHeroSlot:GetItems()) do
            if v > 0 then
                ---@type DefenderHeroStatConfig
                local heroDefense = ResourceMgr.GetDefenseModeConfig():GetDefenderHeroStatConfig(v)
                if heroDefense ~= nil then
                    local heroResource = heroDefense:CreateHeroResource(v, i)
                    local isFrontLine = formationData.frontLine >= i
                    local position = i
                    if isFrontLine == false then
                        position = i - formationData.frontLine
                    end
                    heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = isFrontLine, ['position'] = position})
                end
            end
        end
    end
    return UIFormationTeamData(team.summonerId, team.formationId, heroList)
end