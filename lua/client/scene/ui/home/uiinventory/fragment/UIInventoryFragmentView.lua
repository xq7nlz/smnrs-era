require "lua.client.core.network.summonHeroFragment.SummonHeroFragmentInBound"
require "lua.client.core.network.item.combineArtifact.CombineArtifactFragmentOutBound"
require "lua.client.core.network.item.combineArtifact.CombineArtifactFragmentInBound"

--- @class UIInventoryFragmentView
UIInventoryFragmentView = Class(UIInventoryFragmentView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventoryFragmentView:Ctor(view, transform, model)
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List --<id>
    self.itemDicArtifactFragment = nil
    ---@type number
    self.countDicArtifactFragment = nil
    ---@type List --<id>
    self.itemDicHeroFragment = nil
    ---@type number
    self.countDicHeroFragment = nil

    --- @type FragmentIconView
    self.itemShowSoftTutFragment = nil

    ---@type List --<id>
    self.listFragmentItemView = List()

    ---@type CombineArtifactFragmentOutBound
    self.combineArtifactFragmentOutBound = CombineArtifactFragmentOutBound()

    -- UI
    ---@type UIInventoryFragmentConfig
    ---@type UIInventoryFragmentConfig
    self.config = UIBaseConfig(transform)

    --- @param obj FragmentIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        if self.listFragmentItemView:IsContainValue(obj) == false then
            self.listFragmentItemView:Add(obj)
        end
        local type
        local id
        local countFull
        if index < self.countDicArtifactFragment then
            type = ResourceType.ItemFragment
            id = self.itemDicArtifactFragment:Get(index + 1)
            ---@type ArtifactFragmentConfig
            local artifactConfig = ResourceMgr.GetFragmentConfig().artifactFragmentDictionary:Get(id)
            countFull = artifactConfig.price
        else
            type = ResourceType.HeroFragment
            id = self.itemDicHeroFragment:Get(index + 1 - self.countDicArtifactFragment)
            local star = ClientConfigUtils.GetHeroFragmentStar(id)
            ---@type HeroFragmentNumberConfig
            local heroFragmentNumberConfig = ResourceMgr.GetFragmentConfig().heroFragmentNumberDictionary:Get(star)
            if heroFragmentNumberConfig == nil then
                assert(false, "Nil star " .. star .. "id" .. id)
            end
            countFull = heroFragmentNumberConfig.number
        end
        --assert(countFull == nil, string.format("countFull == nil   index_%s", index))
        local number = InventoryUtils.Get(type, id)
        ---@type FragmentIconData
        local fragmentData = FragmentIconData.CreateInstance(type, id, number, countFull)

        obj:RemoveAllListeners()
        obj:SetIconData(fragmentData)
        local notiFragment = NotificationFragment.CheckNotificationFragmentType(type, id)
        if notiFragment == true then
            obj:ActiveNotification(true)
        end
        local checkSoftTut = function()
            if type == ResourceType.HeroFragment then
                local idNoti = NotificationFragment.GetNotiHeroFragment()
                if NotificationFragment.IsCanShowSoftTutFragment() and number >= countFull and self.itemShowSoftTutFragment == nil then
                    obj:ActiveSoftTut(true)
                    self.itemShowSoftTutFragment = obj
                end
            end
        end
        checkSoftTut()
        obj:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            obj:ActiveNotification(false)
            self:OnClickFragment(fragmentData)
        end)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.FragmentIconView, onCreateItem)
end

--- @return void
function UIInventoryFragmentView:Show()
    self.itemDicArtifactFragment = InventoryUtils.GetListArtifactFragment(1)
    self.countDicArtifactFragment = self.itemDicArtifactFragment:Count()

    self.itemDicHeroFragment = InventoryUtils.GetListHeroFragment(1)
    self.countDicHeroFragment = self.itemDicHeroFragment:Count()

    local itemCount = self.countDicArtifactFragment + self.countDicHeroFragment
    self.itemShowSoftTutFragment = nil
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIInventoryFragmentView:Hide()
    self.listFragmentItemView:Clear()
    self.uiScroll:Hide()
