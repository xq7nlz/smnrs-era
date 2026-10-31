---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.prefabTeam.UIPrefabTeamConfig"

--- @class UIPrefabTeamView : UIPrefabView
UIPrefabTeamView = Class(UIPrefabTeamView, UIPrefabView)

--- @return void
function UIPrefabTeamView:Ctor()
    --- @type number
    self.NUMBER_SLOT = 5
    --- @type HeroDataService
    self.heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
    --- @type UIPrefabHeroSlotView
    self.uiPrefabHeroSlotView = nil
    --- @type List<HeroResource>
    self.heroResourceList = nil
    --- @type Dictionary
    self.heroLinkingDict = nil
    --- @type Dictionary
    self.dataLinkingDict = nil
    --- @type HeroIconView
    self.mainHeroIconView = nil
    UIPrefabView.Ctor(self)

    self:_InitHeroLinking()
end

--- @return void
function UIPrefabTeamView:SetPrefabName()
    self.prefabName = 'prefab_team_info'
    self.uiPoolType = UIPoolType.UIPrefabTeamView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIPrefabTeamView:SetConfig(transform)
    --- @type UIPrefabTeamConfig
    self.config = UIBaseConfig(transform)
    self.mainHeroIconView = HeroIconView(self.config.heroIconInfo)
end

--- @return void
function UIPrefabTeamView:Show()
    UIPrefabView.Show(self)
    self.heroResourceList = InventoryUtils.Get(ResourceType.Hero)
end

--- @return void
function UIPrefabTeamView:ActiveBuff(activeBuff)
    if activeBuff == false then
        self.config.textBuffAtk.gameObject:SetActive(false)
        self.config.textBuffHp.gameObject:SetActive(false)
    else
        self.config.textBuffAtk.gameObject:SetActive(true)
        self.config.textBuffHp.gameObject:SetActive(true)
    end
end

--- @return void
function UIPrefabTeamView:ActiveLinking(activeLinking)
    --XDebug.Log(LogUtils.ToDetail(self.config))
    if activeLinking == false then
        self.config.linkingUp:SetActive(false)
        self.config.linkingUp:SetActive(false)
    end
end

--- @return void
--- @param uiPrefabHeroSlotView UIPrefabHeroSlotView
function UIPrefabTeamView:Init(uiPrefabHeroSlotView)
    assert(uiPrefabHeroSlotView)
    self.uiPrefabHeroSlotView = uiPrefabHeroSlotView
end

--- @return void
--- @param heroIdDict Dictionary<index:number,heroId:number>
function UIPrefabTeamView:SetLinking(heroIdDict)
    self.dataLinkingDict = self:_GetLinkings(heroIdDict)
    self:_DrawLinking()
end

--- @return void
function UIPrefabTeamView:SetDefaultLinking()
    local data = self.uiPrefabHeroSlotView:GetHeroIdDict()
    self:SetLinking(data)
end

--- @return List
--- @param heroIdDict Dictionary
function UIPrefabTeamView:_GetLinkings(heroIdDict)

    local heroDict = Dictionary()
    local linkingActiveDict = Dictionary()
    for _, heroId in pairs(heroIdDict:GetItems()) do
        heroDict:Add(heroId, 1)
    end
    for index, heroId in pairs(heroIdDict:GetItems()) do
        local linkingId = self.heroLinkingDict:Get(heroId)
        if linkingId ~= nil then
            --- @type List
            local heroList = linkingActiveDict:Get(linkingId)
            if heroList == nil then
                local isActived = true
                --- @type BaseLinking
                local baseLinking = self.heroDataService:GetHeroLinkingEntries():Get(linkingId)
                for _, tempHeroId in ipairs(baseLinking.affectedHero:GetItems()) do
                    if heroDict:Get(tempHeroId) ~= 1 then
                        isActived = false
                        break
                    end
                end

                if isActived then
                    heroList = List()
                    linkingActiveDict:Add(linkingId, heroList)
                end
            end

            if heroList ~= nil then
                heroList:Add(index)
            end
        end
    end
    --- @param v List
    for i, v in pairs(linkingActiveDict:GetItems()) do
        v:SortWithMethod(function(x, y)
            if x < y then
                return -1
            end
            return 1
        end)
    end
    return linkingActiveDict
