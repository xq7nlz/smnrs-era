--- @class JobState
JobState = {
    WAIT = 1,
    DOING = 2,
    DONE = 3,
    ERROR = 4,
}

--- @class Job
Job = {}
Job.__index = Job

---@param j1 Job
---@param j2 Job
Job.__add = function(j1, j2)          -- AND
    return Job(function (onSuccess, onFailed)
        local successOneJob = function()
            if j1:IsDone() and j2:IsDone() and onSuccess ~= nil then
                onSuccess()
            end
        end
        j1:Complete(successOneJob, onFailed)
        j2:Complete(successOneJob, onFailed)
    end)
end

---@param j1 Job
---@param j2 Job
Job.__sub = function(j1, j2)          -- AND
    return Job(function (onSuccess, onFailed)
        local successOneJob = function()
            if j1:IsDone() and j2:IsError() and onSuccess ~= nil then
                onSuccess()
            end
        end
        j1:Complete(successOneJob, onFailed)
        j2:Complete(onFailed, successOneJob)
    end)
end

---@param j1 Job
---@param j2 Job
Job.__div = function(j1, j2)          -- OR
    return Job(function (onSuccess, onFailed)
        local failedOneJob = function()
            if j1:IsError() and j2:IsError() and onFailed ~= nil then
                onFailed()
            end
        end
        j1:Complete(onSuccess, failedOneJob)
        j2:Complete(onSuccess, failedOneJob)
    end)
end

---@param j1 Job
---@param j2 Job
Job.__concat = function(j1, j2)      -- DEPENDENCE
    return Job(function (onSuccess, onFailed)
        j1:Complete(function ()
            j2:Complete(onSuccess, onFailed)
        end , onFailed)
    end)
end

---@param j1 Job
Job.__unm = function(j1)                -- NOT
    return Job(function (onSuccess, onFailed)
        j1:Complete(onFailed, onSuccess)
    end)
end

local meta = {}
meta.__call = function(_, execute)
        ---@type Job
        local self = {}
        ---@type function
        self.execute = execute
        ---@type table
        self.dependence = {}
        ---@type table
        self.success = {}
        ---@type table
        self.fail = {}
        ---@type JobState
        self.state = JobState.WAIT
        self.data = nil
        self.onSuccess = function(data)
            self.state = JobState.DONE
            self.data = data
            for _, v in pairs(self.success) do
                if v ~= nil then
                    v(data)
                end
            end
        end
        self.onFail = function(data)
            self.state = JobState.ERROR
            self.data = data
            for _, v in pairs(self.fail) do
                if v ~= nil then
                    v(data)
                end
            end
        end
        return setmetatable(self, Job)
    end
setmetatable(Job, meta)

---@return JobState
function Job:IsDone()
    return self.state == JobState.DONE
end

---@return JobState
function Job:IsError()
    return self.state == JobState.ERROR
end

---@return JobState
function Job:IsComplete()
    return self:IsDone() or self:IsError()
end

---@return Job
function Job:SetDependence(...)
    if self.state == JobState.WAIT then
        self.dependence = {...}
        ---@param job Job
        for _, job in pairs(self.dependence) do
            job:Complete(function ()
                if self.state == JobState.DOING then
                    self:CheckSuccessDependency()
                end
            end, self.onFail)
        end
    else
        XDebug.Error("Not AddDependence after Job Run")
    end
    return self
end

---@return JobState
function Job:CheckSuccessDependency()
    local success = true
    ---@param job Job
    for _, job in pairs(self.dependence) do
        if job ~= nil and job.state ~= JobState.DONE then
            success = false
            break
        end
    end
    if success then
        self:Execute()
    end
end

---@return void
function Job:OnSuccess(data)
    self.state = JobState.DONE
    self.data = data
    for _, v in pairs(self.success) do
        if v ~= nil then
            v(data)
        end
    end
end

---@return void
function Job:OnFail(data)
    self.state = JobState.ERROR
    self.data = data
    for _, v in pairs(self.fail) do
        if v ~= nil then
            v(data)
        end
    end
end

---@return void
function Job:Execute()
    self.execute(self.onSuccess, self.onFail)
end

---@return void
function Job:Complete(callbackSuccess, callbackFailed)
    if self.state == JobState.DONE then
        if callbackSuccess ~= nil then
            callbackSuccess(self.data)
        end
    elseif self.state == JobState.ERROR then
        if callbackFailed ~= nil then
            callbackFailed(self.data)
        end
    else
        if callbackSuccess ~= nil then
            table.insert(self.success, callbackSuccess)
        end
        if callbackFailed ~= nil then
            table.insert(self.fail, callbackFailed)
        end
        if self.state == JobState.WAIT then
            self.state = JobState.DOING
            self:CheckSuccessDependency()
        end
    end
end