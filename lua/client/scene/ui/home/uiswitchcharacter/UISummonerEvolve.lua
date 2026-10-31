---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSwitchCharacter.UISummonerEvolveConfig"

--- @class UISummonerEvolve
UISummonerEvolve = Class(UISummonerEvolve)

--- @return void
--- @param transform UnityEngine_Transform
function UISummonerEvolve:Ctor(transform)
    --- @type number
    self.summonerId = nil
    --- @type number
    self.summonerStar = nil
    ---@type UISummonerEvolveConfig
    ---@type UISummonerEvolveConfig
    self.config = UIBaseConfig(transform)
    ---@type SummonerPriceEvolveConfig
    self.summonerPriceEvolveConfig = nil
    ---@type ListSkillView
    self.listSkillView = ListSkillView(self.config.contentSkill, U_Vector2(1.1,0.5), nil)
    ---@type List
    self.materials = List()
    ---@type PlayerSummonerInBound
    self.summonerInbound = nil
    self:InitUI()
end

--- @return void
function UISummonerEvolve:InitLocalization()
    self.config.localizeEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.localizeAwaken.text = LanguageUtils.LocalizeCommon("awaken")
end

--- @return void
function UISummonerEvolve:InitUI()
    self.config.buttonEvolve.onClick:AddListener(function ()
        self:OnClickEvolve()
    end)
    self.config.buttonAwaken.onClick:AddListener(function ()
        self:OnClickEvolve()
    end)

end

--- @return void
function UISummonerEvolve:Show(summonerId, summonerStar)
    self.summonerId = summonerId
    self.summonerStar = summonerStar
    self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    if not self.summonerInbound:IsCanEvolve() then
        --self.mainCharacterView.tab:Select(1)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_max_star"))
    else
        --STAR
        local numberStar1 = summonerStar % 6
        local numberStar2 = (summonerStar + 1) % 6
        if numberStar1 == 0 then
            numberStar1 = 6
            self.config.buttonAwaken.gameObject:SetActive(true)
            self.config.buttonEvolve.gameObject:SetActive(false)
        else
            self.config.buttonAwaken.gameObject:SetActive(false)
            self.config.buttonEvolve.gameObject:SetActive(true)
        end
        if numberStar2 == 0 then
            numberStar2 = 6
        end
        --if summonerStar == 12 then
        --    numberStar2 = 6
        --end

        ---@type UnityEngine_Sprite
        local sprite1 = ResourceLoadUtils.LoadStarHeroEvolve(self.summonerStar)
        ---@type UnityEngine_Sprite
        local sprite2 = ResourceLoadUtils.LoadStarHeroEvolve(self.summonerStar + 1)
        local sizeStar1 = sprite1.border.x + sprite1.border.z
        local sizeStarDelta = sprite1.bounds.size.x * 100 - sizeStar1
        self.config.star1.sprite = sprite1
        self.config.star1.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (numberStar1 - 1), sprite1.bounds.size.y * 100)
        self.config.star2.sprite = sprite2
        self.config.star2.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (numberStar2 - 1), sprite2.bounds.size.y * 100)

        if summonerStar == ResourceMgr.GetMainCharacterConfig().mainSummonerEvolveDictionary:Count() then
            self:Hide()
        else
            if summonerId == 0 then
                self:ReturnSkill()
            else
                --SKILL
                self.listSkillView:SetDataSummoner(summonerId, summonerStar + 1, false, true)
            end

            --MATERIAL
            self.summonerPriceEvolveConfig = ResourceMgr.GetMainCharacterConfig().mainSummonerEvolveDictionary:Get(summonerStar + 1)
            if self.summonerPriceEvolveConfig ~= nil then
                local countMaterial = self.summonerPriceEvolveConfig.listMoney:Count()
                local countMaterialView = self.materials:Count()
                if countMaterial < countMaterialView then
                    for i = countMaterial + 1, countMaterialView do
                        ---@type MoneyIconView
                        local item = self.materials:Get(i)
                        item.config.gameObject:SetActive(false)
                    end
                elseif countMaterial > countMaterialView then
                    for i = countMaterialView + 1, countMaterial do
                        ---@type MoneyIconView
                        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.materials)
                        self.materials:Add(item)
                    end
                end
                ---@param v ItemIconData
                for i, v in ipairs(self.summonerPriceEvolveConfig.listMoney:GetItems()) do
                    ---@type MoneyIconView
                    local item = self.materials:Get(i)
                    item:SetIconData(v)
                    item:SetQuantityAndInventory()
                    item:RegisterShowInfo()
                end
            else
                self:ReturnMaterial()
            end
        end
    end
end

--- @return void
function UISummonerEvolve:Hide()
    self:ReturnSkill()
    self:ReturnMaterial()
end

--- @return void
function UISummonerEvolve:ReturnSkill()
    self.listSkillView:ReturnPool()
end

--- @return void
function UISummonerEvolve:ReturnMaterial()
    ---@param v MoneyIconView
    for i, v in pairs(self.materials:GetItems()) do
        v:ReturnPool()
    end
    self.materials:Clear()
end

--- @return void
function UISummonerEvolve:OnClickEvolve()
    if self.summonerInbound:IsCanEvolve() then
        local rewardList = self.summonerPriceEvolveConfig:GetRewardList()
        local canEvolve = InventoryUtils.IsEnoughMultiResourceRequirement(rewardList)
        if canEvolve then
            local onReceived = function(result)
                local onSuccess = function()
                    --XDebug.Log("SUMMONER_EVOLVE success")
                    local touchObject = TouchUtils.Spawn("UISummonerEvolve:OnClickEvolve")

                    --- change star -> change money -> listener noti

                    self.summonerInbound.star = self.summonerInbound.star + 1

                    if self.summonerInbound.star == 7 or self.summonerInbound.star == 10 then
                        -----@type HeroResource
                        --local heroResource = self.model.heroResource
                        --heroResource.heroStar = summonerInBound.star
                        --self.model.previewHero:PreviewHero(heroResource)
                    end
                    --self.model.previewHero:Evolve()

                    ---@param v ItemIconData
                    for _, v in ipairs(self.summonerPriceEvolveConfig.listMoney:GetItems()) do
                        InventoryUtils.Sub(ResourceType.Money, v.itemId, v.quantity)
                    end

                    local updateUI = function()
                        self:Show(self.summonerId, self.summonerStar)
                        touchObject:Enable()
                    end
                    if self.summonerInbound.star == 4 then
                        self.summonerInbound.summonerId = 1
                        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.SUMMONER }, function ()
                            Coroutine.start(function ()
                                RxMgr.summonerStar:Next(self.summonerInbound.star)
                                coroutine.waitforseconds(1.7)
                                touchObject:Enable()
                            end)
                        end)
                    else
                        local data = {}
                        data.awaken = false
                        data.heroResource = HeroResource.CreateInstance(nil, self.summonerId, self.summonerStar)
                        data.isSummoner = true
                        PopupMgr.ShowPopupDelay(2, UIPopupName.UIPopupEnhance, data, nil, updateUI)
                        RxMgr.summonerStar:Next(self.summonerInbound.star)
                    end
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.SUMMONER_EVOLVE, nil, onReceived, true, true)
            zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_max_star"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end