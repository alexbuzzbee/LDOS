-- Program execution --

local function executeProgram(path, ...) -- Executes the specified program.
  local pathObj = parsePath(path)
  local biosPath = convertPath(pathObj)
  if pathObj.extension == "EXE" or pathObj.extension == "COM" then
    return os.run({}, biosPath, ...)
  end
  return false
end
