local util = {}

util.pack = table.pack or function(...) return { n = select('#', ...), ... } end
util.unpack = table.unpack
util.eq = function(x, y) return x == y end
util.noop = function() end
util.identity = function(x) return x end
util.constant = function(x) return function() return x end end
util.isa = function(object, class)
    return type(object) == 'table' and getmetatable(object).__index == class
end
util.tryWithObserver = function(observer, fn, ...)
    local success, result = pcall(fn, ...)
    if not success then
        observer:Error(result)
    end
    return success, result
end

--- @class Subscription
local Subscription = {}
Subscription.__index = Subscription
Subscription.__tostring = util.constant('Subscription')

---@return Subscription
function Subscription.Create(action)
    ---@type Subscription
    local self = {}
    self.action = action or util.noop
    self.unsubscribed = false
    return setmetatable(self, Subscription)
end

function Subscription:Unsubscribe()
    if self.unsubscribed then return end
    self.action(self)
    self.unsubscribed = true
end

---@param own table
function Subscription:AddSubscription(own)
    if own ~= nil then
        if own.__subscriptions == nil then
            own.__subscriptions = {}
        end
        table.insert(own.__subscriptions, self)
    end
    return self
end

---@param own table
function Subscription.RemoveAllSubscription(own)
    if own ~= nil and own.__subscriptions ~= nil then
        for i = #own.__subscriptions, 1, -1 do
            ---@type Subscription
            local subscription = own.__subscriptions[i]
            subscription:Unsubscribe()
            table.remove(own.__subscriptions, i)
        end
    end
end

--- @class Observer
local Observer = {}
Observer.__index = Observer
Observer.__tostring = util.constant('Observer')

---@return Observer
---@param onNext function
---@param onError function
---@param onCompleted function
function Observer.Create(onNext, onError, onCompleted)
    ---@type Observer
    local self = {}
    self.onNext = onNext or util.noop
    self.onError = onError or error
    self.onCompleted = onCompleted or util.noop
    self.stopped = false
    return setmetatable(self, Observer)
end

function Observer:Next(...)
    if not self.stopped then
        self.onNext(...)
    end
end

function Observer:Error(message)
    if not self.stopped then
        self.stopped = true
        self.onError(message)
    end
end

function Observer:Complete()
    if not self.stopped then
        self.stopped = true
        self.onCompleted()
    end
end

--- @class Observable
local Observable = {}
Observable.__index = Observable
Observable.__tostring = util.constant('Observable')

---@return Observable
function Observable.Create(subscribe)
    ---@type Observable
    local self = {}
    self.subscribe = subscribe
    return setmetatable(self, Observable)
end

---@return Subscription
---@param onNext function
---@param onError function
---@param onCompleted function
function Observable:Subscribe(onNext, onError, onCompleted)
    if type(onNext) == 'table' then
        return self.subscribe(onNext)
    else
        return self.subscribe(Observer.Create(onNext, onError, onCompleted))
    end
end

---@return Observable
---@param name string
---@param formatter function
function Observable:Print(name, formatter)
    name = name and (name .. ' ') or ''
    formatter = formatter or tostring

    local onNext = function(...) print(name .. ' onNext: ' .. formatter(...)) end
    local onError = function(e) print(name .. ' onError: ' .. e) end
    local onCompleted = function() print(name .. ' onCompleted') end

    return self:Subscribe(onNext, onError, onCompleted)
end

