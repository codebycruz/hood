local VKSwapchain = require("hood.swapchain.vk")

---@class hood.vk.Surface
---@field window winit.Window
local VKSurface = {}
VKSurface.__index = VKSurface

---@param window winit.Window
function VKSurface.new(window)
	return setmetatable({ window = window }, VKSurface)
end

---@param device hood.vk.Device
---@param config hood.SurfaceConfig
function VKSurface:configure(device, config)
end

return VKSurface
