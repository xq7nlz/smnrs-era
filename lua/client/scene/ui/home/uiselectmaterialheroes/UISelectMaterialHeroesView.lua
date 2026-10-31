---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSelectMaterialHeroes.UISelectMaterialHeroesConfig"
require "lua.client.scene.ui.common.HeroIconSelectView"
require "lua.client.core.network.hero.HeroAllUnlockOutBound"
require "lua.client.core.network.hero.HeroAllUnlockInBound"

--- @class UISelectMaterialHeroesView : UIBaseView
UISelectMaterialHeroesView = Class(UISelectMaterialHeroesView, UIBaseView)

--- @return void
--- @param model UISelectMaterialHeroesModel
function UISelectMaterialHeroesView:Ctor(model)
    ---@type UISelectMaterialHeroesConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type function
    self.callbackSelect = nil
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UISelectMaterialHeroesModel
    self.model = self.model
end

--- @return void
function UISelectMaterialHeroesView:OnReadyCreate()
    ---@type UISelectMaterialHeroesConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSelect()
    end)

    -- Scroll view
    --- @param obj HeroIconView
    --- @param index number
    local onCreateItem = function(obj, _index)
        ---@type HeroFood
        local data = self.model.listMaterial:Get(_index + 1)
        if data.heroFoodType ~= nil then
            obj:SetIconData(ItemIconData.CreateBuyHeroFood(data.heroFoodType, self.model.sortStar))
            if self.model.listCurrentFoodSelect:IsContainValue(data) then
                obj:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskSelect(false)
            end
            obj:SetSizeHeroView()
            obj:RemoveAllListeners()
            obj:AddListener(function()
                if self.model.listCurrentFoodSelect:IsContainValue(data) then
                    self.model.listCurrentFoodSelect:RemoveByReference(data)
                    obj:ActiveMaskSelect(false)
                elseif self:GetNumberSelect() < self.model.maxSelect then
                    self.model.listCurrentFoodSelect:Add(data)
                    obj:ActiveMaskSelect(true, UIUtils.sizeItem)
                end
            end)
            obj:SetSizeHeroView()
        else
            if data then
                ---@type HeroIconData
                local heroData = HeroIconData.CreateByHeroResource(data)
                obj:SetIconData(heroData)
                if self.model.listCurrentSlotSelect ~= nil and self.model.listCurrentSlotSelect:IsContainValue(data) then
                    obj:ActiveMaskSelect(true, UIUtils.sizeItem)
                else
                    obj:ActiveMaskSelect(false)
                end
            end
            obj:RemoveAllListeners()
            obj:AddListener(function()
                self:SelectMaterial(obj, data)
            end)
            local noti = ClientConfigUtils.GetNotiLockHero(data)
            if noti ~= nil then
                obj:ActiveMaskLock(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskLock(false)
            end
            obj:EnableButton(true)
        end

        --local index = _index
        --if index < self.model.heroFoodFaction.number then
        --	index = index + 1
        --	obj:SetIconData(ItemIconData.CreateBuyHeroFood(self.model.heroFoodFaction.heroFoodType, self.model.sortStar))
        --	if self.model.listHeroFoodFactionSelect:IsContainValue(index) then
        --		obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --	else
        --		obj:ActiveMaskSelect(false)
        --	end
        --	obj:SetSizeHeroView()
        --	obj:RemoveAllListeners()
        --	obj:AddListener(function ()
        --		if self.model.listHeroFoodFactionSelect:IsContainValue(index) then
        --			self.model.listHeroFoodFactionSelect:RemoveByReference(index)
        --			obj:ActiveMaskSelect(false)
        --		elseif self:GetNumberSelect() < self.model.maxSelect then
        --			self.model.listHeroFoodFactionSelect:Add(index)
        --			obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --		end
        --	end)
        --	obj:SetSizeHeroView()
        --elseif index < self.model.heroFoodFaction.number + self.model.moonHeroFood.number then
        --	index = index - self.model.heroFoodFaction.number + 1
        --	obj:SetIconData(ItemIconData.CreateBuyHeroFood(HeroFoodType.MOON, self.model.sortStar))
        --	if self.model.listMoonHeroFoodSelect:IsContainValue(index) then
        --		obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --	else
        --		obj:ActiveMaskSelect(false)
        --	end
        --	obj:SetSizeHeroView()
        --	obj:RemoveAllListeners()
        --	obj:AddListener(function ()
        --		if self.model.listMoonHeroFoodSelect:IsContainValue(index) then
        --			self.model.listMoonHeroFoodSelect:RemoveByReference(index)
        --			obj:ActiveMaskSelect(false)
        --		elseif self:GetNumberSelect() < self.model.maxSelect then
        --			self.model.listMoonHeroFoodSelect:Add(index)
        --			obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --		end
        --	end)
        --	obj:SetSizeHeroView()
        --elseif index < self.model.heroFoodFaction.number + self.model.moonHeroFood.number + self.model.sunHeroFood.number then
        --	index = index - self.model.heroFoodFaction.number - self.model.moonHeroFood.number + 1
        --	obj:SetIconData(ItemIconData.CreateBuyHeroFood(HeroFoodType.SUN, self.model.sortStar))
        --	if self.model.listSunHeroFoodSelect:IsContainValue(index) then
        --		obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --	else
        --		obj:ActiveMaskSelect(false)
        --	end
        --	obj:RemoveAllListeners()
        --	obj:AddListener(function ()
        --		if self.model.listSunHeroFoodSelect:IsContainValue(index) then
        --			self.model.listSunHeroFoodSelect:RemoveByReference(index)
        --			obj:ActiveMaskSelect(false)
        --		elseif self:GetNumberSelect() < self.model.maxSelect then
        --			self.model.listSunHeroFoodSelect:Add(index)
        --			obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --		end
        --	end)
        --	obj:SetSizeHeroView()
        --else
        --	index = index - self.model.heroFoodFaction.number - self.model.moonHeroFood.number - self.model.sunHeroFood.number + 1
        --	---@type HeroResource
        --	local heroResource = self.model.heroListSort:Get(index)
        --	if heroResource then
        --		---@type HeroIconData
        --		local heroData = HeroIconData.CreateByHeroResource(heroResource)
        --		obj:SetIconData(heroData)
        --		if self.model.listCurrentSlotSelect ~= nil and self.model.listCurrentSlotSelect:IsContainValue(heroResource) then
        --			obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --		else
        --			obj:ActiveMaskSelect(false)
        --		end
        --	end
        --	obj:RemoveAllListeners()
        --	local noti = ClientConfigUtils.GetNotiLockHero(heroResource)
        --	obj:AddListener(function ()
        --		if noti ~= nil then
        --			SmartPoolUtils.ShowShortNotification(noti)
        --		else
        --			if self.model.listCurrentSlotSelect ~= nil and self.model.listCurrentSlotSelect:IsContainValue(heroResource) then
        --				self.model.listCurrentSlotSelect:RemoveByReference(heroResource)
        --				obj:ActiveMaskSelect(false)
        --			elseif self.model.listCurrentSlotSelect == nil or self.model.maxSelect == nil or
        --					self:GetNumberSelect() < self.model.maxSelect then
        --				if self.model.listCurrentSlotSelect == nil then
        --					self.model.listCurrentSlotSelect = List()
        --				end
        --				self.model.listCurrentSlotSelect:Add(heroResource)
        --				obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        --			end
        --		end
        --	end)
        --	if noti ~= nil then
        --		obj:ActiveMaskLock(true, UIUtils.sizeItem)
        --	else
        --		obj:ActiveMaskLock(false)
        --	end
        --	obj:EnableButton(true)
        --end

    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroIconView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02, 3))
