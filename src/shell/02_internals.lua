-- Internal commands --

local internalCommands = {
  DIR = { -- Displays a directory listing.
    exec = function(params)
      local files, totalSize, dirs = 0, 0, 0
      for i, entry in ipairs(dos("getDirContents", params[1])) do
        dos("writeTerm", entry.name .. "\t")
        if entry.type == "file" then
          dos("writeTerm", entry.ext .. "\t\t" .. entry.size .. "\n")
          files = files + 1
          totalSize = totalSize + entry.size
        elseif entry.type == "dir" then
          dos("writeTerm", "\t" .. "<DIR>" .. "\n")
        end
      end
      dos("writeTerm", "\t" .. files .. "File(s)" .. "\t" .. totalSize .. " Bytes.\n")
      dos("writeTerm", "\t" .. dirs .. "Dir(s)" .. "\t" .. dos("getSpaceForDrive", dos("parsePath", params[1])) --[[Gets free space for the drive containing the dir we're listing]] .. " Bytes free.\n")
    end
  },
}
