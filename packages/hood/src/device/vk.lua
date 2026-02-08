local VKBuffer = require("hood.buffer.vk")
local VKQueue = require("hood.queue.vk")

---@class hood.vk.Device
---@field public queue hood.vk.Queue
---@field handle vk.Device
local VKDevice = {}
VKDevice.__index = VKDevice

---@param adapter hood.vk.Adapter
function VKDevice.new(adapter)
	local handle = adapter.instance.handle:createDevice(adapter.pd, {
		enabledExtensionNames = { "VK_KHR_swapchain" },
		queueCreateInfos = {
			{
				queueFamilyIndex = adapter.gfxQueueFamilyIdx,
				queuePriorities = { 1.0 },
				queueCount = 1,
			},
		},
	})

	local device = setmetatable({ handle = handle }, VKDevice)
	device.queue = VKQueue.new(device, adapter.gfxQueueFamilyIdx, 0)

	return device
end

---@param descriptor hood.BufferDescriptor
function VKDevice:createBuffer(descriptor)
	return VKBuffer.new(self, descriptor)
end

return VKDevice
