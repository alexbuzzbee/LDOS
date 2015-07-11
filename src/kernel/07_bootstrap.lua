-- Bootstrap --

local function boot() -- Boots LDOS.
  print("Starting LDOS...")
  local bootDir = "/" .. fs.getDir("/" .. shell.getRunningProgram()) -- Get the BIOS path to the directory (the '"/" .. 's are because shell.getRunningProgram() returns a path without a /).
  for letter, table in pairs(drives) do
    if table.type == "dir" and table.dir == bootDir then
      currentDrive = letter
      environment.BOOTDRIVE = letter
    end
  end
  print("Booting from " .. currentDrive .. ":")
  if currentDrive == "" then
    error("Can't determine boot drive")
  end
  print("Parsing CONFIG.SYS...")
  local configLoc = convertPath(parsePath("\\CONFIG.SYS"))
  parseConfig(configLoc)
  print("Starting shell (" .. environment.SHELL .. ")...")
  executeProgram(environment.SHELL)
end

local result, reason = pcall(boot)
if result == nil then
  print("Fatal error: " .. reason .. ".")
end
