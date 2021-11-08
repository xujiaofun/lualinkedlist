---@class LinkedList
local LinkedList = {}
LinkedList.__index = LinkedList

local weekRef = { __mode = "k" }

local dummy = {}

function LinkedList:ctor()
    self._count = 0
    self._first = nil
    self._last = nil
    self._value = {}
    self._prev = {}
    self._next = {}
    self._iterators = {}
    setmetatable(self._iterators, weekRef)
end

function LinkedList:count()
    return self._count
end

function LinkedList:first()
    return self._first
end

function LinkedList:last()
    return self._last
end

function LinkedList:clear()
    self._count = 0
    self._first = nil
    self._last = nil
    for k, v in pairs(self._value) do
        self._value[k] = nil
    end
    for k, v in pairs(self._prev) do
        self._prev[k] = nil
    end
    for k, v in pairs(self._next) do
        self._next[k] = nil
    end
    for k, v in pairs(self._iterators) do
        self._iterators[k] = nil
    end
end

function LinkedList:contains(value)
    if value == nil then
        return false
    end
    return self._value[value] ~= nil
end

function LinkedList:addLast(value)
    if value == nil or self:contains(value) then return false end

    if self._last ~= nil then
        self._next[self._last] = value
    else
        self._first = value
    end
    self._prev[value] = self._last
    self._last = value
    self._value[value] = dummy
    self._count = self._count + 1
    return true
end

function LinkedList:addFirst(value)
    if value == nil or self:contains(value) then return false end

    if self._first ~= nil then
        self._prev[self._first] = value
    else
        self._last = value
    end
    self._next[value] = self._first
    self._first = value
    self._value[value] = dummy
    self._count = self._count + 1
    return true
end

function LinkedList:addAfter(value, newValue)
    if value == self._last then
        return self:addLast(newValue)
    end

    if value == nil or not self:contains(value) then return end
    if newValue == nil or self:contains(newValue) then return end

    local next = self._next[value]
    self._next[newValue] = next
    self._next[value] = newValue

    self._prev[next] = newValue
    self._prev[newValue] = value

    self._value[newValue] = dummy
    self._count = self._count + 1
    return true
end

function LinkedList:addBefore(value, newValue)
    if value == self._first then
        return self:addFirst(newValue)
    end

    if value == nil or not self:contains(value) then return end
    if newValue == nil or self:contains(newValue) then return end

    local prev = self._prev[value]
    self._prev[newValue] = prev
    self._prev[value] = newValue

    self._next[prev] = newValue
    self._next[newValue] = value

    self._value[newValue] = dummy
    self._count = self._count + 1
    return true
end

function LinkedList:remove(value)
    if value == nil or not self:contains(value) then return end

    for iterator, _ in pairs(self._iterators) do
        iterator(value)
    end

    local prev = self._prev[value]
    local next = self._next[value]

    if prev ~= nil then
        self._next[prev] = next
    end
    if next ~= nil then
        self._prev[next] = prev
    end
    self._next[value] = nil
    self._prev[value] = nil
    self._value[value] = nil
    if value == self._first then
        self._first = next
    end
    if value == self._last then
        self._last = prev
    end

    self._count = self._count - 1
    return value
end

function LinkedList:removeFirst()
    return self:remove(self._first)
end

function LinkedList:removeLast()
    return self:remove(self._last)
end

-- with element iterator
function LinkedList:walk(seq)
    if self._count <= 0 then
        return function()
            return nil
        end
    end
    if seq == nil then
        seq = true
    end
    local idx = seq and 1 or self._count
    local step = seq and 1 or -1
    local value = seq and self._first or self._last

    local supportRemove = function(rmValue)
        if rmValue == value then
            if seq then
                value = self._next[value]
            else
                value = self._prev[value]
            end
        end
    end
    self._iterators[supportRemove] = false

    local iterator = function()
        if value ~= nil then
            local i = idx
            local v = value
            idx = idx + step
            if seq then
                value = self._next[value]
            else
                value = self._prev[value]
            end
            return i, v
        else
            self._iterators[supportRemove] = nil
            return nil
        end
    end
    return iterator
end

-- create instance
local function _new()
    local ins = {}
    setmetatable(ins, LinkedList)
    ins:ctor()
    return ins
end

local mt = {}
mt.__call = _new
setmetatable(LinkedList, mt)

return LinkedList