---COMMENT_CONFIG    require("lua.client.scene.ui.home.uiHeroMenu.HeroStatChangeConfig")

--- @class HeroStatChangeView
HeroStatChangeView = Class(HeroStatChangeView)

--- @return void
--- @param transform UnityEngine_Transform
function HeroStatChangeView:Ctor(transform)
    --- @type HeroStatChangeConfig
    ---@type HeroStatChangeConfig
    self.config = UIBaseConfig(transform)
    self.stat1 = nil
    self.stat2 = nil
end

--- @return void
--- @param stat string
function HeroStatChangeView:SetLocalizeStat(stat)
    self.config.stat.text = stat
end

--- @return void
--- @param stat1 number
--- @param stat2 number
function HeroStatChangeView:ChangeStat(stat1, stat2, percent)
    self.percent = percent
    if percent == true then
        self.stat1 = stat1 * 100
        self.stat2 = stat2 * 100
    else
        self.stat1 = stat1
        self.stat2 = stat2
    end
    self:HideEffect()
end

function HeroStatChangeView:HideEffect()
    self.config.animator.enabled = false
    self.config.add:SetActive(false)
    self.config.sub:SetActive(false)
    self.config.number.gameObject:SetActive(false)
    self.config.gameObject:SetActive(false)
    self.config.stat.gameObject:SetActive(false)
end

function HeroStatChangeView:RunEffect()
    local stat = self.stat2 - self.stat1
    --local stat = MathUtils.Round(self.stat2) - MathUtils.Round(self.stat1)
    if self.percent == true then
        stat = MathUtils.RoundDecimal(stat,1)
    else
        stat = MathUtils.Round(stat)
    end

    local color = UIUtils.green_light
    if stat < 0 then
        color = UIUtils.color7
    end
    if stat > 0 then
        self.config.gameObject:SetActive(true)
        self.config.add:SetActive(true)
        self.config.sub:SetActive(false)
        self.config.stat.gameObject:SetActive(true)
        self.config.number.gameObject:SetActive(true)
        self.config.number.color = U_Color(1, 1, 1, 1)
        if self.percent == true then
            self.config.number.text = string.format("<color=#%s>+%s</color>", color, stat .. "%")
        else
            self.config.number.text = string.format("<color=#%s>+%s</color>", color, stat)
        end
        self.config.animator.enabled = true
    elseif stat < 0 then
        self.config.gameObject:SetActive(true)
        self.config.add:SetActive(false)
        self.config.sub:SetActive(true)
        self.config.stat.gameObject:SetActive(true)
        self.config.number.gameObject:SetActive(true)
        self.config.number.color = U_Color(1, 1, 1, 1)
        if self.percent == true then
            self.config.number.text = string.format("<color=#%s>%s</color>", color, stat .. "%")
        else
            self.config.number.text = string.format("<color=#%s>%s</color>", color, stat)
        end
        self.config.animator.enabled = true
    else
        self.config.gameObject:SetActive(false)
    end
end