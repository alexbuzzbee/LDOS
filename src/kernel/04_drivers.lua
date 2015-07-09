-- Driver manager --

local driverApiCalls = {
  getDrives = { -- Gets all drives.
    called = function() return drives end
  },
  addDrive = { -- Adds a drive.
    called = function(letter, table, overwrite)
      if overwrite or drives[string.upper(letter)] == nil then
        drives[string.upper(letter)] = table
      else
        error("Drive already exists.")
      end
    end
  },
  removeDrive = { -- Removes a drive.
    called = function(letter) drives[string.upper(letter)] = nil end
  },
  getDevices = { -- Gets all device files.
    called = function() return devices end
  },
  addDevice = { -- Adds a device file.
    called = function(name, table, overwrite)
      if overwrite or devices[string.upper(name)] == nil then
        devices[string.upper(name)] = table
      else
        error("Device already exists.")
      end
    end
  },
  removeDevice = { -- Removes a device file.
    called = function(letter) devices[string.upper(letter)] = nil end
  },
  getApi = { -- Gets all API calls.
    called = function() return apiCalls end
  },
  addApiCall = { -- Adds an API call.
    called = function(name, table, overwrite)
      if overwrite or apiCalls[string.upper(name)] == nil then
        apiCalls[string.upper(name)] = table
      else
        error("API call already exists.")
      end
    end
  },
  removeApiCall = { -- Removes an API call.
    called = function(name) apiCalls[string.upper(name)] = nil end
  },
  getDriverApi = { -- Gets all driver API calls.
    called = function() return driverApiCalls end
  },
  addDriverApiCall = { -- Adds a driver API call.
    called = function(name, table, overwrite)
      if overwrite or driverApiCalls[string.upper(name)] == nil then
        driverApiCalls[string.upper(name)] = table
      else
        error("Driver API call already exists.")
      end
    end
  },
  removeApiCall = { -- Removes a driver API call.
    called = function(name) driverApiCalls[string.upper(name)] = nil end
  },
  getConfigs = { -- Gets all config directives.
    called = function() return configDirectives end
  },
  addConfig = { -- Adds a config directive.
    called = function(name, table, overwrite)
      if overwrite or configDirectives[string.upper(name)] == nil then
        configDirectives[string.upper(name)] = table
      else
        error("API call already exists.")
      end
    end
  },
  removeConfig = { -- Removes a config directive.
    called = function(name) configDirectives[string.upper(name)] = nil end
  },
}

local function driverCall(callName, ...)
  if driverApiCalls[callName] ~= nil then
    return driverApiCalls[callName](...)
  else
    error("No such driver API call: '" .. callName .. "'.")
  end
end

local function loadDriver(path, ...)
  local pathObj = parsePath(path)
  local biosPath = convertPath(pathObj)
  if pathObj.ext == "SYS" then
    os.run({driverCall = driverCall}, biosPath, ...)
  end
end
