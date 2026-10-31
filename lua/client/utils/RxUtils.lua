require("lua.client.core.RxMgr")

--- @class RxUtils
RxUtils = {}

--- @return Observable
--- @param opCode OpCode
RxUtils.WaitOfCode = function(opCode)
    return RxMgr.receiveOpCode
            :Sample(RxMgr.receiveLogicCode
                :Filter(function(logicCode)
                    return logicCode == LogicCode.SUCCESS
                end)
            ):Filter(function(localOpCode)
                return localOpCode == opCode
            end)
end