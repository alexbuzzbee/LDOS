-- Variables --

local version = {major = 0, minor = 1, fix = 0}

--[[
  There are two types of drive: dir (simply a physical directory) and funcs (a group of functions provides the drive's functionality).
]]
local drives = { -- Drives; defaults to A (/disk), B (/disk2), and C (/).
  a = {
    type = "dir",
    dir = "/disk"
  },
  b = {
    type = "dir",
    dir = "/disk2"
  },
  c = {
    type = "dir",
    dir = "/"
  }
}

local devices = { -- Device virtual files.
  NUL = {
    write = function() end,
    read = function() return "" end
  },
  CON = {
    write = function(value) print(value) end,
    read = function() return read() end
  }
}

local configDirectives = { -- CONFIG.SYS directives.
  device = { -- Loads a device driver.
    invoke = function(restOfLine)
      local args = {}
      for i in string.gmatch(restOfLine) do
        table.insert(args, i)
      end
      loadDriver(table.unpack(args))
    end
  }
}

local events = { -- Association of string names to function handlers.
  terminate = nil, -- When the running program terminates.
}

local currentDrive = "c" -- The current drive.

local currentDirs = {
  a = "\\",
  b = "\\",
  c = "\\"
}
