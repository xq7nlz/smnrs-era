
--- @class ClientStopWatch
ClientStopWatch = Class(ClientStopWatch)

--- @return void
function ClientStopWatch:Ctor()
    self.startList = List()
end

--- @return void
function ClientStopWatch:Start()
    self.startList:Add(os.clock())
end

--- @return void
--- @param tag string
function ClientStopWatch:Stop(tag)
    local lastTime = self.startList:Get(self.startList:Count())
    local elapsedPerRun = os.clock() - lastTime
    self.startList:RemoveByIndex(self.startList:Count())
    if tag ~= nil then
        print(string.format("[%s] Elapsed = %s ms, [Count] %d", tag, elapsedPerRun * 1000, self.startList:Count()))
    else
        print(string.format("Elapsed = %s ms, [Count] %d", elapsedPerRun * 1000, self.startList:Count()))
    end

end