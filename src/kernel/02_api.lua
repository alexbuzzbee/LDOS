-- LDOS API interface (and small parts of the implementation) --

local apiCalls = {
  terminate = { -- Terminate the running program.
    called = function()
      if type(events.terminate) == "function" then
        events.terminate()
      end
      os.exit()
    end
  },
  readTerm = { -- Read from the terminal.
    called = function() return read() end
  },
  readTermNoEcho = { -- Read from the terminal without echoing.
    called = function() return read("") end
  },
  writeTerm = { -- Write to the terminal. Does not add a newline to the end.
    called = term.write
  },
  openFile = { -- Open a file.
    called = function(path, mode) return fopen(path, mode) end
  },
  closeFile = { -- Close an opened file.
    called = function(handle) return fclose(handle) end
  },
  readFile = { -- Reads from a file.
    called = function(handle, byte, all) return fread(handle, byte, all) end
  },
  writeFile = { -- Writes to a file.
    called = function(handle, data) return fwrite(handle, data) end
  },
  deleteFile = { -- Delete a file or directory.
    called = function(path) return fdelete(path) end
  },
  moveFile = { -- Move a file.
    called = function(path, newPath) return fmove(path, newPath) end
  },
  copyFile = {
    called = function(path, toPath) return fcopy(path, toPath) end
  },
  createDir = {
    called = function(path) return mkdir(path) end
  },
  getFileSize = { -- Returns the size of the specified file.
    called = function(path) return fsize(path) end
  },
  parseFilePath = { -- Parse a file path into drive and path components (using current drive/directory)
    called = function(path) return parsePath(path) end
  },
  chDrive = { -- Change the current drive.
    called = function(new)
      if string.length(new) == 1 then
        currentDrive = string.lower(new)
      end
    end
  },
  getDrive = { -- Returns the current drive.
    called = function() return currentDrive end
  },
  getSpaceForDrive = { -- Returns the amount of free space, in bytes, on the specified drive.
    called = function(drive) return drvSpace(string.upper(drive)) end
  },
  chDirForDrive = { -- Change directory on a given drive.
    called = function(new, drive)
      currentDirs[drive] = new
    end
  },
  chDir = { -- Change directory on the current drive.
    called = function(new) apiCalls.chDirForDrive(new, currentDrive) end
  },
  getDirForDrive = { -- Returns the current directory on a given drive.
    called = function(drive) return currentDirs[drive] end
  },
  getDir = { -- Returns the current directory on the current drive.
    called = function() return apiCalls.getDirForDrive(currentDrive) end
  },
  on = { -- Set the handler for an event.
    called = function(name, callback) events[name] = callback end
  },
  getHandler = { -- Returns the current handler for an event.
    called = function(name) return events[name] end
  },
  getDate = { -- Returns the current day.
    called = os.day
  },
  getTime = { -- Returns the current time of day.
    called = os.time
  },
  getVersion = { -- Returns the LDOS version.
    called = function() return version end
  },
  getEnv = { -- Returns the value of the specified environment variable.
    called = function(name) return environment[name] end
  },
  setEnv = { -- Sets an environment variable.
    called = function(name, value) environment[name] = value end
  },
  execute = { -- Executes a program.
    called = executeProgram
  },
}

local function executeProgram(path, ...) -- Executes the specified program.
  local pathObj = parsePath(path)
  local biosPath = convertPath(pathObj)
  if pathObj.ext == "EXE" or pathObj.ext == "COM" then
    os.run({}, biosPath, ...)
  end
end

function dos(callName, ...) -- Calls the LDOS API.
  if apiCalls[callName] ~= nil then
    return apiCalls[callName](...)
  else
    error("No such API call: '" .. callName .. "'.")
  end
end
