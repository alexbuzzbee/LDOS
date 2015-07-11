-- CONFIG.SYS parser --

local function executeConfigDirective(name, restOfLine) -- Executes a parsed configuration directive.
  if configDirectives[name] ~= nil then
    configDirectives[name].invoke(restOfLine)
    return true
  else
    return false, "Invalid configuration directive: '" .. name .. "'."
  end
end

local function parseConfigLine(line) -- Parses a configuration line.
  print(line)
  local name, restOfLine = string.match(line, "(.*?)=(.*?)")
  if name == nil then
    return false, "Invalid configuration line: '" .. line .. "'."
  end
  executeConfigDirective(name, restOfLine)
  return true
end

local function parseConfigContents(contents) -- Parses the contents of CONFIG.SYS.
  print("Contents are '" .. contents .. "'")
  for line in string.gmatch(contents, "(.*?)[\n$]") do
    local success, reason = parseConfigLine(line)
    if not success then
      print("Warning: " .. reason)
    end
  end
end

local function parseConfig(path) -- Parses the CONFIG.SYS at the specified BIOS path.
  print("Parsing CONFIG.SYS at " .. path)
  local f = fs.open(path, "r")
  parseConfigContents(f.readAll())
  f.close()
end
