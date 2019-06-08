return {

global = function (module, elements)
    if (elements == nil) then
        elements = {}
        for element, _ in pairs(module) do
            elements[#elements + 1] = element
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

prototype = function (parent)
    if parent == nil then
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
    elseif (parent.new == nil) or (type(parent.new) ~= "function") then
        error("Parent doesn't have a constructor.")
    else
        return function (implementation)
            return parent:new(implementation)
        end
    end
end;

lambda = function (expression)
    local arg_mask = "#(%d+)"
    local arg_unmask = "arg"
    local max_arg_number = 0
    for arg_number in expression:gfind(arg_mask) do
        local arg_number_as_int = tonumber(arg_number)
        if arg_number_as_int > max_arg_number then
            max_arg_number = arg_number_as_int
        end
    end
    local args = arg_unmask .. "1"
    if max_arg_number > 1 then
        for i = 2, max_arg_number do
            args = args .. ", " .. arg_unmask .. i
        end
    end
    local parsed_expression = expression:gsub(arg_mask, arg_unmask .. "%1")
    return loadstring(
        "return function (" .. args .. ") " ..
            "return " .. parsed_expression ..
        " end"
    )()
end;

io = {
    lines = function (filename)
        return coroutine.wrap(function ()
            for line in io.lines(filename) do
                coroutine.yield(line)
            end
            coroutine.yield(false)
        end)
    end;
}

}
