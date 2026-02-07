local vk = require("hood-vulkan")

local VKDevice = require("hood.device.vk")

---@class hood.vk.Adapter
---@field pd vk.PhysicalDevice
---@field gfxQueueFamilyIdx number
local VKAdapter = {}
VKAdapter.__index = VKAdapter

---@param physicalDevice vk.PhysicalDevice
function VKAdapter.new(physicalDevice)
	local queueFamilies = vk.getPhysicalDeviceQueueFamilyProperties(physicalDevice)

	local gfxQueueFamilyIdx = nil
	for i, family in ipairs(queueFamilies) do
		if bit.band(family.queueFlags, vk.QueueFlagBits.GRAPHICS) ~= 0 then
			gfxQueueFamilyIdx = i - 1 -- zero-based index
			break
		end
	end

	if not gfxQueueFamilyIdx then
		error("No graphics queue family found")
	end

	return setmetatable({ pd = physicalDevice, gfxQueueFamilyIdx = gfxQueueFamilyIdx }, VKAdapter)
end

function VKAdapter:requestDevice()
	return VKDevice.new(self)
end

return VKAdapter
