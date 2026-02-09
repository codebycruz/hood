local vk = require("hood-vulkan")
local ffi = require("ffi")

local VKTexture = require("hood.texture.vk")

---@class hood.vk.Swapchain
---@field handle vk.ffi.SwapchainKHR
---@field device hood.vk.Device
---@field images vk.ffi.Image[] # 1 indexed array of VkImage handles
---@field currentVkImageIdx integer
local VKSwapchain = {}
VKSwapchain.__index = VKSwapchain

---@param device hood.vk.Device
---@param info vk.ffi.SwapchainCreateInfoKHR
function VKSwapchain.new(device, info)
	local handle = device.handle:createSwapchainKHR(info)
	local images = device.handle:getSwapchainImagesKHR(handle)

	return setmetatable({ images = images, device = device, handle = handle }, VKSwapchain)
end

function VKSwapchain:getCurrentTexture()
	local currentVkImageIdx = self.device.handle:acquireNextImageKHR(self.handle, math.huge)
	local imageHandle = self.images[currentVkImageIdx + 1]

	self.currentVkImageIdx = currentVkImageIdx
	error("return vktexture here")
	-- return VKTexture.new(self.device.handle, cImageIndex)
end

---@param queue hood.vk.Queue
function VKSwapchain:present(queue)
	self.device.handle:queuePresentKHR(queue.handle, self.handle, self.vkImageIdx)
end

return VKSwapchain
