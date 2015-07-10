-- Filesystem manager --

local openFiles = {}

local function parsePath(path) -- Parse a string path into its drive, directories, the basename, and the extension (using the current drive and path if applicable).
  local drive = string.match(path, "^([a-zA-Z]):") or currentDrive -- Match the drive.

  local dirs = {}
  for seperator, dir in string.gmatch(path, "(\\\\)?(\\w{1,8})\\\\") do -- Get the directories it's in.
    if seperator == "" then -- Add the current directory if there is no seperator at the beginning of the path.
      for currentDirElement in string.gmatch(currentDirs[currentDrive], "\\\\(\\w{1,8})\\\\") do
        table.insert(dirs, currentDirElement)
      end
    end
    table.insert(dirs, dir)
  end

  if #dirs == 0 then -- Add the current directory if path has no directories.
    for currentDirElement in string.gmatch(currentDirs[currentDrive], "\\\\(\\w{1,8})\\\\") do
      table.insert(dirs, currentDirElement)
    end
  end

  local name = string.match(path, "\\\\?(\\w{1,8)\\.")

  local ext = string.match(path, "\\.(\\w{1,3})$")

  return {
    drive = string.upper(drive),
    dirs = string.upper(dirs),
    basename = string.upper(name),
    extension = string.upper(ext)
  }
end

local function convertPath(pathObj) -- Converts a parsed LDOS path to a BIOS path, when appropriate.
  if drives[pathObj.drive].type ~= "dir" then
    error("Not a physical drive.")
  end
  local biosPath = drives[pathObj.drive].dir
  for index, dir in ipairs(pathObj.dirs) do
    biosPath = fs.concat(biosPath, dir)
  end
  if pathObj.basename ~= "" and pathObj.basename ~= nil then -- Don't go insane for directories.
    biosPath = fs.concat(biosPath, pathObj.basename)
    biosPath = biosPath .. ".L"
    biosPath = biosPath .. pathObj.extension
  end
  return biosPath
end

local function reverseConvertPath(path) -- Converts a BIOS path to an LDOS path string.
  local drive = ""
  local driveDir = ""
  for letter, tbl in pairs(drives) do
    if tbl.type == "dir" and string.length(tbl.dir) < string.length(driveDir) and string.match(path, tbl.dir .. ".*") ~= nil then -- Huge complex conditional to check if it's the right drive.
      drive = letter
      driveDir = tbl.dir
    end
  end
  local ldosPath = drive .. ":"
  local pathInDrive = string.match(path, driveDir .. "(.*)") -- Get the path inside the drive.
  local ldosDriveLocalPath = string.sub(pathInDrive, "/", "\\\\") -- Replace all forward slashes with backslashes.
  ldosPath = ldosPath .. string.sub(ldosDriveLocalPath, "\\.L", "\\.")
  return ldosPath
end

local function fopen(path, mode) -- Opens a file.
  for name, device in pairs(devices) do -- Handle device virtual files.
    if path == name then
      table.insert(openFiles, device)
      return table.maxn(openFiles)
    end
  end
  local pathObj = parsePath(path)
  if drives[pathObj.drive].type ~= "dir" then -- If the drive isn't directory-based...
    table.insert(openFiles, drives[pathObj.drive].open(pathObj)) -- Open the file using the function associated with the drive.
  else
    local biosPath = convertPath(pathObj) -- Convert the path to a BIOS path.
    table.insert(fs.open(biosPath), mode) -- Open it using fs.open().
  end
  return table.maxn(openFiles)
end

local function fclose(handle) -- Closes an open file. Returns true for success, false for failure.
  if openFiles[handle] ~= nil then
    openFiles[handle].close()
    return true
  else
    return false
  end
end

local function fread(handle, byte, all) -- Reads a byte from, line from, or all of an open file. Returns the read value, nil for failure.
  if openFiles[handle] ~= nil then
    if byte then
      return openFiles[handle].read()
    elseif all then
      return openFiles[handle].readAll()
    else
      return openFiles[handle].readLine()
    end
  else
    return nil
  end
end

local function fwrite(handle, data) -- Closes an open file. Returns true for success, false for failure.
  if openFiles[handle] ~= nil then
    openFiles[handle].write(data)
    return true
  else
    return false
  end
end

local function fdelete(path) -- Deletes the specified file or directory.
  local pathObj = parsePath(path)
  if drives[pathObj.drive].type ~= "dir" then
    drives[pathObj.drive].delete(pathObj)
  else
    fs.delete(convertPath(pathObj))
  end
end

local function fmove(path, newPath) -- Moves the specified file or directory to a new location.
  local pathObj = parsePath(path)
  local newPathObj = parsePath(newPath)
  if drives[pathObj.drive].type ~= "dir" then
    drives[pathObj.drive].move(pathObj, newPath)
  else
    fs.move(convertPath(pathObj), convertPath(newPathObj))
  end
end

local function fcopy(path, newPath) -- Copies the specified file or directory to a new location.
  local pathObj = parsePath(path)
  local newPathObj = parsePath(newPath)
  if drives[pathObj.drive].type ~= "dir" then
    drives[pathObj.drive].copy(pathObj, newPath)
  else
    fs.copy(convertPath(pathObj), convertPath(newPathObj))
  end
end

local function fsize(path) -- Returns the size of the specified file, in bytes.
  return fs.size(convertPath(parsePath(path)))
end

local function mkdir(path) -- Creates a directory.
  local biosPath = convertPath(parsePath(path))
  fs.makeDir(biosPath)
end

local function dirContents(path) -- Returns a list of files and directories in `path`.
  local contents = {}
  for i, item in ipairs(fs.list(convertPath(parsePath(path)))) do
    local itemBiosPath = fs.concat(path, item) -- Get the full BIOS path to the item.
    local itemLdosPath = reverseConvertPath(itemBiosPath) -- Get the full LDOS path to the item.
    local itemLdosPathObj = parsePath(itemLdosPath) -- Get the LDOS path object to the item.
    local itemType
    if fs.isDir(item) then -- Set the item's type.
      itemType = "dir"
    else
      itemType = "file"
    end
    contents[i] = { -- Create a table to represent the item.
      path = itemLdosPath,
      name = itemLdosPathObj.basename,
      type = itemType,
    }
    if itemType == "file" then -- Add extra info about files.
      contents[i].size = fs.size(itemBiosPath)
      contents[i].ext = itemLdosPathObj.ext
    end
  end
  return contents
end

local function drvSpace(drive)
  if drives[drive].type == "dir" then
    fs.getFreeSpace(drives[drive].dir)
  else
    drives[drive].space()
  end
end
