--- @class HeroCollectionInBound : BaseJsonInBound
HeroCollectionInBound = Class(HeroCollectionInBound, BaseJsonInBound)

--- @return void
function HeroCollectionInBound:InitDatabase()
    local jsonDatabase = json.decode(self.jsonData)
    InventoryUtils.Get(ResourceType.Hero):InitDatabase(jsonDatabase)
    --XDebug.Log("Finish Request Hero Collection: " .. self.jsonData)
end