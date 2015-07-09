-- Variables --

local version = {major = 0, minor = 1, fix = 0}

--[[
  There are two types of drive: dir (simply a physical directory) and funcs (a group of functions provides the drive's functionality).
]]
local drives = { -- Drives; defaults to A (/disk), B (/disk2), and C (/).
  A = {
    type = "dir",
    dir = "/disk"
  },
  B = {
    type = "dir",
    dir = "/disk2"
  },
  C = {
    type = "dir",
    dir = "/"
  },
}

local devices = { -- Device virtual files.
  NUL = {
    write = function() end,
    read = function() return "" end
  },
  CON = {
    write = function(value) print(value) end,
    read = function() return read() end
  },
}

local configDirectives = { -- CONFIG.SYS directives.
  DEVICE = { -- Loads a device driver.
    invoke = function(restOfLine)
      local args = {}
      for arg in string.gmatch(restOfLine) do
        table.insert(args, arg)
      end
      loadDriver(table.unpack(args))
    end
  },
}

local events = { -- Association of string names to function handlers.
  terminate = nil, -- When the running program terminates.
}

local currentDrive = "C" -- The current drive.

local currentDirs = {
  A = "\\",
  B = "\\",
  C = "\\",
}

local environment = { -- Environment variables. Shared between all programs.
  SHELL = "\\COMMAND.COM", -- The set shell. Started when no other programs are running.
}