end

function UIPrefabTeamView:_DrawLinking()
    Coroutine.start(function()
        local count = self.dataLinkingDict:Count()
        --self.config.linkingUp:SetActive(count > 0)
        --self.config.linkingDown:SetActive(count > 1)
        self.config.linkingUp:SetActive(false)
        self.config.linkingDown:SetActive(false)
        coroutine.waitforendofframe()
        local frontX = self.config.formationFront.localPosition.x
        local backX = self.config.formationBack.localPosition.x

        --- @param posList List
        --- @param effectLinking UnityEngine_UI_Image
        --- @param buttonAuraBuff UnityEngine_UI_Button
        --- @param line UnityEngine_GameObject
        local showLinking = function(linkingId, posList, effectLinking, buttonAuraBuff, line)
            buttonAuraBuff.onClick:RemoveAllListeners()
            buttonAuraBuff.onClick:AddListener(function()
                XDebug.Log("linkingId: " .. linkingId)
            end)

            count = posList:Count()
            assert(count > 1)

            local localStartPosX = self.uiPrefabHeroSlotView:GetButtonLocalPosX(posList:Get(1))
            local localEndPosX = self.uiPrefabHeroSlotView:GetButtonLocalPosX(posList:Get(count))

            local startPosX = self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(1))
            local endPosX = self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(count))

            local realStartPosX = (localStartPosX < 0 and frontX or backX) + localStartPosX
            local realEndPosX = (localEndPosX < 0 and frontX or backX) + localEndPosX

            local length = realEndPosX - realStartPosX + 33
            effectLinking.rectTransform:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, length)

            local linkingPos = effectLinking.transform.position
            effectLinking.transform.position = U_Vector3((startPosX + endPosX) / 2, linkingPos.y, linkingPos.z)

            if count == 2 then
                local position = buttonAuraBuff.transform.localPosition
                buttonAuraBuff.transform.localPosition = U_Vector3(0, position.y, position.z)
            else
                line:SetActive(true)
                for i = 2, count - 1 do
                    local posX = self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(i))
                    local child = line.transform:GetChild(i - 2)
                    child.gameObject:SetActive(true)
                    child.position = U_Vector3(posX, child.position.y, child.position.z)
                end
                local posX = 0
                if count == 3 or count == 5 then
                    posX = self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(math.ceil(count / 2)))
                else
                    posX = (self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(2)) +
                            self.uiPrefabHeroSlotView:GetButtonPosX(posList:Get(3))) / 2
                end
                local buttonPosition = buttonAuraBuff.transform.position
                buttonAuraBuff.transform.position = U_Vector3(posX, buttonPosition.y, buttonPosition.z)
            end

            for i = count - 1, 3 do
                local child = line.transform:GetChild(i - 1)
                child.gameObject:SetActive(false)
            end
        end

        local countLinking = 1
        for k, v in pairs(self.dataLinkingDict:GetItems()) do
            if countLinking == 1 then
                showLinking(k, v, self.config.effectLinkingUp, self.config.buttonAuraBuffUp, self.config.otherUp)
            else
                showLinking(k, v, self.config.effectLinkingDown, self.config.buttonAuraBuffDown, self.config.otherDown)
            end
            countLinking = countLinking + 1
        end
    end)
end

--- @return void
function UIPrefabTeamView:_InitHeroLinking()
    self.heroLinkingDict = Dictionary()

    --local linkings = self.heroDataService:GetHeroLinkingEntries()
    ----- @param v BaseLinking
    --for i, v in ipairs(linkings:GetItems()) do
    --    for _, hero in ipairs(v.affectedHero:GetItems()) do
    --        self.heroLinkingDict:Add(hero, i)
    --    end
    --end
