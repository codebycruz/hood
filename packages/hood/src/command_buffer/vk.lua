local vk = require("hood-vulkan")

---@class hood.vk.CommandBuffer
---@field device hood.vk.Device
---@field pool vk.CommandPool
---@field buffer vk.CommandBuffer
local VKCommandBuffer = {}
VKCommandBuffer.__index = VKCommandBuffer

---@param device hood.vk.Device
function VKCommandBuffer.new(device)
	local pool = vk.createCommandPool(device.device, {
		flags = vk.CommandPoolCreateFlagBits.RESET_COMMAND_BUFFER,
		queueFamilyIndex = device.queue.familyIdx,
	})

	local buffer = vk.allocateCommandBuffers(device.device, {
		commandPool = pool,
		level = vk.CommandBufferLevel.PRIMARY,
		commandBufferCount = 1,
	})[1]

	return setmetatable({
		device = device,
		pool = pool,
		buffer = buffer,
	}, VKCommandBuffer)
end

return VKCommandBuffer
