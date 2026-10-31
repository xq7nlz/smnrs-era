require "lua.client.scene.ui.home.uiTempleReplace.PreviewReplaceHero"
require "lua.client.scene.ui.common.prefabHeroList.UIPrefabHeroList2View"

--- @class UITempleReplaceView : UIBaseView
UITempleReplaceView = Class(UITempleReplaceView, UIBaseView)

--- @return void
--- @param model UITempleReplaceModel
--- @param ctrl UITempleReplaceCtrl
function UITempleReplaceView:Ctor(model, ctrl)
    --- @type UITempleReplaceConfig
    self.config = nil
    --- @type PreviewReplaceHero
    self.previewHero = nil
    --- @type UIPrefabHeroList2View
    self.uiPrefabHeroList2View = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type ProphetTreeInBound
    self.prophetTreeInBound = nil
    ---@type boolean
    self.cancelSave = false
    --- @type boolean
    self.isShowingHeroList = false

    UIBaseView.Ctor(self, model, ctrl)

    --- @type UITempleReplaceModel
    self.model = self.model
    --- @type UITempleReplaceCtrl
    self.ctrl = self.ctrl
end

--- @return void
function UITempleReplaceView:OnReadyCreate()
    ---@type UITempleReplaceConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitPreviewHero()
    self:_InitButtonListener()
    self:_CreateFormationHero()
    self:_InitMoneyTableView()
end

function UITempleReplaceView:_InitMoneyTableView()
    self.moneyTableView = ItemsTableView(self.config.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

--- @return void
function UITempleReplaceView:InitLocalization()
    self.config.localizeSummon.text = LanguageUtils.LocalizeCommon("replace")
    self.config.localizeSave.text = LanguageUtils.LocalizeCommon("save")
    self.config.localizeCancel.text = LanguageUtils.LocalizeCommon("cancel")
    self.config.localizePleseSelectHero.text = LanguageUtils.LocalizeCommon("please_select_hero_replace")
    self.config.localizeSelectYourHero.text = LanguageUtils.LocalizeCommon("select_your_hero")
end

--- @return void
function UITempleReplaceView:OnReadyShow()
    self.isShowingHeroList = false
    self:_SetPrefabHeroList(self.isShowingHeroList)
    self.prophetTreeInBound = zg.playerData:GetMethod(PlayerDataMethod.PROPHET_TREE)
    self.ctrl:Show()
    self:_InitMoneyBar()
    self:_SetUIHero()
    self:_ShowHeroListView()
    self.previewHero:OnShow()
    self.config.buttonReplace.gameObject:SetActive(false)
    self.config.buttonCancel.gameObject:SetActive(false)
    self.config.buttonSave.gameObject:SetActive(false)
    if self.prophetTreeInBound.isConverting == true then
        if self.prophetTreeInBound.heroInventoryId ~= nil then
            local hero = InventoryUtils.GetHeroResourceByInventoryId(self.prophetTreeInBound.heroInventoryId)
            if hero ~= nil then
                ---@param heroResource HeroResource
                for i, heroResource in ipairs(self.model.heroResourceList:GetItems()) do
                    if heroResource.inventoryId == self.prophetTreeInBound.heroInventoryId then
                        if heroResource:IsCanConvert() then
                            self.model.selectedHero = i
                            self:_SetButtonPrice(heroResource.heroStar)
                            self:_UpdateSelectedHeroInfo()
                            self.previewHero:ShowSourceHero(heroResource)

                            self.model.convertedHero = self.prophetTreeInBound.newHeroId
                            self:_UpdateConvertedHeroInfo()
                            local newHeroResource = HeroResource.Clone(heroResource)
                            newHeroResource.heroId = self.prophetTreeInBound.newHeroId
                            newHeroResource.heroItem = Dictionary()
                            for i, v in pairs(heroResource.heroItem:GetItems()) do
                                if i ~= HeroItemSlot.SKIN then
                                    newHeroResource.heroItem:Add(i, v)
                                end
                            end
                            self.previewHero:ShowReplacedHero(newHeroResource)

                            --- update ui
                            self.config.haveNotHero:SetActive(false)
                            self.config.localizePleseSelectHero.gameObject:SetActive(false)
                            self.config.haveHero:SetActive(true)
                            self.config.buttonReplace.gameObject:SetActive(false)
                            self.config.buttonCancel.gameObject:SetActive(true)
                            self.config.buttonSave.gameObject:SetActive(true)
                            UIUtils.SetInteractableButton(self.config.buttonSelectHero, false)
                        end
                        break
                    end

                end
            end
        end
    end
end

--- @return void
function UITempleReplaceView:_InitMoneyBar()
    self:SetUpMoneyBar(MoneyType.PROPHET_ORB, MoneyType.PROPHET_WOOD)
end

function UITempleReplaceView:SetUpMoneyBar(...)
    local args = { ... }
    local moneyList = List()
    for i = 1, #args do
        moneyList:Add(args[i])
    end
    self.moneyTableView:SetData(moneyList)
end

function UITempleReplaceView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UITempleSummon, nil, UIPopupName.UITempleReplace)
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
function UITempleReplaceView:Hide()
    UIBaseView.Hide(self)
    self.ctrl:Hide()
    self.previewHero:OnHide()
    self.moneyTableView:Hide()
    self.uiPrefabHeroList2View:ReturnPool()
