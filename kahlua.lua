kahlua = {
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
