local separator = string.sub(package.config, 1, 1)
local outDir = os.getenv("LPM_OUTPUT_DIR")

local function read(p)
	local handle = io.open(p, "r")
	local content = handle:read("*a")
	handle:close()
	return content
end

local init = read(outDir .. separator .. "init.lua")

local escapes = {
	["\\"] = "\\\\",
	["\""] = "\\\"",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\t"] = "\\t"
}

local preprocessed = string.gsub(init, "%[%[#embed \"([^\"]+)\"%]%]", function(filename)
	local content = read(outDir .. separator .. filename)
	return '"' .. (content:gsub("[\\\"\n\r\t]", escapes)) .. '"'
end)

local outFile = io.open(outDir .. separator .. "init.lua", "w")
outFile:write(preprocessed)
outFile:close()
