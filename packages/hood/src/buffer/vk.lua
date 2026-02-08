local vk = require("hood-vulkan")

---@class hood.vk.Buffer
---@field handle vk.ffi.Buffer
---@field device hood.vk.Device
---@field descriptor hood.BufferDescriptor
local VKBuffer = {}
VKBuffer.__index = VKBuffer

---@param device hood.vk.Device
---@param descriptor hood.BufferDescriptor
function VKBuffer.new(device, descriptor)
	local vkUsage = 0

	for _, usage in ipairs(descriptor.usages) do
		if usage == "VERTEX" then
			vkUsage = bit.bor(vkUsage, vk.BufferUsage.VERTEX_BUFFER)
		elseif usage == "INDEX" then
			vkUsage = bit.bor(vkUsage, vk.BufferUsage.INDEX_BUFFER)
		elseif usage == "UNIFORM" then
			vkUsage = bit.bor(vkUsage, vk.BufferUsage.UNIFORM_BUFFER)
		end
	end

	if vkUsage == 0 then
		error("No valid buffer usage specified")
	end

	---@diagnostic disable-next-line: assign-type-mismatch: vkUsage is checked above
	local handle = device.handle:createBuffer({ size = descriptor.size, usage = vkUsage })

	return setmetatable({ device = device, handle = handle, descriptor = descriptor }, VKBuffer)
end

function VKBuffer:destroy()
	self.device:destroyBuffer(self.handle)
end

function VKBuffer:__tostring()
	return "VKBuffer(" .. tostring(self.buffer) .. ")"
end

return VKBuffer
