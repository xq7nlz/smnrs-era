require "lua.client.scene.ui.common.BattleTeamView"
require "lua.client.core.network.friend.FriendRequest"

--- @class UIPreviewFriendView : UIBaseView
UIPreviewFriendView = Class(UIPreviewFriendView, UIBaseView)

--- @return void
--- @param model UIPreviewFriendModel
function UIPreviewFriendView:Ctor(model, ctrl)
    ---@type UIPreviewFriendConfig
    self.config = nil
    --- @type VipIconView
    self.heroIconView = nil
    --- @type BattleTeamView
    self.battleTeamView = nil
    --- @type boolean
    self.isBlock = false
    --- @type function
    self.callbackBlock = nil
    --- @type List
    self.listHeroIconView = List()
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIPreviewFriendModel
    self.model = model
end

--- @return void
function UIPreviewFriendView:OnReadyCreate()
    ---@type UIPreviewFriendConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.bg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonDelete.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRemove()
    end)
    self.config.buttonAdd.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickAdd()
    end)
    self.config.buttonBlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBlock()
    end)
    self.config.buttonSendMail.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSendMail()
    end)
end

--- @return void
function UIPreviewFriendView:InitLocalization()
    self.config.localizeBlock.text = LanguageUtils.LocalizeCommon("block")
    self.config.localizeSendMail.text = LanguageUtils.LocalizeCommon("send_mail")
    self.config.localizeDefensiveLineup.text = LanguageUtils.LocalizeCommon("formation")
end

function UIPreviewFriendView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

    if data == nil then
        return
    end
    self.callbackBlock = data.callbackBlock
    self.callbackRemoveFriend = data.callbackRemoveFriend
    self.callbackAddFriend = data.callbackAddFriend
    self.model.playerId = data.playerId
    self.model.userName = data.userName
    self.model.avatar = data.avatar
    self.model.level = data.level
    self.model.guildName = data.guildName
    self.model.battleTeamInfo = data.battleTeamInfo
    self.model.canAdd = data.canAdd
    self.model.canDelete = data.canDelete
    self.model.canSendMail = data.canSendMail
    self.model.canBlock = data.canBlock
    self.config.textUserName.text = data.userName
    self.model.listHero = data.listHero

    self:ShowPlayerInfo()

    self:ShowAvatar()

    self:ShowPower(data)

    self:ShowBattleTeamView()

    self.isBlock = zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST):IsBlock(self.model.playerId)

    self:UpdateUI()

    self:ShowListHero()
end

function UIPreviewFriendView:ShowPlayerInfo()
    if self.model.playerId ~= nil then
        self.config.textUserId.text = string.format("%s: %s",
                LanguageUtils.LocalizeCommon("id"),
                UIUtils.SetColorString(UIUtils.color2, self.model.playerId))
    else
        self.config.textUserId.text = ""
    end

    if self.model.guildName ~= nil then
        self.config.textGuild.text = string.format("%s: %s",
                LanguageUtils.LocalizeFeature(FeatureType.GUILD),
                UIUtils.SetColorString(UIUtils.green_dark, self.model.guildName))
    else
        self.config.textGuild.text = ""
    end
end

function UIPreviewFriendView:ShowAvatar()
    self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
    self.heroIconView:SetData2(self.model.avatar, self.model.level)
end

function UIPreviewFriendView:ShowPower(data)
    self.config.textAp.gameObject:SetActive(false)

    if data.power ~= nil then
        self.config.textAp.text = tostring(math.floor(data.power))
        self.config.textAp.gameObject:SetActive(true)
    elseif data.battleTeamInfo ~= nil then
        self.config.textAp.text = tostring(math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(data.battleTeamInfo)))
        self.config.textAp.gameObject:SetActive(true)
    end
end

function UIPreviewFriendView:ShowBattleTeamView()
    if self.model.battleTeamInfo ~= nil then
        self.battleTeamView = BattleTeamView(self.config.teamInfo)
        self.battleTeamView:Show()
        self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, self.model.battleTeamInfo)
        self.battleTeamView.uiTeamView:SetSummonerInfo(self.model.battleTeamInfo.summonerBattleInfo)
        self.battleTeamView.uiTeamView:ActiveBuff(false)
        self.battleTeamView.uiTeamView:ActiveLinking(false)
    end
end