end

--- @return void
---@param id number
---@param number number
function UIInventoryFragmentView:SummonHeroFragment(id, number, success)
    self:RequestSummonHeroFragment(id, number, function(_data)
        if zg.playerData.remoteConfig.softTutFragment == nil then
            zg.playerData.remoteConfig.softTutFragment = zg.timeMgr:GetServerTime()
            zg.playerData:SaveRemoteConfig()
        end
        ---@type SummonHeroFragmentInBound
        local data = _data
        local star = ClientConfigUtils.GetHeroFragmentStar(id)
        local dic = Dictionary()
        local rewardList = List()
        ---@param v HeroResource
        for _, v in pairs(data.listHeroResource:GetItems()) do
            local numberHero = 1
            if dic:IsContainKey(v.heroId) then
                numberHero = dic:Get(v.heroId) + 1
            end
            dic:Add(v.heroId, numberHero)
        end
        for heroId, tempNumber in pairs(dic:GetItems()) do
            local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
            rewardList:Add(HeroIconData.CreateInstance(ResourceType.Hero, heroId, star, nil, faction, tempNumber))
        end
        if success ~= nil then
            success()
        end
        if rewardList:Count() > 10 then
            PopupMgr.ShowPopup(UIPopupName.UIScrollLoopReward, { ["resourceList"] = rewardList })
        else
            PopupUtils.ShowRewardList(rewardList)
        end
    end)
end

--- @return void
function UIInventoryFragmentView:RequestSummonHeroFragment(id, number, callbackSuccess, callbackFailed)
    --- Default fragment summon normal heroes opcode
    local opCode = OpCode.SUMMON_HERO_BY_FRAGMENT
    --- fragment summon heroes 5 star red summon opcode
    if id > ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA and id < ClientConfigUtils.FACTION_HERO_FRAGMENT_RED_BORDER_ID_DELTA + 1000  then
        opCode = OpCode.SUMMON_RED_BORDER_HERO_BY_FRAGMENT
    end
    local callback = function(result)
        ---@type SummonHeroFragmentInBound
        local data
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            data = SummonHeroFragmentInBound(buffer)
        end

        local onSuccess = function()
            --XDebug.Log("Summon hero success")
            if callbackSuccess ~= nil then
                callbackSuccess(data)
            end
            if data ~= nil and data.listHeroResource:Count() > 0 then
                ---@type HeroList
                local heroList = InventoryUtils.Get(ResourceType.Hero)
                heroList:AddAll(data.listHeroResource)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(data)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        --TouchUtils.Enable()
    end

    NetworkUtils.Request(opCode, UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Short, number), callback)
    --TouchUtils.Disable()
end

--- @return void
function UIInventoryFragmentView:RequestArtifactFragment(callbackSuccess, callbackFailed)
    if self.combineArtifactFragmentOutBound.listData:Count() > 0 then
        local callback = function(result)
            ---@type CombineArtifactFragmentInBound
            local data
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                data = CombineArtifactFragmentInBound(buffer)
            end
            local onSuccess = function()
                XDebug.Log("Combine Artifact Success")
                if callbackSuccess ~= nil then
                    callbackSuccess(data)
                end
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                XDebug.Log("Combine Artifact Failed")
                if callbackFailed ~= nil then
                    callbackFailed(data)
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            self.combineArtifactFragmentOutBound.listData:Clear()
            --TouchUtils.Enable()
        end
        NetworkUtils.Request(OpCode.ITEM_ARTIFACT_COMBINE, self.combineArtifactFragmentOutBound, callback)
        --TouchUtils.Disable()
    end
end

