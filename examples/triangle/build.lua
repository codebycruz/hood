local dirName = debug.getinfo(1, "S").source:sub(2):match("(.*/)")

---@param stage "vert" | "frag"
---@param glslPath string
---@param outputPath string
local function glslToSpirv(stage, glslPath, outputPath)
	local command = string.format("glslc -fshader-stage=%s %s -o %s", stage, glslPath, outputPath)

	local result = os.execute(command)
	if result ~= 0 then
		error("Failed to compile GLSL shader: " .. glslPath)
	end
end

if os.getenv("VULKAN") then
	glslToSpirv("vert", dirName .. "shaders/triangle.vert.glsl", dirName .. "shaders/triangle.vert.spv")
	glslToSpirv("frag", dirName .. "shaders/triangle.frag.glsl", dirName .. "shaders/triangle.frag.spv")
end