end

--- @return void
function UITempleReplaceView:_SetUIHero()
    UIUtils.SetInteractableButton(self.config.buttonSelectHero, true)
    self.config.haveNotHero:SetActive(true)
    self.config.localizePleseSelectHero.gameObject:SetActive(true)
    self.config.haveHero:SetActive(false)
    self.config.buttonReplace.gameObject:SetActive(false)
end

function UITempleReplaceView:_SetPrefabHeroList(isShow)
    self.config.localizePleseSelectHero.gameObject:SetActive(not isShow and self.model.selectedHero == nil)
    self.config.prefabHeroList.gameObject:SetActive(isShow)
    self.config.buttonReplace.gameObject:SetActive(self.model.selectedHero ~= nil and not isShow)
end

--- @return void
function UITempleReplaceView:_InitPreviewHero()
    self.previewHero = PreviewReplaceHero(self.config.previewTempleReplace)
end

--- @return void
function UITempleReplaceView:_InitButtonListener()
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
        if self.cancelSave == true then
            TempleRequest.SaveReplace(self.prophetTreeInBound.heroInventoryId, false, function()
                self.prophetTreeInBound.isConverting = false
            end)
            self.cancelSave = false
        end
    end)
    self.config.buttonSelectHero.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.isShowingHeroList = not self.isShowingHeroList
        self:_SetPrefabHeroList(self.isShowingHeroList)
    end)

    self.config.buttonReplace.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local canReplace = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.PROPHET_WOOD, self.model.convertPrice))
        if canReplace then

            local callback = function(heroIdBeforeConvert, heroIdAfterConvert, heroInventoryId)
                self.model.money:Sub(MoneyType.PROPHET_WOOD, self.model.convertPrice)
                self.prophetTreeInBound.isConverting = true
                self.prophetTreeInBound.newHeroId = heroIdAfterConvert
                self.prophetTreeInBound.heroInventoryId = heroInventoryId
                UIUtils.SetInteractableButton(self.config.buttonSelectHero, false)
                self.config.buttonReplace.gameObject:SetActive(false)
                self.config.buttonCancel.gameObject:SetActive(true)
                self.config.buttonSave.gameObject:SetActive(true)
                self.cancelSave = false

                self.model.convertedHero = heroIdAfterConvert
                if heroIdBeforeConvert == self.ctrl:GetHeroSelected().heroId then
                    self:_UpdateConvertedHeroInfo()
                    local heroResource = self.ctrl:GetHeroSelected()
                    local newHeroResource = HeroResource.Clone(heroResource)
                    newHeroResource.heroId = heroIdAfterConvert
                    newHeroResource.heroItem = Dictionary()
                    for i, v in pairs(heroResource.heroItem:GetItems()) do
                        if i ~= HeroItemSlot.SKIN then
                            newHeroResource.heroItem:Add(i, v)
                        end
                    end
                    self.previewHero:ShowReplacedHero(newHeroResource)
                else
                    XDebug.Error("Data is not valid")
                end
            end

            local hero = self.ctrl:GetHeroSelected()
            if hero then
                TempleRequest.Replace(hero.inventoryId, callback)
            else
                XDebug.Error("hero is nil")
            end
        end
    end)

    self.config.buttonSave.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_SetUIHero()
        UIUtils.SetInteractableButton(self.config.buttonSelectHero, true)
        self.config.buttonCancel.gameObject:SetActive(false)
        self.config.buttonSave.gameObject:SetActive(false)

        --- @type HeroResource
        local heroResource = self.ctrl:GetHeroSelected()
        local onSuccess = function()
            --- @type HeroResource
            heroResource.heroId = self.model.convertedHero
            local skin = heroResource.heroItem:Get(HeroItemSlot.SKIN)
            if skin ~= nil then
                InventoryUtils.Add(ResourceType.Skin, skin, 1)
                heroResource.heroItem:RemoveByKey(HeroItemSlot.SKIN)
            end
            --self.model.selectedIconView.iconData.heroId = heroResource.heroId
            --self.model.selectedIconView:SetIconData(self.model.selectedIconView.iconData)
            InventoryUtils.Get(ResourceType.Hero):SortHeroDataBase()
            self.uiPrefabHeroList2View.heroList:SetData(self.model.heroResourceList)

            self.model.convertedHero = nil
            self.model.selectedHero = nil
            --self.model.selectedIconView = nil
            self.prophetTreeInBound.isConverting = false
        end

        TempleRequest.SaveReplace(heroResource.inventoryId, true, onSuccess)

        self.previewHero:RemoveReplacedHero()
        self.previewHero:RemoveSourceHero()
    end)

    self.config.buttonCancel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(self.model.convertedHero)
		local confirmCancel = function()
			UIUtils.SetInteractableButton(self.config.buttonSelectHero, true)
			self.config.buttonReplace.gameObject:SetActive(true)
			self.config.buttonCancel.gameObject:SetActive(false)
			self.config.buttonSave.gameObject:SetActive(false)

			self.model.convertedHero = nil
			self:_UpdateConvertedHeroInfo()
			self.previewHero:RemoveReplacedHero()
			self.cancelSave = true
		end

		if heroTier >= 6 then
			PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"), nil, confirmCancel)
		else
			confirmCancel()
		end
    end)

    self.config.buttonHeroInfoRight.onClick:AddListener(function()
        local heroResource = HeroResource.Clone(self.ctrl:GetHeroSelected())
        heroResource.heroId = self.model.convertedHero
        PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = heroResource })
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    end)
end

