--- @class UILunarBossChapterItemView : MotionIconView
UILunarBossChapterItemView = Class(UILunarBossChapterItemView,IconView)

--- @return void
function UILunarBossChapterItemView:Ctor()
    IconView.Ctor(self)
    self.chapter = nil
    ---@type function
    self.callbackClick = nil
end

--- @return void
function UILunarBossChapterItemView:SetPrefabName()
    self.prefabName = 'boss_lunar_chapter'
    self.uiPoolType = UIPoolType.UILunarBossChapterItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UILunarBossChapterItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIBossLunarChapterConfig
    self.config = UIBaseConfig(transform)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        self:OnClickInfo()
    end)
end

--- @return void
function UILunarBossChapterItemView:InitLocalization()

end

--- @return void
---@param chapter number
---@param point number
function UILunarBossChapterItemView:SetData(chapter, point, callbackClick)
    self.chapter = chapter
    self.callbackClickInfo = callbackClick
    self.config.textFireworkValue.text = point
    self.config.iconBossChapter.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconChapterLunarBoss, string.format("icon_boss_chapter%s_on", chapter))
    self.config.iconBossChapter:SetNativeSize()
end

--- @return void
---@param chapterUnlock number
function UILunarBossChapterItemView:SetUnlockBoss(chapterUnlock, chapterPass)
    self.config.iconBossChapter.color = U_Color(1,1,1,1)
    if self.chapter <= chapterPass then
        self.config.iconBossChapter.material = ResourceLoadUtils.LoadMaterial("ui_gray_mat")
    elseif self.chapter > chapterUnlock then
        self.config.iconBossChapter.material = nil
        self.config.iconBossChapter.color = U_Color(1,1,1,0.5)
    else
        self.config.iconBossChapter.material = nil
    end
end

--- @return void
function UILunarBossChapterItemView:OnClickInfo()
    if self.callbackClickInfo ~= nil then
        self.callbackClickInfo(self)
    end
end

return UILunarBossChapterItemView