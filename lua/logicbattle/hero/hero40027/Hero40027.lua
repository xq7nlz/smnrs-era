--- @class Hero40027 : BaseHero Airyuu
Hero40027 = Class(Hero40027, BaseHero)

function Hero40027:Ctor()
    BaseHero.Ctor(self)

    --- @type boolean is in dragon state or not
    self.isDragonForm = false
end

--- @return HeroInitializer
function Hero40027:CreateInitializer()
    return Hero40027_Initializer(self)
end

--- @return Hero40027
function Hero40027:CreateInstance()
    return Hero40027()
end

--- @return Hero40027
--- @param isDragonForm boolean
function Hero40027:OnTransform(isDragonForm)
    if self:IsDead() then
        return
    end

    if (self.isDragonForm ~= isDragonForm) then
        self.skillController:OnTransform(isDragonForm)
    end

    self.isDragonForm = isDragonForm

    local transformLog = AiryuuTransformResult(self, self, isDragonForm)
    ActionLogUtils.AddLog(self.battle, transformLog)
end

--- @return string
function Hero40027:ToDetailString()
   return BaseHero.ToDetailString(self) .. string.format("isDragon = %s\n", tostring(self.isDragonForm))
end

return Hero40027