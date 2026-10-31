require "lua.client.scene.ui.home.uiTempleSummon.previewTempleSummon.TempleOrbs.TempleOrbs"

--- @class PreviewTempleSummon : BgWorldView
PreviewTempleSummon = Class(PreviewTempleSummon, BgWorldView)

--- @param transform UnityEngine_Transform
--- @param view UITempleSummonView
function PreviewTempleSummon:Ctor(transform, view)
    BgWorldView.Ctor(self, transform)
    --- @type UITempleSummonView
    self.view = view
    --- @type UITempleSummonModel
    self.model = view.model

    --- @type TempleOrbs
    self.templeOrbs = TempleOrbs(self.config.templeOrbs, self.model)
end

function PreviewTempleSummon:InitConfig(transform)
    --- @type PreviewTempleSummonConfig
    self.config = UIBaseConfig(transform)
end

function PreviewTempleSummon:OnShow()
    self:SetActive(true)
end

function PreviewTempleSummon:OnHide()
    if self.templeOrbs ~= nil then
        self.templeOrbs:OnHide()
    end
    self:SetActive(false)
end

function PreviewTempleSummon:ShowTempleOrbs()
    self.templeOrbs:DoFadeOrbs()
end

function PreviewTempleSummon:MoveLeft()
    self.templeOrbs:MoveLeft()
end

function PreviewTempleSummon:MoveRight()
    self.templeOrbs:MoveRight()
end

function PreviewTempleSummon:OnSummon()
    self.config.fxTempleOrbSummon:Play()
end