local ffi = require("ffi")
local vk = require("hood-vulkan")

local VKSwapchain = require("hood.swapchain.vk")

local isWindows = ffi.os == "Windows"

---@class hood.vk.Surface
---@field window winit.Window
---@field handle vk.ffi.SurfaceKHR
---@field instance hood.vk.Instance
local VKSurface = {}
VKSurface.__index = VKSurface

---@param instance hood.vk.Instance
---@param window winit.Window
function VKSurface.new(instance, window)
	local handle ---@type vk.ffi.SurfaceKHR
	if isWindows then ---@cast window winit.win32.Window
		local kernel32 = require("winapi.kernel32")

		handle = instance.handle:createWin32SurfaceKHR({
			hinstance = kernel32.getModuleHandle(nil),
			hwnd = window.hwnd,
		})
	else ---@cast window winit.x11.Window
		handle = instance.handle:createXlibSurfaceKHR({
			dpy = window.display,
			window = window.id,
		})
	end

	return setmetatable({ window = window, handle = handle, instance = instance }, VKSurface)
end

---@param device hood.vk.Device
---@param config hood.SurfaceConfig
---@return hood.vk.Swapchain
function VKSurface:configure(device, config)
	local caps = vk.getPhysicalDeviceSurfaceCapabilitiesKHR(device.pd, self.handle)
	local formats = vk.getPhysicalDeviceSurfaceFormatsKHR(device.pd, self.handle)

	local format = formats[1]

	local imageCount = caps.minImageCount + 1
	if caps.maxImageCount > 0 and imageCount > caps.maxImageCount then
		imageCount = caps.maxImageCount
	end

	local extent = caps.currentExtent
	if extent.width == 0xFFFFFFFF then
		extent.width = self.window.width
		extent.height = self.window.height
	end

	return VKSwapchain.new(device, {
		surface = self.handle,
		minImageCount = imageCount,
		imageFormat = format.format,
		imageColorSpace = format.colorSpace,
		imageExtent = extent,
		imageArrayLayers = 1,
		imageUsage = vk.ImageUsageFlagBits.COLOR_ATTACHMENT,
		imageSharingMode = vk.SharingMode.EXCLUSIVE,
		preTransform = caps.currentTransform,
		compositeAlpha = vk.CompositeAlphaFlagBitsKHR.OPAQUE,
		presentMode = vk.PresentModeKHR.IMMEDIATE,
		clipped = 1,
	})
end

return VKSurface