--- @return void
function UITempleReplaceView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("replace_hero_info"))
end

--- @return void
--- @param star number
function UITempleReplaceView:_SetButtonPrice(star)
    self.model.convertPrice = ResourceMgr.GetTempleSummonConfig():GetConvertPrice(star)
    self.config.textPriceReplace.text = tostring(self.model.convertPrice)
end

------------------- Formation Hero ----------------------------------------
function UITempleReplaceView:_CreateFormationHero()
    --- @return boolean
    ---@param heroIndex number
    ---@param heroResource HeroResource
    self.filterConditionAnd = function(heroIndex, heroResource)
        return heroResource:IsCanConvert()
    end

    --- @return void
    --- @param buttonHero HeroIconView
    self.buttonListener = function(heroIndex, buttonHero)
        local heroResource = self.model.heroResourceList:Get(heroIndex)
        local noti = ClientConfigUtils.GetNotiLockHero(heroResource)
        if noti ~= nil then
            SmartPoolUtils.ShowShortNotification(noti)
        else
            self.model.selectedHero = heroIndex
            --self.model.selectedIconView = buttonHero
            --- update ui
            self.config.haveNotHero:SetActive(false)
            self.config.haveHero:SetActive(true)
            self.config.buttonReplace.gameObject:SetActive(true)
            self.config.buttonCancel.gameObject:SetActive(false)
            self.config.buttonSave.gameObject:SetActive(false)

            self:_SetPrefabHeroList(false)

            self:_UpdateSelectedHeroInfo()

            self.model.convertedHero = nil
            self:_UpdateConvertedHeroInfo()

            self:_SetButtonPrice(heroResource.heroStar)

            self.previewHero:RemoveSourceHero()
            self.previewHero:ShowSourceHero(heroResource)
        end
    end
