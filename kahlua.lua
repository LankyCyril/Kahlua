kahlua = {
    global = function (module, elements)
        if (elements == nil) then
            elements = {}
            for element, _ in pairs(module) do
                table.insert(elements, element)
            end
        elseif (type(elements) == "string") then
            elements = {elements}
        end
        for _, element in pairs(elements) do
            if module[element] ~= nil then
                _G[element] = module[element]
            else
                error(tostring(element) .. " not found in module")
            end
        end
    end;
    prototype = function (parent_prototype)
        if parent_prototype == nil then
            return function (implementation)
                final_prototype = {
                    new = function (self, parent_implementation)
                        self.__index = self
                        return setmetatable(parent_implementation or {}, self)
                    end;
                }
                for field, value in pairs(implementation) do
                    final_prototype[field] = value
                end
                return final_prototype
            end
        elseif (parent_prototype.new == nil) or (type(parent_prototype.new) ~= "function") then
            error("Parent doesn't have a constructor.")
        else
            return function (implementation)
                return parent_prototype:new(implementation)
            end
        end
    end;
    lambda = function (expression)
        arg_mask, arg_unmask = "#(%d+)", "arg"
        arg_count, args = {}, {}
        for i in expression:gfind(arg_mask) do
            table.insert(arg_count, i)
        end
        table.sort(arg_count)
        for i = 1, arg_count[table.maxn(arg_count)] do
            table.insert(args, arg_unmask .. tostring(i))
        end
        parsed_expression = expression:gsub(arg_mask, arg_unmask .. "%1")
        return loadstring(
            "return function (" .. table.concat(args, ", ") .. ") " ..
                "return " .. parsed_expression ..
            " end"
        )()
    end;
}

kahlua.io = {
    lines = function (filename)
        return coroutine.wrap(function ()
            for line in io.lines(filename) do
                coroutine.yield(line)
            end
            coroutine.yield(false)
        end)
    end;
}

kahlua.la = kahlua.lambda

return kahlua