--- @return void
---@param id number
---@param number number
function UIInventoryFragmentView:SummonArtifactFragment(id, number, success)
    self.combineArtifactFragmentOutBound.listData:Add(CombineArtifactRecordOutBound(id, number))
    self:RequestArtifactFragment(function(_data)
        ---@type CombineArtifactFragmentInBound
        local data = _data
        ---@type Dictionary
        local dic = Dictionary()
        for _, artifactId in pairs(data.listId:GetItems()) do
            local numberArtifact = 1
            if dic:IsContainKey(artifactId) then
                numberArtifact = dic:Get(artifactId) + 1
            end
            dic:Add(artifactId, numberArtifact)
        end
        local rewardList = List()
        for i, v in pairs(dic:GetItems()) do
            InventoryUtils.Add(ResourceType.ItemArtifact, i, v)
            rewardList:Add(ItemIconData.CreateInstance(ResourceType.ItemArtifact, i, v))
        end
        if success ~= nil then
            success()
        end
        if rewardList:Count() > 10 then
            PopupMgr.ShowPopup(UIPopupName.UIScrollLoopReward, { ["resourceList"] = rewardList })
        else
            PopupUtils.ShowRewardList(rewardList)
        end
    end)
end

--- @return void
--- @param fragmentData FragmentIconData
function UIInventoryFragmentView:SummonItem(fragmentData)
    if not (fragmentData.type == ResourceType.HeroFragment and InventoryUtils.Get(ResourceType.Hero):Count() >= ClientConfigUtils.MAX_HERO) then
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        local callbackSummon = function(number)
            InventoryUtils.Sub(fragmentData.type, fragmentData.itemId, fragmentData.countFull * number)
            NotificationFragment.SaveToServer()
            if fragmentData.type == ResourceType.HeroFragment then
                self:SummonHeroFragment(fragmentData.itemId, number)
            else
                self:SummonArtifactFragment(fragmentData.itemId, number)
            end
            self:Show()
        end
        PopupMgr.ShowPopup(UIPopupName.UIPopupSummonItem, { ["fragmentData"] = fragmentData, ["callbackSummon"] = callbackSummon })
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_hero"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
--- @param fragmentData FragmentIconData
function UIInventoryFragmentView:OnClickFragment(fragmentData, callbackClose)
    local maxSummon = math.floor(fragmentData.quantity / fragmentData.countFull)
    if fragmentData.type == ResourceType.HeroFragment then
        local heroCount = InventoryUtils.Get(ResourceType.Hero):Count()
        if heroCount < ClientConfigUtils.MAX_HERO then
            maxSummon = math.min(maxSummon, ClientConfigUtils.MAX_HERO - heroCount)
        else
            maxSummon = 0
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_hero"))
        end
    end
    local numberSummon = 0
    local buttonSummon
    local input
    local callbackSummonItem = function()
        local success = function()
            PopupMgr.HidePopup(UIPopupName.UIItemPreview)
            InventoryUtils.Sub(fragmentData.type, fragmentData.itemId, fragmentData.countFull * numberSummon)
            NotificationFragment.SaveToServer()
            self:Show()
        end

        if fragmentData.type == ResourceType.HeroFragment then
            self:SummonHeroFragment(fragmentData.itemId, numberSummon, success)
        else
            self:SummonArtifactFragment(fragmentData.itemId, numberSummon, success)
        end
    end
    local data = {}
    if maxSummon > 0 then
        buttonSummon = { ["name"] = LanguageUtils.LocalizeCommon("summon"), ["callback"] = callbackSummonItem }
        input = { ["number"] = 1, ["min"] = 1, ["max"] = maxSummon, ["onChangeInput"] = function(value)
            numberSummon = value
        end }
    end
    data.data1 = {
        ["type"] = fragmentData.type, ["id"] = fragmentData.itemId,
        ["button2"] = buttonSummon,
        ["info"] = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("hero_fragment_info"), fragmentData.countFull),
        ["input"] = input,
    }
    if fragmentData.type == ResourceType.HeroFragment and NotificationFragment.IsCanShowSoftTutFragment() then
        data.callbackClose = function()
            if callbackClose ~= nil then
                callbackClose()
            end
            if self.itemShowSoftTutFragment ~= nil and NotificationFragment.IsCanShowSoftTutFragment() == true then
                self.itemShowSoftTutFragment:ActiveSoftTut(true)
            end
            PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        end
        data.softTut = true
    end
    if self.itemShowSoftTutFragment ~= nil then
        self.itemShowSoftTutFragment:ActiveSoftTut(false)
    end
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, data)
end