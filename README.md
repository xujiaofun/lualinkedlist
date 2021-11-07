# lualinkedlist
lua的链表实现

可以在循环中删除的数据结构

```lua
---@type LinkedList
local lst = require("LinkedList")()
lst:addLast(7)
lst:addLast(8)
lst:addBefore(7, 6)
lst:addBefore(6, 5)
lst:addAfter(8, 9)
print("count = ",lst:count())

print("-- walk: { 5, 6, 7, 8, 9 }")
for i, v in lst:walk() do
    print(i, v)
end

print("-- walk: { 5, 6, 8, 9 }")
for i, v in lst:walk() do
   if v == 6 then
       lst:remove(6)
       lst:remove(7)
   end
   print(i, v)
end

print("-- walk: { 5, 8, 9 }")
for i, v in lst:walk() do
    print(i, v)
end

print("-- walk: { 9, 8 }")
for i, v in lst:walk(false) do
    if v == 8 then
        lst:remove(5)
    end
    print(i, v)
end

print("-- walk: { 8, 9 }")
for i, v in lst:walk() do
    print(i, v)
end

lst:clear()
print("-- walk: { }")
for i, v in lst:walk() do
    print(i, v)
end


```