----------1--------2--------3----4-------5-----6----7------|------      a
--->--S------------{1,2}---------{3,4}---------{5,6}-------{7}|-----    a:Buffer(2)
--->----------S-------------{2,3}--------{4,5}------{6,7}--|-----    a:Buffer(2)
---@return Observable
---@param size number
function Observable:Buffer(size)
    if not size or type(size) ~= 'number' then
        error('Expected a number')
    end

    ---@param observer Observer
    return Observable.Create(function(observer)
        local buffer = {}

        local function emit()
            if #buffer > 0 then
                observer:Next(util.unpack(buffer))
                buffer = {}
            end
        end

        local function onNext(...)
            local values = {...}
            for i = 1, #values do
                table.insert(buffer, values[i])
                if #buffer >= size then
                    emit()
                end
            end
        end

        local function onError(message)
            emit()
            return observer:Error(message)
        end

        local function onCompleted()
            emit()
            return observer:Complete()
        end

        return self:Subscribe(onNext, onError, onCompleted)
    end)
end

----------1--------2--------3----4-----|------   a
--->--S------------2-------------4-----|-----    a:Filter((x) => x%2 == 0)
---@return Observable
---@param predicate function
function Observable:Filter(predicate)
    predicate = predicate or util.identity

    ---@param observer Observer
    return Observable.Create(function(observer)
        local function onNext(...)
            util.tryWithObserver(observer, function(...)
                if predicate(...) then
                    return observer:Next(...)
                end
            end, ...)
        end

        local function onError(e)
            return observer:Error(e)
        end

        local function onCompleted()
            return observer:Complete()
        end

        return self:Subscribe(onNext, onError, onCompleted)
    end)
end

----------1--------2--------3----4-----|------   a
--->------2--------4--------6----8-----|-----    a:Map((x) => x*2)
---@return Observable
---@param callback function
function Observable:Map(callback)
    ---@param observer Observer
    return Observable.Create(function(observer)
        callback = callback or util.identity

        local function onNext(...)
            return util.tryWithObserver(observer, function(...)
                return observer:Next(callback(...))
            end, ...)
        end

        local function onError(e)
            return observer:Error(e)
        end

        local function onCompleted()
            return observer:Complete()
        end

        return self:Subscribe(onNext, onError, onCompleted)
    end)
end

----------1--------2--------3----4-----|------
------------A-----------------C--------|-----
-----------------B---------------------|-----
--->--S---1-A----B-2--------3-C--4-----|-----
---@return Observable
function Observable:Merge(...)
    local sources = {...}
    table.insert(sources, 1, self)

    ---@param observer Observer
    return Observable.Create(function(observer)
        local completed = {}
        local subscriptions = {}

        local function onNext(...)
            return observer:Next(...)
        end

        local function onError(message)
            return observer:Error(message)
        end

        local function onCompleted(i)
            return function()
                table.insert(completed, i)

                if #completed == #sources then
                    observer:Complete()
                end
            end
        end

        for i = 1, #sources do
            ---@type Observable
            local source = sources[i]
            subscriptions[i] = source:Subscribe(onNext, onError, onCompleted(i))
        end

        return Subscription.Create(function ()
            ---@param subscription Subscription
            for _, subscription in ipairs(subscriptions) do
                if subscription then subscription:Unsubscribe() end
            end
        end)
    end)
end


----------1--------2--------3----4-----|------
------------A----B-------------C-------|-----
--->--S-----1----1-------------3-------4|-----
----@return Observable
---@param sampler Observable
function Observable:Sample(sampler)
    if not sampler then error('Expected an Observable') end

    ---@param observer Observer
    return Observable.Create(function(observer)
        local latest = {}

        local function setLatest(...)
            latest = util.pack(...)
        end

        local function onNext()
            if #latest > 0 then
                return observer:Next(util.unpack(latest))
            end
        end

        local function onError(message)
            return observer:Error(message)
        end

        local function onCompleted()
            return observer:Complete()
        end

        local sourceSubscription = self:Subscribe(setLatest, onError)
        local sampleSubscription = sampler:Subscribe(onNext, onError, onCompleted)

        return Subscription.Create(function()
            if sourceSubscription then sourceSubscription:Unsubscribe() end
            if sampleSubscription then sampleSubscription:Unsubscribe() end
        end)
    end)
end