end

--- @return void
function UITempleReplaceView:_ShowHeroListView()
    --- @return void
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    local onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if ClientConfigUtils.CheckLockHero(heroResource) then
            buttonHero:ActiveMaskLock(true, UIUtils.sizeItem)
        else
            buttonHero:ActiveMaskLock(false)
        end
        buttonHero:EnableButton(true)
    end
    self.uiPrefabHeroList2View = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPrefabHeroList2View, self.config.prefabHeroList)
    self.uiPrefabHeroList2View.heroList:Init(self.buttonListener, nil, self.filterConditionAnd, nil, nil, onUpdateIconHero, onUpdateIconHero)
    self.uiPrefabHeroList2View.heroList:SetData(self.model.heroResourceList)
end

--- @return void
function UITempleReplaceView:_UpdateSelectedHeroInfo()
    assert(self.model.selectedHero)
    local hero = self.ctrl:GetHeroSelected()
    local name = LanguageUtils.LocalizeNameHero(hero.heroId)
    self:_SetNameHeroInfo(self.config.textHeroNameLeft, name)
    self:_SetFactionHeroInfo(self.config.iconFactionLeft, hero.heroId)
    self:_SetStarHeroInfo(self.config.starLeft, hero.heroStar)
    self:_SetLevelHeroInfo(self.config.textHeroLevelLeft, hero.heroLevel)
end

--- @return void
function UITempleReplaceView:_UpdateConvertedHeroInfo()
    self.config.buttonHeroInfoRight.gameObject:SetActive(self.model.convertedHero ~= nil)
    local hero = HeroResource.Clone(self.ctrl:GetHeroSelected())

    local name = "???"
    if self.model.convertedHero ~= nil then
        name = LanguageUtils.LocalizeNameHero(self.model.convertedHero)
    end

    self:_SetNameHeroInfo(self.config.textHeroNameRight, name)
    self:_SetFactionHeroInfo(self.config.iconFactionRight, hero.heroId)
    self:_SetStarHeroInfo(self.config.starRight, hero.heroStar)
    self:_SetLevelHeroInfo(self.config.textHeroLevelRight, hero.heroLevel)
end

--- @return void
--- @param image UnityEngine_UI_Image
--- @param heroId number
function UITempleReplaceView:_SetFactionHeroInfo(image, heroId)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    image.sprite = ResourceLoadUtils.LoadFactionIcon(faction)
end

--- @return void
--- @param image UnityEngine_UI_Image
--- @param star number
function UITempleReplaceView:_SetStarHeroInfo(image, star)
    local sprite = image.sprite
    local sizeStar1 = sprite.border.x + sprite.border.z
    local sizeStarDelta = sprite.bounds.size.x * 100 - sizeStar1
    image.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (star - 1), sprite.bounds.size.y * 100)
end

--- @return void
--- @param text TMPro_TextMeshProUGUI
--- @param level number
function UITempleReplaceView:_SetLevelHeroInfo(text, level)
    text.text = "Lv." .. tostring(level)
end

--- @return void
--- @param text TMPro_TextMeshProUGUI
--- @param name string
function UITempleReplaceView:_SetNameHeroInfo(text, name)
    text.text = name
end

function UITempleReplaceView:OnDestroy()
    self.previewHero:OnDestroy()
end