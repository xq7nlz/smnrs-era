--- @class BindingHeroInBound : OutBound
BindingHeroInBound = Class(BindingHeroInBound, OutBound)

function BindingHeroInBound:Ctor(inventory, isOwnHero, friendId)
    self.inventory = inventory
    self.isOwnHero = isOwnHero
    if isOwnHero == false then
        self.friendId = friendId
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function BindingHeroInBound:Serialize(buffer)
    buffer:PutLong(self.inventory)
    buffer:PutBool(self.isOwnHero)
    if self.isOwnHero == false then
        buffer:PutLong(self.friendId)
    end
end
