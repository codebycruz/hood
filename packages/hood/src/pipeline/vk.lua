---@class hood.vk.Pipeline
local VKPipeline = {}
VKPipeline.__index = VKPipeline

---@param device hood.vk.Device
---@param descriptor hood.PipelineDescriptor
function VKPipeline.new(device, descriptor)
	if descriptor.fragment.module.type ~= "spirv" or descriptor.vertex.module.type ~= "spirv" then
		error("Only SPIR-V shaders are supported in the Vulkan backend.")
	end

	error("Unimplemented: Pipeline creation is not yet implemented in the Vulkan backend.")
	-- device.handle:createGraphicsPipelines()
end

return VKPipeline
