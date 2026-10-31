--- @class HeroFragmentInBound : BaseJsonInBound
HeroFragmentInBound = Class(HeroFragmentInBound, BaseJsonInBound)

--- @return void
function HeroFragmentInBound:InitDatabase()
    local jsonDatabase = json.decode(self.jsonData)
    InventoryUtils.Get(ResourceType.HeroFragment):InitDatabase(jsonDatabase)
end