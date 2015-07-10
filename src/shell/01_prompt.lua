-- Prompt --

local function displayPrompt()
  dos("writeTerm", dos("getDrive") .. ":" .. dos("getDir") .. "> ")
end
