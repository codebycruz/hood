local separator = string.sub(package.config, 1, 1)
local outDir = os.getenv("LPM_OUTPUT_DIR")

local function read(p)
	local handle = io.open(p, "r")
	local content = handle:read("*a")
	handle:close()
	return content
end

local init = read(outDir .. separator .. "init.lua")

local preprocessed = string.gsub(init, "%[%[#embed \"([^\"]+)\"%]%]", function(filename)
	return string.format("%q", read(outDir .. separator .. filename))
end)

local outFile = io.open(outDir .. separator .. "init.lua", "w")
outFile:write(preprocessed)
outFile:close()
