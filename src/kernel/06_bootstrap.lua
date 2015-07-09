-- Bootstrap --

local function boot() -- Boots LDOS.
  local bootDir = fs.getDir(shell.getRunningProgram()) -- Get the BIOS path to the directory
  for letter, table in pairs(drives) do
    if table.type == "dir" and table.dir == bootDir then
      currentDrive = letter
      environment.BOOTDRIVE = letter
    end
  end
  if currentDrive == "" then
    error("Can't determine boot drive")
  end
  local configLoc = convertPath(parsePath("\\CONFIG.SYS"))
  parseConfig(configLoc)
  executeProgram(environment.SHELL)
end

local result, reason = pcall(boot())
if result == nil then
  print("Fatal error: " .. reason .. ".")
end
