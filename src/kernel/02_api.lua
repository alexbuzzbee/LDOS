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
  writeTerm = { -- Write to the terminal.
    called = print
  },
  openFile = { -- Open a file.
    called = function(path) return fopen(path) end
  },
  closeFile = { -- Close an opened file.
    called = function(handle) return fclose(handle) end
  },
  readFile = { -- Reads from a file.
    called = function(handle, size) return fread(handle, size) end
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
    called = function(drive) return drvSpace(string.lower(drive)) end
  },
  chDirForDrive = { -- Change directory on a given drive.
    called = function(new, drive)
      if checkDir(new, drive) then
        currentDirs[drive] = new
      end
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
  execute = { -- Executes a program.
    called = shell.run
  }
}
