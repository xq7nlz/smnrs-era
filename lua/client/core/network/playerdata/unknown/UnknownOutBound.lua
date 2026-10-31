require "lua.client.core.network.playerData.unknown.PutMethod"

--- @class UnknownOutBound : OutBound
UnknownOutBound = Class(UnknownOutBound, OutBound)

function UnknownOutBound:SetData(...)
    --- @type {}
    self.args = {...}

    if #self.args % 2 ~= 0 then
        XDebug.Log("UnknownOutBound: " .. LogUtils.ToDetail(self.args))
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UnknownOutBound:Serialize(buffer)
    for i = 1, #self.args, 2 do
        local method = UnknownOutBound.MethodDict:Get(self.args[i])
        method(buffer, self.args[i + 1])
    end
end

--- @return UnknownOutBound
function UnknownOutBound.CreateInstance(...)
    local inst = UnknownOutBound()
    inst:SetData(...)
    return inst
end

--- @return void
function UnknownOutBound:ToString()
    return LogUtils.ToDetail(self.args)
end

--- @type Dictionary
UnknownOutBound.MethodDict = Dictionary()

--- @return void
function UnknownOutBound.InitMethodDict()
    UnknownOutBound.MethodDict:Add(PutMethod.Sbyte, function(buffer, value)
        buffer:PutSbyte(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Byte, function(buffer, value)
        buffer:PutByte(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Short, function(buffer, value)
        buffer:PutShort(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Ushort, function(buffer, value)
        buffer:PutUshort(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Int, function(buffer, value)
        buffer:PutInt(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Uint, function(buffer, value)
        buffer:PutUint(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Long, function(buffer, value)
        buffer:PutLong(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Ulong, function(buffer, value)
        buffer:PutUlong(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Float, function(buffer, value)
        buffer:PutFloat(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.String, function(buffer, value)
        buffer:PutString(value)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.LongString, function(buffer, value)
        buffer:PutString(value, false)
    end)

    UnknownOutBound.MethodDict:Add(PutMethod.Bool, function(buffer, value)
        buffer:PutBool(value)
    end)
end

UnknownOutBound.InitMethodDict()