local vk = require("hood-vulkan")

---@class hood.vk.CommandBuffer
---@field device hood.vk.Device
---@field pool vk.CommandPool
---@field handle vk.ffi.CommandBuffer
local VKCommandBuffer = {}
VKCommandBuffer.__index = VKCommandBuffer

---@param device hood.vk.Device
function VKCommandBuffer.new(device)
	local pool = device.handle:createCommandPool({
		flags = vk.CommandPoolCreateFlagBits.RESET_COMMAND_BUFFER,
		queueFamilyIndex = device.queue.familyIdx,
	})

	local handle = device.handle:allocateCommandBuffers({
		commandPool = pool,
		level = vk.CommandBufferLevel.PRIMARY,
		commandBufferCount = 1,
	})[1]

	return setmetatable({
		device = device,
		pool = pool,
		handle = handle,
	}, VKCommandBuffer)
end

return VKCommandBuffer
