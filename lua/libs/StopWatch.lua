require "lua.libs.Class"

--- @class StopWatch
StopWatch = Class(StopWatch)

--- @return void
function StopWatch:Ctor()
    --- @type number
    self.totalElapsed = 0

    --- @type number
    self.numberRun = 0
end

--- @return void
function StopWatch:Start()
    self.totalElapsed = 0
    self.numberRun = 0

    self.startTime = os.clock()
end

--- @return void
--- @param tag string
function StopWatch:Stop(tag)
    local elapsedPerRun = os.clock() - self.startTime
    self.totalElapsed = self.totalElapsed + elapsedPerRun

    self.numberRun = self.numberRun + 1

    if tag ~= nil then
        print(string.format("[%s] Elapsed = %s ms", tag, elapsedPerRun * 1000))
    else
        print(string.format("Elapsed = %s ms", elapsedPerRun * 1000))
    end
end

--- @return void
--- @param tag string
function StopWatch:PrintResult(tag)
    local averageElapsed
    if self.numberRun > 1 then
        averageElapsed = self.totalElapsed / self.numberRun
    else
        averageElapsed = self.totalElapsed
    end

    if tag ~= nil then
        print(string.format("[%s] Total elapsed = %s ms, average elapsed = %s ms",
                tag, self.totalElapsed * 1000, averageElapsed * 1000))
    else
        print(string.format(" Total elapsed = %s ms, average elapsed = %s ms",
                self.totalElapsed * 1000, averageElapsed * 1000))
    end
end