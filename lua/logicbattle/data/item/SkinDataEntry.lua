--- @class SkinDataEntry
SkinDataEntry = Class(SkinDataEntry)

--- @return void
--- @param data table
function SkinDataEntry:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)

    --- @type number
    self.rarity = tonumber(data.rarity)

    --- @type List<BaseItemOption>
    self.optionList = List()
    
    --- @type boolean
    self.isHidden = false
    if (data.isHidden ~= nil) then
        self.isHidden = MathUtils.ToBoolean(data.isHidden)
       -- XDebug.Log("self.isHidden" .. tostring(self.isHidden))
    end
end

--- @return void
function SkinDataEntry:Validate()
    if MathUtils.IsInteger(self.id) == false then
        assert(false)
    end

    if MathUtils.IsInteger(self.rarity) == false then
        assert(false)
    end
end

--- @return void
--- @param itemOption BaseItemOption
function SkinDataEntry:AddOption(itemOption)
    self.optionList:Add(itemOption)
end

--- @return void
--- @param hero BaseHero
function SkinDataEntry:ApplyToHero(hero)
    for i = 1, self.optionList:Count() do
        ---@type BaseItemOption
        local option = self.optionList:Get(i)
        option:ApplyToHero(hero)
    end
end