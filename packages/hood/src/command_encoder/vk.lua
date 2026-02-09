local ffi = require("ffi")
local vk = require("hood-vulkan")
local hood = require("hood")

local VKCommandBuffer = require("hood.command_buffer.vk")

---@class hood.vk.CommandEncoder
---@field buffer hood.vk.CommandBuffer
---@field device hood.vk.Device
---@field pendingDescriptor hood.RenderPassDescriptor?
local VKCommandEncoder = {}
VKCommandEncoder.__index = VKCommandEncoder

---@param device hood.vk.Device
---@return hood.vk.CommandEncoder
function VKCommandEncoder.new(device)
	local buffer = VKCommandBuffer.new(device)
	device.handle:beginCommandBuffer(buffer.handle)
	return setmetatable({ device = device, buffer = buffer }, VKCommandEncoder)
end

---@param descriptor hood.RenderPassDescriptor
function VKCommandEncoder:beginRendering(descriptor)
	self.pendingDescriptor = descriptor
end

---@param pipeline hood.vk.Pipeline
function VKCommandEncoder:setPipeline(pipeline)
	if self.pendingDescriptor then
		self:_beginRenderPass(pipeline.renderPass, self.pendingDescriptor)
		self.pendingDescriptor = nil
	end

	self.device.handle:cmdBindPipeline(self.buffer.handle, vk.PipelineBindPoint.GRAPHICS, pipeline.handle)
end

---@param renderPass vk.ffi.RenderPass
---@param descriptor hood.RenderPassDescriptor
function VKCommandEncoder:_beginRenderPass(renderPass, descriptor)
	local colorAttachments = descriptor.colorAttachments or {}
	local depthAttachment = descriptor.depthStencilAttachment
	local totalAttachments = #colorAttachments + (depthAttachment and 1 or 0)

	local firstTexture = colorAttachments[1] and colorAttachments[1].texture
		or depthAttachment and depthAttachment.texture
	local width = firstTexture.width
	local height = firstTexture.height

	local imageViews = ffi.new("VkImageView[?]", totalAttachments)

	for i, att in ipairs(colorAttachments) do
		imageViews[i - 1] = self.device.handle:createImageView({
			image = att.texture.handle,
			viewType = vk.ImageViewType.TYPE_2D,
			format = att.texture.format,
			subresourceRange = {
				aspectMask = vk.ImageAspectFlagBits.COLOR,
				baseMipLevel = 0,
				levelCount = 1,
				baseArrayLayer = 0,
				layerCount = 1,
			},
		})
	end

	if depthAttachment then
		imageViews[totalAttachments - 1] = self.device.handle:createImageView({
			image = depthAttachment.texture.handle,
			viewType = vk.ImageViewType.TYPE_2D,
			format = depthAttachment.texture.format,
			subresourceRange = {
				aspectMask = vk.ImageAspectFlagBits.DEPTH,
				baseMipLevel = 0,
				levelCount = 1,
				baseArrayLayer = 0,
				layerCount = 1,
			},
		})
	end

	local framebuffer = self.device.handle:createFramebuffer({
		renderPass = renderPass,
		attachmentCount = totalAttachments,
		pAttachments = imageViews,
		width = width,
		height = height,
		layers = 1,
	})

	local clearValues = ffi.new("VkClearValue[?]", totalAttachments)

	for i, att in ipairs(colorAttachments) do
		if att.op.type == "clear" then
			local c = att.op.color
			clearValues[i - 1].color.float32[0] = c.r
			clearValues[i - 1].color.float32[1] = c.g
			clearValues[i - 1].color.float32[2] = c.b
			clearValues[i - 1].color.float32[3] = c.a
		end
	end

	if depthAttachment and depthAttachment.op.type == "clear" then
		clearValues[totalAttachments - 1].depthStencil.depth = depthAttachment.op.depth
		clearValues[totalAttachments - 1].depthStencil.stencil = 0
	end

	local beginInfo = vk.RenderPassBeginInfo()
	beginInfo.renderPass = renderPass
	beginInfo.framebuffer = framebuffer
	beginInfo.renderArea.offset.x = 0
	beginInfo.renderArea.offset.y = 0
	beginInfo.renderArea.extent.width = width
	beginInfo.renderArea.extent.height = height
	beginInfo.clearValueCount = totalAttachments
	beginInfo.pClearValues = clearValues

	self.device.handle:cmdBeginRenderPass(self.buffer.handle, beginInfo, vk.SubpassContents.INLINE)
end

do
	local viewport = ffi.new("VkViewport")
	local scissor = ffi.new("VkRect2D")

	---@param x number
	---@param y number
	---@param width number
	---@param height number
	function VKCommandEncoder:setViewport(x, y, width, height)
		viewport.x = x
		viewport.y = y + height
		viewport.width = width
		viewport.height = -height
		viewport.minDepth = 0
		viewport.maxDepth = 1

		scissor.offset.x = x
		scissor.offset.y = y
		scissor.extent.width = width
		scissor.extent.height = height

		self.device.handle:cmdSetViewport(self.buffer.handle, 0, 1, viewport)
		self.device.handle:cmdSetScissor(self.buffer.handle, 0, 1, scissor)
	end
end

do
	local buffers = ffi.new("VkBuffer[1]")
	local offsets = ffi.new("VkDeviceSize[1]")

	---@param slot number
	---@param buffer hood.vk.Buffer
	---@param offset number?
	function VKCommandEncoder:setVertexBuffer(slot, buffer, offset)
		buffers[0] = buffer.handle
		offsets[0] = offset or 0
		self.device.handle:cmdBindVertexBuffers(self.buffer.handle, slot, 1, buffers, offsets)
	end
end

local indexTypeMap = {
	[hood.IndexType.u16] = 0, -- VK_INDEX_TYPE_UINT16
	[hood.IndexType.u32] = 1, -- VK_INDEX_TYPE_UINT32
}

---@param buffer hood.vk.Buffer
---@param format hood.IndexFormat
---@param offset number?
function VKCommandEncoder:setIndexBuffer(buffer, format, offset)
	self.device.handle:cmdBindIndexBuffer(self.buffer.handle, buffer.handle, offset or 0, indexTypeMap[format])
end

---@param indexCount number
---@param instanceCount number
---@param firstIndex number?
---@param baseVertex number?
---@param firstInstance number?
function VKCommandEncoder:drawIndexed(indexCount, instanceCount, firstIndex, baseVertex, firstInstance)
	self.device.handle:cmdDrawIndexed(self.buffer.handle, indexCount, instanceCount or 1, firstIndex or 0,
		baseVertex or 0, firstInstance or 0)
end

function VKCommandEncoder:endRendering()
	self.device.handle:cmdEndRenderPass(self.buffer.handle)
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