----------1--------2----------3-----------|------
------------A------------B----------------|-----
--->--S-----1,A----2,A---2,B--3,B---------|-----
----@return Observable
function Observable:CombineLatest(...)
    local sources = {...}
    local combinator = table.remove(sources)
    if type(combinator) ~= 'function' then
        table.insert(sources, combinator)
        combinator = function(...) return ... end
    end
    table.insert(sources, 1, self)

    ---@param observer Observer
    return Observable.Create(function(observer)
        local latest = {}
        local pending = {util.unpack(sources)}
        local completed = {}
        local subscriptions = {}

        local function onNext(i)
            return function(value)
                latest[i] = value
                pending[i] = nil

                if not next(pending) then
                    util.tryWithObserver(observer, function()
                        observer:Next(combinator(util.unpack(latest)))
                    end)
                end
            end
        end

        local function onError(e)
            return observer:Error(e)
        end

        local function onCompleted(i)
            return function()
                table.insert(completed, i)

                if #completed == #sources then
                    observer:Complete()
                end
            end
        end

        for i = 1, #sources do
            ----@type Observable
            local source = sources[i]
            subscriptions[i] = source:Subscribe(onNext(i), onError, onCompleted(i))
        end

        return Subscription.Create(function ()
            ---@param subscription Subscription
            for _, subscription in ipairs(subscriptions) do
                subscription:Unsubscribe()
            end
        end)
    end)
end

----------1--------2--------3-----|------
--->-S----1--------2--------3-----|-----
--->------------------S-----3-----|-----
--->--------------------------S---|-----

----------1--------2--------3-----X------
--->-S----1--------2--------3-----X------
--->------------------S-----3-----X------
--->-------------------------S----X------
--- @class Subject : Observable
local Subject = setmetatable({}, Observable)
Subject.__index = Subject
Subject.__tostring = util.constant('Subject')

--- @return Subject
function Subject.Create()
    --- @type Subject
    local self = {}
    self.observers = {}
    self.stopped = false
    return setmetatable(self, Subject)
end

---@return Subscription
function Subject:Subscribe(onNext, onError, onCompleted)
    local observer
    if util.isa(onNext, Observer) then
        observer = onNext
    else
        observer = Observer.Create(onNext, onError, onCompleted)
    end
    table.insert(self.observers,1, observer)
    return Subscription.Create(function()
        for i = 1, #self.observers do
            if self.observers[i] == observer then
                table.remove(self.observers, i)
                return
            end
        end
    end)
end

function Subject:Next(...)
    if not self.stopped then
        for i = #self.observers, 1, -1 do
            ---@type Observer
            local observer = self.observers[i]
            if observer ~= nil then
                observer:Next(...)
            end
        end
    end
end

function Subject:Error(message)
    if not self.stopped then
        for i = #self.observers, 1, -1 do
            ---@type Observer
            local observer = self.observers[i]
            observer:Error(message)
        end
        self.stopped = true
    end
end

function Subject:Complete()
    if not self.stopped then
        for i = #self.observers, 1, -1 do
            ---@type Observer
            local observer = self.observers[i]
            observer:Complete()
        end
        self.stopped = true
    end
end


----------1--------2--------3-----|------
--->-------------S----------------3|----
--->--------------------------S---3|----

----------1--------2--------3-----X------
--->-------------S----------------X------
--->--------------------------S---X------
---@class AsyncSubject : Observable
local AsyncSubject = setmetatable({}, Observer)
AsyncSubject.__index = AsyncSubject
AsyncSubject.__tostring = util.constant('AsyncSubject')

---@return AsyncSubject
function AsyncSubject.Create()
    ---@type AsyncSubject
    local self = {}
    self.observers = {}
    self.stopped = false
    self.value = nil
    self.errorMessage = nil
    return setmetatable(self, AsyncSubject)
end