end

--- @return number, number
--- @param formationId number
function UIPrefabTeamView:_GetFormationBuff(formationId)
    local hp, atk = ClientConfigUtils.GetFormationBuff(formationId)
    return MathUtils.RoundDecimal(hp * 100), MathUtils.RoundDecimal(atk * 100)
end

--- @return void
--- @param currentFormation number
function UIPrefabTeamView:_SetBuffText(currentFormation)
    Coroutine.start(function()
        coroutine.waitforendofframe()
        self.config.textBuffAtk.rectTransform.localPosition = U_Vector3(self.config.formationBack.localPosition.x + self.config.formationBack.rect.width / 2, 250, 0)
        self.config.textBuffHp.rectTransform.localPosition = U_Vector3(self.config.formationFront.localPosition.x - self.config.formationFront.rect.width / 2, 250, 0)

        local hp, atk = self:_GetFormationBuff(currentFormation)
        self.config.textBuffAtk.text = string.format("Back +%s%% <color=#F94421> ATK</color>", atk)
        self.config.textBuffHp.text = string.format("Front +%s%% <color=#F94421> HP</color>", hp)
    end)
end

--- @return void
--- @param realFormation number -- realFormation
function UIPrefabTeamView:SetFormation(realFormation)
    self:_SetBuffText(realFormation)
    self:_SetHeroSlotPosition(realFormation)
    self:SetDefaultLinking()
end

--- @param summonerBattleInfo SummonerBattleInfo
function UIPrefabTeamView:SetSummonerInfo(summonerBattleInfo)
    local activeSummonerSlot = summonerBattleInfo ~= nil and summonerBattleInfo.isDummy == false
    if activeSummonerSlot == true then
        self.mainHeroIconView:SetDataMainHero(summonerBattleInfo.summonerId, summonerBattleInfo.star, summonerBattleInfo.level)
    end
    self.mainHeroIconView:SetActive(activeSummonerSlot)
end

--- @return void
---@param callbackSwitch number
function UIPrefabTeamView:AddListenerSwitchSummoner(callbackSwitch)
    self.config.buttonSwichMainHero.onClick:RemoveAllListeners()
    if callbackSwitch ~= nil then
        self.config.buttonSwichMainHero.onClick:AddListener(function()
            if zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).star > 3 then
                callbackSwitch()
                PopupMgr.ShowPopup(UIPopupName.UISwitchCharacter, callbackSwitch)
            end
        end)
    end
end

--- @return void
--- @param realFormation number
function UIPrefabTeamView:_SetHeroSlotPosition(realFormation)
    for i = 1, self.NUMBER_SLOT do
        --- @type UIFormationButtonSlotView
        local button = self.uiPrefabHeroSlotView.uiButtonSlotList:Get(i)
        if self:IsFront(self.NUMBER_SLOT - i + 1, realFormation) then
            button.config.rectTransform:SetParent(self.config.formationFront)
            button.config.rectTransform:SetAsLastSibling()
        else
            button.config.rectTransform:SetParent(self.config.formationBack)
        end
    end
end

--- @return void
--- @param realFormation number
function UIPrefabTeamView:FrontLineLength(realFormation)
    return self.heroDataService:GetFormationData(realFormation).frontLine
end

--- @return boolean
--- @param slotIndex number
function UIPrefabTeamView:IsFront(slotIndex, realFormation)
    return slotIndex <= self:FrontLineLength(realFormation)
end

--- @return void
function UIPrefabTeamView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self.config.buttonSwichMainHero.onClick:RemoveAllListeners()
    self.config.bgDoiHinhBack.enabled = true
    self.config.bgDoiHinhFront.enabled = true
end

--- @param position UnityEngine_Vector3
--- @param scale UnityEngine_Vector3
function UIPrefabTeamView:SetSummonerTransform(position, scale)
    self.config.mainHeroTransform.anchoredPosition3D = position
    self.config.mainHeroTransform.localScale = scale
end

return UIPrefabTeamView

