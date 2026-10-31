--- @class InBound
InBound = Class(InBound)

--- @return void
function InBound:Ctor()
    print("Need override this method, declare var here")
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function InBound:Deserialize(buffer)
    print("Need override this method")
end