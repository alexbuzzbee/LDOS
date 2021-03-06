-- Variables --

local version = {major = 0, minor = 4, fix = 1}

--[[
  There is one LDOS-defined drive type: dir, which is simply a physical directory.
]]
local drives = { -- Drives; defaults to A (/disk), B (/disk2), and C (/).
  A = {
    type = "dir",
    dir = "/disk/"
  },
  B = {
    type = "dir",
    dir = "/disk2/"
  },
  C = {
    type = "dir",
    dir = "/"
  },
  Z = {
    type = "dir",
    dir = "/rom/"
  },
}

local devices = { -- Device virtual files.
  NUL = {
    write = function() end,
    read = function() return "" end,
    close = function() end
  },
  CON = {
    write = function(value) term.write(value) end,
    readLine = function() return read() end,
    close = function() end
  },
  AUX = {
    write = function() end,
    read = function() return "" end,
    close = function() end
  },
}

local environment = { -- Environment variables. Shared between all programs.
  SHELL = "\\COMMAND.COM", -- The set shell. Started when no other programs are running.
  BOOTDRIVE = "", -- The boot drive.
}

local configDirectives = { -- CONFIG.SYS directives.
  DEVICE = { -- Loads a device driver.
    invoke = function(restOfLine)
      local args = {}
      for arg in string.gmatch(restOfLine, "\\s(.*?)|(.*?)\\s") do
        table.insert(args, arg)
      end
      loadDriver(table.unpack(args))
    end
  },
  SHELL = { -- Sets the shell.
    invoke = function(restOfLine)
      environment.SHELL = restOfLine
    end
  },
  INSTALL = { -- Executes a program from within CONFIG.SYS
    invoke = function(restOfLine)
      executeProgram(restOfLine)
    end
  },
  SET = { -- Sets an environment variable.
    invoke = function(restOfLine)
      local args = {}
      for arg in string.gmatch(restOfLine, "\\s(.*?)|(.*?)\\s") do
        table.insert(args, arg)
      end
      environment[args[1]] = table.concat(args, " ", 2) -- Concatinates the arguments together with spaces, then puts it in the specified environment variable.
    end
  },
  AUX = { -- Sets the AUX device.
    invoke = function(restOfLine)
      if devices[restOfLine] ~= nil then
        devices.AUX = devices[restOfLine]
      end
    end
  },
  REM = { -- Allows comments.
    invoke = function() end
  },
}

local events = { -- Association of string names to function handlers.
  terminate = nil, -- When the running program terminates.
  idle = nil, -- Idle callout.
  error = nil, -- When an error occurs inside LDOS.
}

local currentDrive = "" -- The current drive.

local currentDirs = {
  A = "\\",
  B = "\\",
  C = "\\",
}
