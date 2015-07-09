-- Bootstrap --

local function boot() -- Boots LDOS.
  local configLoc = fs.concat(fs.getDir(shell.getRunningProgram()), "CONFIG.LSYS")
  parseConfig(configLoc)
  executeProgram(environment.SHELL)
end

local result, reason = pcall(boot())
if result == nil then
  print("Fatal error: " .. reason .. ".")
end
