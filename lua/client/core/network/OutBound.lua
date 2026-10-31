--- @class OutBound
OutBound = Class(OutBound)

--- @return void
function OutBound:Ctor()
    assert(false,"Need override this method, declare var here")
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function OutBound:Serialize(buffer)
    assert(false,"Need override this method")
end