--- @return void
function UIPreviewFriendView:Hide()
    UIBaseView.Hide(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
    end
    self:ReturnPoolListHero()
end

--- @return void
function UIPreviewFriendView:UpdateUI()
    ---@type boolean
    local isPlayer = (self.model.playerId == PlayerSettingData.playerId)
    ---@type boolean
    local isFriend = zg.playerData:GetMethod(PlayerDataMethod.FRIEND):IsContainFriend(self.model.playerId)
    self.config.buttonDelete.gameObject:SetActive(isPlayer == false and isFriend and self.model.canDelete)
    self.config.buttonAdd.gameObject:SetActive(isPlayer == false and isFriend == false and self.model.canAdd)
    self.config.buttonBlock.gameObject:SetActive(isPlayer == false and self.model.canBlock)
    self.config.buttonSendMail.gameObject:SetActive(isPlayer == false and self.model.canSendMail)
    self:UpdateButtonBlock()
end

--- @return void
function UIPreviewFriendView:UpdateButtonBlock()

end

--- @return void
function UIPreviewFriendView:OnClickRemove()
    local yesCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
        local callback = function(result)
            local onSuccess = function()
                ---@type HeroLinkingInBound
                local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
                if heroLinkingInBound ~= nil then
                    heroLinkingInBound.needUpdateLinking = true
                end
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("remove_friend_success"))
                PopupMgr.HidePopup(UIPopupName.UIPreviewFriend)
                if self.callbackRemoveFriend ~= nil then
                    self.callbackRemoveFriend(self.model.playerId)
                end
            end
            local onFailed = function(logicCode)
                XDebug.Log("FRIEND_DELETE Failed")
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.FRIEND_DELETE, UnknownOutBound.CreateInstance(PutMethod.Long, self.model.playerId), callback)
    end

    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("remove_friend"), nil, yesCallback)
end

--- @return void
function UIPreviewFriendView:OnClickAdd()
    FriendRequest.RequestAddFriend(self.model.playerId, function()
        PopupMgr.HidePopup(UIPopupName.UIPreviewFriend)
        if self.callbackAddFriend ~= nil then
            self.callbackAddFriend()
        end
    end)
end

--- @return void
function UIPreviewFriendView:OnClickBlock()
    local block = function()
        NetworkUtils.BlockPlayer(self.model.playerId, not self.isBlock, function()
            ---@type BlockPlayerInBound
            local blockPlayerInBound = zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST)
            if self.isBlock then
                blockPlayerInBound:Remove(self.model.playerId)
            else
                blockPlayerInBound:Add(self.model.playerId)
                ---@type PlayerFriendInBound
                local friendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
                if friendInBound ~= nil then
                    friendInBound:BlockFriendId(self.model.playerId)
                end
                ---@type PlayerFriendRecommendedInBound
                local playerFriendRecommendedInBound = zg.playerData:GetPlayerFriendRecommendedInBound()
                if playerFriendRecommendedInBound ~= nil then
                    playerFriendRecommendedInBound:RemoveFriendId(self.model.playerId)
                end
                friendInBound:CheckNotificationFriendRequest()
                friendInBound:CheckNotificationFriendList()

                ---@type MailDataInBound
                local mailDataInBound = zg.playerData:GetMethod(PlayerDataMethod.MAIL)
                if mailDataInBound ~= nil then
                    if mailDataInBound.needRequest == true then
                        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.MAIL }, function()
                            mailDataInBound:CheckEventNotificationPlayer()
                        end)
                    else
                        mailDataInBound:RemoveMailFriend(self.model.playerId)
                        mailDataInBound:CheckEventNotificationPlayer()
                    end
                end

                if self.callbackBlock ~= nil then
                    self.callbackBlock(self.model.playerId)
                end
                PopupMgr.HidePopup(UIPopupName.UIPreviewFriend)
            end
            self.isBlock = not self.isBlock
            self:UpdateButtonBlock()
        end)
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    end
    local cancel = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    end

    local notification = ""
    if self.isBlock then
        notification = LanguageUtils.LocalizeCommon("want_unblock")
    else
        notification = LanguageUtils.LocalizeCommon("want_block")
    end
    PopupUtils.ShowPopupNotificationYesNo(notification, cancel, block)
end

--- @return void
function UIPreviewFriendView:OnClickSendMail()
    PopupMgr.ShowPopup(UIPopupName.UIFriendMail, { ["id"] = self.model.playerId })
end

function UIPreviewFriendView:ShowListHero()
    if self.model.listHero == nil then
        return
    end
    self:ReturnPoolListHero()

    --- @param v HeroResource
    for _, v in ipairs(self.model.listHero:GetItems()) do
        ---@type HeroIconView
        local heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.listHeroAnchor)
        local heroIconData = HeroIconData.CreateByHeroResource(v)
        heroIconView:SetIconData(heroIconData)
        heroIconView:SetSize(150, 150)
        heroIconView:AddListener(function()
            local overrideStatDict = ClientConfigUtils.GetStatHero(v)
            PopupUtils.ShowPreviewHeroInfo(v, overrideStatDict)
        end)
        self.listHeroIconView:Add(heroIconView)
    end
end

function UIPreviewFriendView:ReturnPoolListHero()
    if self.listHeroIconView ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listHeroIconView:GetItems()) do
            v:ReturnPool()
        end
        self.listHeroIconView:Clear()
    end
end