-- Tencent is pleased to support the open source community by making xLua available.
-- Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
-- Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
-- http://opensource.org/licenses/MIT
-- Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

local util = require 'lua.client.utils.XluaUtil'

--- @param seconds number
local function waitforseconds(seconds)
    return coroutine.yield(U_WaitForSeconds(seconds))
end

--- @return yield
local function waitforendofframe()
    return coroutine.yield(U_WaitForEndOfFrame())
end

--- @return yield
local function null()
    return coroutine.yield(nil)
end

--- @return yield
local function waituntil(func)
    if func == nil then
        print("func can't be nil: " .. debug.traceback())
        return nil
    end
    return coroutine.yield(U_WaitUntil(function()
        return func()
    end))
end

local function waitwhile(func)
    if func == nil then
        print("func can't be nil: " .. debug.traceback())
        return nil
    end
    return coroutine.yield(U_WaitWhile(function()
        return func()
    end))
end

coroutine.waitforseconds = waitforseconds
coroutine.waitforendofframe = waitforendofframe
coroutine.waituntil = waituntil
coroutine.waitwhile = waitwhile
coroutine.null = null

--- @class Coroutine
Coroutine = {}

Coroutine.DebugStart = function(...)
    return Coroutine.start(...)
end

Coroutine.start = function(...)
    return zgUnity:StartCoroutine(util.cs_generator(...))
end

Coroutine.stop = function(holder)
    if holder ~= nil then
        zgUnity:StopCoroutine(holder)
        holder = nil
    else
        XDebug.Error("coroutine is nil")
    end
end