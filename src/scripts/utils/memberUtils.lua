--// NAME: memberUtils.lua
--// DESC: a module that has helpful tools for Member related stuff
--// AUTHOR: AduriteFur

local memberUtils = {}

function memberUtils:ConvertPermission(permNumb)
    local result = {}

    for name, permission in pairs(tam.Permissions) do
        local permissionValue = tonumber(permission)

        if math.floor(permNumb / permissionValue) % 2 == 1 then
            result[name] = true
        end
    end

    return result
end

function memberUtils:compairTablesForPermission(permsTable, target)
    if target.ADMINISTRATOR then
        return true
    end

    for permission, enabled in pairs(permsTable) do
        if enabled and not target[permission] then
            return false
        end
    end

    return true
end

return memberUtils
