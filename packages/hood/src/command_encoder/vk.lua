local vk = require("hood-vulkan")

local VKCommandBuffer = require("hood.command_buffer.vk")

---@class hood.vk.CommandEncoder
---@field buffer hood.vk.CommandBuffer
---@field device hood.vk.Device
local VKCommandEncoder = {}
VKCommandEncoder.__index = VKCommandEncoder

---@param device hood.vk.Device
---@return hood.vk.CommandEncoder
function VKCommandEncoder.new(device)
	local buffer = VKCommandBuffer.new(device)
	device.handle:beginCommandBuffer(buffer.handle)
	return setmetatable({ device = device, buffer = buffer }, VKCommandEncoder)
end

---@type table<hood.RenderPassDescriptor, { beginInfo: vk.ffi.RenderPassBeginInfo, renderPass }>
local cachedDescriptors = setmetatable({}, { __mode = "k" })

--- SAFETY: This assumes the descriptor is a frozen table and will never be mutated.
--- It will ignore any changes made to the descriptor after this call via caching for performance reasons.
---@param descriptor hood.RenderPassDescriptor
function VKCommandEncoder:beginRendering(descriptor)
	local vkDescriptor = cachedDescriptors[descriptor]
	if not vkDescriptor then
		vkDescriptor = vk.newRenderPassBeginInfo()

		-- TODO: Need to get a renderpass here.
		-- cachedDescriptors[descriptor] = vkDescriptor
	end

	vk.cmdBeginRenderPass(self.buffer.handle, descriptor.renderPassBeginInfo, vk.SubpassContents.INLINE)
end

---@param buffer hood.vk.Buffer
---@param size number
---@param data ffi.cdata*
---@param offset number?
function VKCommandEncoder:writeBuffer(buffer, size, data, offset)
	self.device.handle:cmdUpdateBuffer(self.buffer.handle, buffer.handle, offset or 0, size, data)
end

function VKCommandEncoder:finish()
	self.device.handle:endCommandBuffer(self.buffer.handle)
	return self.buffer
end

return VKCommandEncoder