end

--- @return void
--- @param obj HeroCardItemView
--- @param data HeroResource
function UISelectMaterialHeroesView:SelectMaterial(obj, data)
    local listLockedFeature = ClientConfigUtils.GetListFeatureLockHeroByInventoryId(data.inventoryId)
    if listLockedFeature:Count() > 0 and self:GetNumberSelect() < self.model.maxSelect then
        local noCallback = function()
            zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        end
        local outBound = HeroAllUnlockOutBound(data.inventoryId)
        --- @type HeroAllUnlockInBound
        local inBound
        local yesCallback = function()
            local onSuccess = function()
                if inBound.listFailed:Count() == 0 then
                    if not self.model.listCurrentSlotSelect:IsContainValue(data) then
                        obj:ActiveMaskLock(false)
                        obj:ActiveMaskSelect(true, SCROLL_VIEW_SIZE)
                        self.model.listCurrentSlotSelect:Add(data)
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
                    end
                else
                    local failedRemoveLocalize = LanguageUtils.LocalizeCommon("failed_quick_remove")
                    local failedUnlockMode = ""
                    for _, v in pairs(inBound.listFailed:GetItems()) do
                        failedUnlockMode = failedUnlockMode .. LanguageUtils.LocalizeFeature(v) .. ", "
                    end
                    failedUnlockMode = string.sub(failedUnlockMode, 1, string.len(failedUnlockMode) - 2)
                    local failedContent = string.format("%s: %s", failedRemoveLocalize, UIUtils.SetColorString(UIUtils.red_light, failedUnlockMode))
                    SmartPoolUtils.ShowShortNotification(failedContent)
                end
            end
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                inBound = HeroAllUnlockInBound(buffer, outBound.listHeroInventoryId)
            end
            NetworkUtils.RequestAndCallback(OpCode.HERO_ALL_UNLOCK, outBound, onSuccess, nil, onBufferReading)
        end
        local confirmRemove = LanguageUtils.LocalizeCommon("confirm_remove_hero")
        local unlockMode = ""
        for k, v in pairs(listLockedFeature:GetItems()) do
            unlockMode = unlockMode .. LanguageUtils.LocalizeFeature(v) .. ", "
        end
        unlockMode = string.sub(unlockMode, 1, string.len(unlockMode) - 2)
        local notiContent = string.format("%s: %s", confirmRemove, UIUtils.SetColorString(UIUtils.red_dark, unlockMode))
        PopupUtils.ShowPopupNotificationYesNo(notiContent, noCallback, yesCallback, nil)
    else
        if self.model.listCurrentSlotSelect ~= nil and self.model.listCurrentSlotSelect:IsContainValue(data) then
            self.model.listCurrentSlotSelect:RemoveByReference(data)
            obj:ActiveMaskSelect(false)
        elseif self.model.listCurrentSlotSelect == nil or self.model.maxSelect == nil or
                self:GetNumberSelect() < self.model.maxSelect then
            if self.model.listCurrentSlotSelect == nil then
                self.model.listCurrentSlotSelect = List()
            end
            self.model.listCurrentSlotSelect:Add(data)
            obj:ActiveMaskSelect(true, UIUtils.sizeItem)
        end
    end
