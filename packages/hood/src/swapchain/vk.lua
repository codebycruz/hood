local vk = require("hood-vulkan")
local ffi = require("ffi")

local VKTexture = require("hood.texture.vk")

---@class hood.vk.Swapchain
---@field handle vk.ffi.SwapchainKHR
---@field device hood.vk.Device
---@field images vk.ffi.Image[] # 1 indexed array of VkImage handles
---@field currentVkImageIdx integer
---@field imageAvailable vk.ffi.Semaphore
local VKSwapchain = {}
VKSwapchain.__index = VKSwapchain

---@param device hood.vk.Device
---@param info vk.ffi.SwapchainCreateInfoKHR
function VKSwapchain.new(device, info)
	local handle = device.handle:createSwapchainKHR(info)
	local images = device.handle:getSwapchainImagesKHR(handle)
	local imageAvailable = device.handle:createSemaphore({})

	return setmetatable({ images = images, device = device, handle = handle, imageAvailable = imageAvailable },
		VKSwapchain)
end

function VKSwapchain:getCurrentTexture()
	local currentVkImageIdx = self.device.handle:acquireNextImageKHR(self.handle, math.huge, self.imageAvailable)
	local imageHandle = self.images[currentVkImageIdx + 1]

	self.currentVkImageIdx = currentVkImageIdx
	return VKTexture.fromRaw(self.device, imageHandle)
end

---@param queue hood.vk.Queue
function VKSwapchain:present(queue)
	self.device.handle:queuePresentKHR(queue.handle, self.handle, self.currentVkImageIdx)
end

return VKSwapchain
