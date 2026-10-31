Rx = require "lua.client.utils.Rx.Rx"
Subscription = Rx.Subscription
Subject = Rx.Subject
BehaviorSubject = Rx.BehaviorSubject

---@class RxMgr
RxMgr = {
    updateRound = Subject.Create(),
    battleSpeed = Subject.Create(),
    skipBattle = Subject.Create(),
    nextTurn = Subject.Create(),
    switchMode = Subject.Create(),
    finishTurn = Subject.Create(),
    startBattle = Subject.Create(),
    finishBattle = Subject.Create(),
    pauseBattle = Subject.Create(),
    resumeBattle = Subject.Create(),

    switchMainCharacter = Subject.Create(),
    registerSuccess = Subject.Create(),
    finishName = Subject.Create(),
    changeAvatar = Subject.Create(),

    --- Event in inventory
    changeResource = Subject.Create(),
    levelUp = Subject.Create(),
    vipLevelUp = Subject.Create(),

    eventStateChange = Subject.Create(),

    notificationRequestMail = Subject.Create(),
    notificationRequestFriend = Subject.Create(),
    notificationRequestUiFriend = Subject.Create(),

    notificationUiMail = Subject.Create(),
    notificationUiFriend = Subject.Create(),
    notificationUiDailyReward = Subject.Create(),

    notificationRequestQuest = Subject.Create(),
    notificationPurchasePacks = Subject.Create(),
    notificationVideoRewarded = Subject.Create(),
    notificationHandOfMidas = Subject.Create(),
    notificationUnreadChatMessage = Subject.Create(),

    buyCompleted = Subject.Create(),
    buyPackDealCompleted = Subject.Create(),

    purchaseProduct = Subject.Create(),
    purchaseTrialProduct = Subject.Create(),

    requestAllDataComplete = Subject.Create(),

    tutorialFocus = Subject.Create(),
    tutorialView = Subject.Create(),

    guildMemberKicked = Subject.Create(),
    guildMemberAdded = Subject.Create(),
    guildWarRegistered = Subject.Create(),

    --- popup
    finishLoadPopup = Subject.Create(),
    closePopup = Subject.Create(),

    --- Loading
    notificationLoading = Subject.Create(),
    hideLoading = Subject.Create(),
    finishLoading = Subject.Create(),

    --- Resource Asset in game
    unloadUnusedResource = Subject.Create(),

    applicationPause = Subject.Create(),

    receiveOpCode = Subject.Create(),
    receiveLogicCode = Subject.Create(),

    summonerStar = Subject.Create(),

    friendAddSuccess = Subject.Create(),

    notificationEventPopup = Subject.Create(),

    arenaRefresh = Subject.Create(),

    arenaChooseRivalRefresh = Subject.Create(),

    transactionUpdated = Subject.Create(),

    updateGuildInfo = Subject.Create(),

    updateQuestTreeComplete = Subject.Create(),

    updateBattleUI = Subject.Create(),

    changeLanguage = Subject.Create(),

    serverNotification = Subject.Create(),

    downloadAssetBundle = Subject.Create(),

    finishTutorial = Subject.Create(),

    disconnect = Subject.Create(),

    switchScene = Subject.Create(),

    pickDungeonBuff = Subject.Create(),

    mktTracking = Subject.Create(),

    handShakeComplete = Subject.Create(),

    connectComplete = Subject.Create(),

    showFragment = Subject.Create(),

    notificationEventIap = Subject.Create(),

    idleDefenseMode = Subject.Create(),

    notificationRequestLinking = Subject.Create(),

    notificationRequestListSupportHero = Subject.Create(),

    featureConfigUpdated = Subject.Create(),

    notificationWatchAds = Subject.Create(),

    domainUpdated = Subject.Create(),

    onIAPInitializedComplete = Subject.Create(),

    notificationRequestCommunity = Subject.Create(),

    notificationRequestCommunityTotal = Subject.Create(),

    notificationRequestCommunityFriend = Subject.Create()
}

function RxMgr.CreateFunction(self, func)
    return function(...)
        func(self, ...)
    end
end

function RxMgr.Reset()
    RxMgr.handShakeComplete = Subject.Create()
    RxMgr.connectComplete = Subject.Create()
end