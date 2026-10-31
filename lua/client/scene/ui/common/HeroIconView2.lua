local SIZE_FRAME_HERO_ICON = U_Vector2(148, 148)
local SIZE_HERO_ICON = U_Vector2(135, 135)
--- @class HeroIconView2 : HeroIconView
HeroIconView2 = Class(HeroIconView2, HeroIconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function HeroIconView2:Ctor(transform)
    --- @type HeroIcon2Config
    self.config = nil
    HeroIconView.Ctor(self, transform)
end

--- @return void
function HeroIconView2:SetPrefabName()
    self.prefabName = 'hero_icon_info_2'
    self.uiPoolType = UIPoolType.HeroIconView2
end

function HeroIconView2:UpdateBarView(hpPercent,power)
    if hpPercent == 0 then
        self:SetState(false)
    else
        self:SetState(true)
    end
    self.config.rectHp:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, hpPercent * 141)
    self.config.rectPower:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, power/HeroConstants.MAX_HERO_POWER * 145)
end

function HeroIconView2:SetState(isAlive)
    self:ActiveMaskSelect(false)
    UIUtils.SetActiveColor(self.config.gameObject,isAlive)
end

function HeroIconView2:SetActiveBarView(isActive)
    self.config.thanhMau:SetActive(isActive)
    self.config.thanhNo:SetActive(isActive)
end

return HeroIconView2