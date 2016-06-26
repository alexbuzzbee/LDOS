-- Command processing --

local function getCommand()
  displayPrompt()
  return dos("readTerm")
end

local function processCommand(line)
  local words = {}
  local i = 1
  for word in string.gmatch(line, "([^ ]+)") do -- Break the line up into words.
    words[i] = word
    i = i + 1
  end
  local command = table.remove(words, 1) -- Get the command itself.
  if string.match(command, "^[a-zA-Z]:$") then -- Change drive commands.
    dos("chDrive", string.match(command, "^([a-zA-Z]):$"))
    return true
  end
  for internal, table in pairs(internalCommands) do -- Try internal commands.
    if internal == command then
      table.exec(words) -- Run the internal command.
      return true -- Succede.
    end
  end
  if not dos("execute", command, table.unpack(words)) then -- Try running the command as given...
    if not dos("execute", command .. ".COM", table.unpack(words)) then -- ...as a .COM...
      if not dos("execute", command .. ".EXE", table.unpack(words)) then -- ...and as a .EXE...
        return false -- ...and fail if none of those work.
      end
    end
  end
  return true -- Succede.
end