function AsyncSubject:Subscribe(onNext, onError, onCompleted)
    ---@type Observer
    local observer

    if util.isa(onNext, Observer) then
        observer = onNext
    else
        observer = Observer.Create(onNext, onError, onCompleted)
    end

    if self.value then
        observer:Next(util.unpack(self.value))
        observer:Complete()
        return
    elseif self.errorMessage then
        observer:Error(self.errorMessage)
        return
    end

    table.insert(self.observers,1, observer)

    return Subscription.Create(function()
        for i = 1, #self.observers do
            if self.observers[i] == observer then
                table.remove(self.observers, i)
                return
            end
        end
    end)
end

function AsyncSubject:Next(...)
    if not self.stopped then
        self.value = util.pack(...)
    end
end

function AsyncSubject:Error(message)
    if not self.stopped then
        self.errorMessage = message
        ---@param v Observer
        for _, v in ipairs(self.observers) do
            v:Error(message)
        end
        self.stopped = true
    end
end

function AsyncSubject:Complete()
    if not self.stopped then
        ---@param v Observer
        for _, v in ipairs(self.observers) do
            v:Next(util.unpack(self.value))
            v:Complete()
        end
        self.stopped = true
    end
end

----------1--------2--------3-----|------
--->-S-0--1--------2--------3-----|-----
--->------------------S-2---3-----|-----

----------1--------2--------3-----X------
--->-S-0--1--------2--------3-----X------
--->------------------S-2---3-----X------
--->--------------------------------S-X--
--- @class BehaviorSubject : Observable
local BehaviorSubject = setmetatable({}, Observable)
BehaviorSubject.__index = BehaviorSubject
BehaviorSubject.__tostring = util.constant('BehaviorSubject')

---@return BehaviorSubject
function BehaviorSubject.Create(...)
    ---@type BehaviorSubject
    local self = {}
    self.observers = {}
    self.stopped = false
    if select('#', ...) > 0 then
        self.value = util.pack(...)
    end
    return setmetatable(self, BehaviorSubject)
end

function BehaviorSubject:Subscribe(onNext, onError, onCompleted)
    ---@type Observable
    local observer

    if util.isa(onNext, Observer) then
        observer = onNext
    else
        observer = Observer.Create(onNext, onError, onCompleted)
    end

    local subscription = Subject.Subscribe(self, observer)

    if self.value then
        observer:Next(util.unpack(self.value))
    end

    return subscription
end

function BehaviorSubject:Next(...)
    self.value = util.pack(...)
    return Subject.Next(self, ...)
end

function BehaviorSubject:GetValue()
    if self.value ~= nil then
        return util.unpack(self.value)
    end
end

--- @class ReplaySubject
local ReplaySubject = setmetatable({}, Subject)
ReplaySubject.__index = ReplaySubject
ReplaySubject.__tostring = util.constant('ReplaySubject')

--- @return ReplaySubject
function ReplaySubject.Create(n)
    ---@type ReplaySubject
    local self = {}
    self.observers = {}
    self.stopped = false
    self.buffer = {}
    self.bufferSize = n

    return setmetatable(self, ReplaySubject)
end

function ReplaySubject:Subscribe(onNext, onError, onCompleted)
    ---@type Observable
    local observer

    if util.isa(onNext, Observer) then
        observer = onNext
    else
        observer = Observer.Create(onNext, onError, onCompleted)
    end

    local subscription = Subject.Subscribe(self, observer)

    for i = 1, #self.buffer do
        observer:Next(util.unpack(self.buffer[i]))
    end

    return subscription
end

function ReplaySubject:Next(...)
    table.insert(self.buffer, util.pack(...))
    if self.bufferSize and #self.buffer > self.bufferSize then
        table.remove(self.buffer, 1)
    end

    return Subject.Next(self, ...)
end

return {
    util = util,
    Subscription = Subscription,
    Observer = Observer,
    Observable = Observable,
    Subject = Subject,
    AsyncSubject = AsyncSubject,
    BehaviorSubject = BehaviorSubject,
    ReplaySubject = ReplaySubject,
}