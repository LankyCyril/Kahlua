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
        elseif parent_prototype.new == nil then
            error("Parent doesn't have a constructor.")
        else
            return function (implementation)
                return parent_prototype:new(implementation)
            end
        end
    end;
}

return kahlua