end

--- @return void
function UISelectMaterialHeroesView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_material_hero")
    self.config.localizeSelect.text = LanguageUtils.LocalizeCommon("select")
end

function UISelectMaterialHeroesView:OnReadyShow(result)
    self:Init(result)
    self.uiScroll:PlayMotion()
end

--- @return void
function UISelectMaterialHeroesView:Init(result)
    self.model.heroId = result.heroId
    self.model.maxSelect = result.maxSelect
    self.model.sortFaction = result.sortFaction
    self.model.sortStar = result.sortStar
    self.model.heroResourceIgnor = result.heroResourceIgnor

    if result.listCurrentSlotSelect == nil then
        if self.model.listCurrentSlotSelect == nil then
            self.model.listCurrentSlotSelect = List()
        else
            self.model.listCurrentSlotSelect:Clear()
        end
    else
        self.model.listCurrentSlotSelect:Clear()
        for i, v in pairs(result.listCurrentSlotSelect:GetItems()) do
            self.model.listCurrentSlotSelect:Add(v)
        end
    end
    if result.listAllSlotSelect == nil then
        if self.model.listAllSlotSelect == nil then
            self.model.listAllSlotSelect = List()
        else
            self.model.listAllSlotSelect:Clear()
        end
    else
        self.model.listAllSlotSelect = result.listAllSlotSelect
    end
    if result.listCurrentHeroFoodSelect == nil then
        if self.model.listCurrentHeroFoodSelect == nil then
            self.model.listCurrentHeroFoodSelect = List()
        else
            self.model.listCurrentHeroFoodSelect:Clear()
        end
    else
        self.model.listCurrentHeroFoodSelect:Clear()
        for i, v in pairs(result.listCurrentHeroFoodSelect:GetItems()) do
            self.model.listCurrentHeroFoodSelect:Add(v)
        end
    end
    if result.listAllHeroFoodSelect == nil then
        if self.model.listAllHeroFoodSelect == nil then
            self.model.listAllHeroFoodSelect = List()
        else
            self.model.listAllHeroFoodSelect:Clear()
        end
    else
        self.model.listAllHeroFoodSelect = result.listAllHeroFoodSelect
    end
    self.callbackSelect = result.callbackSelect
    self:Sort()
end

--- @return number
function UISelectMaterialHeroesView:GetNumberSelect()
    return self.model.listCurrentSlotSelect:Count() + self.model.listCurrentFoodSelect:Count()
end

--- @return void
function UISelectMaterialHeroesView:Sort()
    self.model:Sort()
    self.uiScroll:Resize(self.model.listMaterial:Count())
end

--- @return void
function UISelectMaterialHeroesView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end

--- @return void
function UISelectMaterialHeroesView:OnClickSelect()
    PopupMgr.HidePopup(self.model.uiName)
    if self.callbackSelect ~= nil then
        local dict = Dictionary()
        ---@param v HeroFood
        for i, v in ipairs(self.model.listCurrentFoodSelect:GetItems()) do
            local number = dict:Get(v.heroFoodType) or 0
            number = number + 1
            dict:Add(v.heroFoodType, number)
        end
        ---@type List
        local listFoodSelect = List()
        ---@param v HeroFood
        for i, v in pairs(dict:GetItems()) do
            listFoodSelect:Add(HeroFood(i, self.model.sortStar, v))
        end
        self.callbackSelect(self.model.listCurrentSlotSelect, listFoodSelect)
    end
end
