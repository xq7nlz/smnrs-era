require "lua.client.scene.ui.common.SkillHeroView"

--- @class UISkillPreviewView : UIBaseView
UISkillPreviewView = Class(UISkillPreviewView, UIBaseView)

--- @return void
--- @param model UISkillPreviewModel
function UISkillPreviewView:Ctor(model, ctrl)
    --- @type UISkillPreviewConfig
    self.config = nil
    --- @type SkillHeroView
    self.skillHeroView = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UISkillPreviewModel
    self.model = self.model
end

--- @return void
function UISkillPreviewView:OnReadyCreate()
    ---@type UISkillPreviewConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.bg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UISkillPreviewView:InitLocalization()
    self.config.textUse.text = LanguageUtils.LocalizeCommon("use_skill")
    self.config.textEquiped.text = LanguageUtils.LocalizeCommon("in_use_skill")
end

--- @return void
function UISkillPreviewView:Init(result)
    if result ~= nil then
        self.model.heroId = result.heroId
        self.model.skillId = result.skillId
        self.model.level = result.level
        self.model.unlock = result.unlock
        self.model.anchor = result.anchor
        self.model.position = result.position
        self.model.class = result.class
        self.model.star = result.star

        self.config.buttonGreen.onClick:RemoveAllListeners()
        if result.callbackUse ~= nil then
            self.config.buttonGreen.transform.parent.gameObject:SetActive(true)
            self.config.buttonGreen.gameObject:SetActive(true)
            self.config.textEquiped.transform.parent.gameObject:SetActive(false)
            self.config.buttonGreen.onClick:AddListener(function()
                result.callbackUse()
                self:OnClickBackOrClose()
            end)
        elseif result.equip == true then
            self.config.buttonGreen.transform.parent.gameObject:SetActive(true)
            self.config.buttonGreen.gameObject:SetActive(false)
            self.config.textEquiped.transform.parent.gameObject:SetActive(true)
        else
            self.config.buttonGreen.transform.parent.gameObject:SetActive(false)
        end

        if self.skillHeroView == nil then
            self.skillHeroView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkillHeroIconView, self.config.skillInfo)
        end

        if result.skillId == 1 then
            self.config.textActiveSkill.text = LanguageUtils.Localize("active_skill", LanguageUtils.Skill)
        else
            self.config.textActiveSkill.text = LanguageUtils.Localize("passive_skill", LanguageUtils.Skill)
        end

        if self.model.heroId ~= nil then
            self.skillHeroView:SetData(self.model.heroId, self.model.skillId, self.model.level)
            self.config.textSkillName.text = LanguageUtils.LocalizeHeroSkillName(self.model.heroId, self.model.skillId)
            self:SetSkinContent(LanguageUtils.LocalizeSkillDescription(self.model.heroId, self.model.skillId, math.max(self.model.level, 1)))
        else
            self.skillHeroView:SetDataSkillMain(self.model.class, self.model.skillId, self.model.star)
            self.config.textSkillName.text = LanguageUtils.LocalizeSummonerSkillName(self.skillHeroView.class,
                    self.skillHeroView.skillId, self.skillHeroView.tier)
            self:SetSkinContent(LanguageUtils.LocalizeSkillSummonerDescription(self.skillHeroView.class,
                    self.skillHeroView.skillId, self.skillHeroView.tier, self.skillHeroView.lv))
        end
        if self.model.anchor == nil then
            self.config.rectTransform.pivot = U_Vector2(0.5, 0.5)
        else
            self.config.rectTransform.pivot = self.model.anchor
        end

        if self.model.unlock == nil then
            self.config.textUnlockSkill.gameObject:SetActive(false)
        else
            self.config.textUnlockSkill.gameObject:SetActive(true)
            self.config.textUnlockSkill.text = string.format(LanguageUtils.LocalizeCommon("unlock_star"), self.model.unlock)
        end

        UIUtils.SetInteractableButton(self.config.bg, false)
        Coroutine.start(function()
            self.config.skillPreview.enabled = false
            coroutine.waitforendofframe()
            self.config.skillPreview.enabled = true
            coroutine.waitforendofframe()
            self.config.skillPreview.enabled = false
            coroutine.waitforendofframe()
            self.config.skillPreview.enabled = true
            if self.model.position == nil then
                self.config.rectTransform.localPosition = U_Vector3.zero
            else
                self.config.rectTransform.position = self.model.position
            end
            UIUtils.SetInteractableButton(self.config.bg, true)
        end)
    end
end

--- @return void
function UISkillPreviewView:OnReadyShow(result)
    self:Init(result)
end

--- @return void
function UISkillPreviewView:Hide()
    UIBaseView.Hide(self)
    if self.skillHeroView ~= nil then
        self.skillHeroView:ReturnPool()
        self.skillHeroView = nil
    end
    ResourceLoadUtils.UnloadFolderAtlas()
    self.config.rectTransform.localPosition = U_Vector3(10000, 10000, 0)
end

function UISkillPreviewView:SetSkinContent(skillContent)
    self.config.textNoiDungSkill.text = string.gsub(skillContent, ".0%%", "%%")
end