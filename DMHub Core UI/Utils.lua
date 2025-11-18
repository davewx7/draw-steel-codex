local mod = dmhub.GetModLoading()

CoroutineUtils = {
    Wait = function(t)
        if t <= 0 then
            return
        end

        local endTime = dmhub.Time() + t
        while dmhub.Time() < endTime do
            coroutine.yield()
        end
    end,
}

local g_globalEventHandlers = {}

EventUtils = {
    FireGlobalEvent = function(eventName, ...)
        local eventList = g_globalEventHandlers[eventName]
        if eventList ~= nil then
            for _,entry in ipairs(eventList) do
                entry.handlerfn(...)
            end
        end
    end,

    RegisterGlobalEventHandler = function(mod, eventName, handlerfn)
        local guid = dmhub.GenerateGuid()
        g_globalEventHandlers[eventName] = g_globalEventHandlers[eventName] or {}
        local eventList = g_globalEventHandlers[eventName]
        local entry = {
            guid = guid,
            handlerfn = handlerfn,
        }
        
        eventList[#eventList+1] = entry

        local unloadfn = function()
            local eventList = g_globalEventHandlers[eventName]
            if eventList == nil then
                return
            end
            local newEventList = {}
            for _,entry in ipairs(eventList) do
                if entry.guid ~= guid then
                    newEventList[#newEventList+1] = entry
                end
            end

            g_globalEventHandlers[eventName] = newEventList
        end

        mod.unloadHandlers[#mod.unloadHandlers+1] = unloadfn
        entry.Deregister = unloadfn
        return entry
    end,
}