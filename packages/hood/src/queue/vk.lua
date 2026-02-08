local vk = require("hood-vulkan")
local ffi = require("ffi")

local VKCommandEncoder = require("hood.command_encoder.vk")

---@class hood.vk.Queue
---@field device hood.vk.Device
---@field handle vk.ffi.Queue
---@field familyIdx number
---@field idx number
local VKQueue = {}
VKQueue.__index = VKQueue

---@param device hood.vk.Device
---@param familyIdx number
---@param idx number
function VKQueue.new(device, familyIdx, idx)
	local handle = device.handle:getDeviceQueue(familyIdx, idx)
	return setmetatable({ device = device, handle = handle, familyIdx = familyIdx, idx = idx }, VKQueue)
end

---@type vk.ffi.SubmitInfo
local submitInfo1 = { commandBufferCount = 0, pCommandBuffers = nil }

---@type vk.ffi.SubmitInfo[]
local submitInfoTbl = { submitInfo1 }

---@param buffer hood.vk.CommandBuffer
function VKQueue:submit(buffer)
	submitInfo1.commandBufferCount = 1
	submitInfo1.pCommandBuffers = ffi.new("VkCommandBuffer[1]", buffer.buffer)

	self.device.handle:queueSubmit(self.handle, submitInfoTbl, nil)
end

--- Helper method to write data to a buffer
---@param buffer hood.gl.Buffer
---@param size number
---@param data ffi.cdata*
---@param offset number?
function VKQueue:writeBuffer(buffer, size, data, offset)
	local cmd = VKCommandEncoder.new(self.device)
	cmd:writeBuffer(buffer, size, data, offset)
	self:submit(cmd:finish())
end

return VKQueue
