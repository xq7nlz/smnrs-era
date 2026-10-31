--- @class UIDungeonBuffView : UIBaseView
UIDungeonBuffView = Class(UIDungeonBuffView, UIBaseView)

--- @return void
--- @param model UIDungeonBuffModel
function UIDungeonBuffView:Ctor(model)
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type DungeonBuffCardView
    self.chooseCard = nil
    --- @type number
    self.stage = nil
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIDungeonBuffModel
    self.model = model
end

--- @return void
function UIDungeonBuffView:OnReadyCreate()
    ---@type UIDungeonBuffConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.itemsTable = ItemsTableView(self.config.root)
    self:InitButtonListener()
end

--- @return void
function UIDungeonBuffView:InitButtonListener()
    self.config.tapToClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIDungeonBuffView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.stage = data.stage
    self.isSmash = data.isSmash
    self.canCloseByBackButton = data.isSmash
    self:UpdateTableView(data.buffList)
    self:UpdateText()
    self:UpdateTapToClose()
end

function UIDungeonBuffView:UpdateText()
    if self.isSmash then
        --- @type DungeonInBound
        local server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
        self.config.textRemaining.text = string.format("%s %d", LanguageUtils.LocalizeCommon("remaining"), server.buffSelectionStageList:Count() - 1)
    else
        self.config.textRemaining.text = ""
    end
end

--- @return void
function UIDungeonBuffView:UpdateTapToClose()
    self.config.tapToClose.enabled = self.isSmash
end

function UIDungeonBuffView:UpdateTableView(buffList)
    self.itemsTable:Show()
    self.itemsTable:SetData(buffList, UIPoolType.DungeonBuffCardView)
    --- @param v DungeonBuffCardView
    for i, v in ipairs(self.itemsTable.iconViewList:GetItems()) do
        v.canScale = true
        v.canSetNumber = false
        v:SetQuantity()
        v:SetButtonText()

        local pickBuff = function()
            DungeonRequest.PickBuff(self.stage, i, function()
                v:AddBuff()
                PopupMgr.HidePopup(self.model.uiName)
                RxMgr.pickDungeonBuff:Next({
                    ['buffData'] = v.buffData,
                    ['isActiveBuff'] = v:IsActiveBuff(),
                    ['sourceRect'] = v.config.iconItemDungeonBuff:GetComponent(ComponentName.UnityEngine_RectTransform),
                    ['useOnHero'] = false,
                    ['isSmash'] = self.isSmash
                })
            end)
        end

        if self.isSmash then
            v:ChooseCard(true)
            v:AddListener(nil, pickBuff)
        else
            v:AddListener(function()
                if self.chooseCard == nil then
                    v:ChooseCard(true)
                    self.chooseCard = v
                elseif self.chooseCard == v then
                    v:ChooseCard(false)
                    self.chooseCard = nil
                else
                    v:ChooseCard(true)
                    self.chooseCard:ChooseCard(false)
                    self.chooseCard = v
                end
            end, pickBuff)
        end
    end
    Coroutine.start(function()
        coroutine.waitforseconds(0.11)
        uiCanvas:ShowTapToClose(self.isSmash)
    end)
end

--- @return void
function UIDungeonBuffView:Hide()
    UIBaseView.Hide(self)
    self.chooseCard = nil
    self.itemsTable:Hide()
end

