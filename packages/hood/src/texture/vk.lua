local hood = require("hood")
local vk = require("hood-vulkan")

---@class hood.vk.Texture
---@field handle vk.ffi.Image
---@field format vk.Format?
---@field width number?
---@field height number?
local VKTexture = {}
VKTexture.__index = VKTexture

local dimToImageType = {
	["1d"] = vk.ImageType.TYPE_1D,
	["2d"] = vk.ImageType.TYPE_2D,
	["3d"] = vk.ImageType.TYPE_3D
}

---@type table<hood.TextureFormat, vk.Format>
local textureFormatToVkFormat = {
	[hood.TextureFormat.Rgba8UNorm] = vk.Format.R8G8B8A8_UNORM,
	[hood.TextureFormat.Rgba8Uint] = vk.Format.R8G8B8A8_UINT,
	[hood.TextureFormat.Depth16Unorm] = vk.Format.D16_UNORM,
	[hood.TextureFormat.Depth24Plus] = vk.Format.X8_D24_UNORM_PACK32,
	[hood.TextureFormat.Depth32Float] = vk.Format.D32_SFLOAT,
	[hood.TextureFormat.Bgra8UNorm] = vk.Format.B8G8R8A8_UNORM,
}

---@type table<number, vk.SampleCountFlagBits>
local sampleCountToVkSampleCount = {
	[1] = vk.SampleCountFlagBits.COUNT_1,
	[2] = vk.SampleCountFlagBits.COUNT_2,
	[4] = vk.SampleCountFlagBits.COUNT_4,
	[8] = vk.SampleCountFlagBits.COUNT_8,
	[16] = vk.SampleCountFlagBits.COUNT_16,
	[32] = vk.SampleCountFlagBits.COUNT_32,
	[64] = vk.SampleCountFlagBits.COUNT_64,
}

---@type table<hood.TextureUsage, vk.ImageUsageFlagBits>
local usageToVkUsage = {
	["COPY_SRC"] = vk.ImageUsageFlagBits.TRANSFER_SRC,
	["COPY_DST"] = vk.ImageUsageFlagBits.TRANSFER_DST,
	["TEXTURE_BINDING"] = vk.ImageUsageFlagBits.SAMPLED,
	["STORAGE_BINDING"] = vk.ImageUsageFlagBits.STORAGE,
	["RENDER_ATTACHMENT"] = vk.ImageUsageFlagBits.COLOR_ATTACHMENT,
}

---@param device hood.vk.Device
---@param descriptor hood.TextureDescriptor
function VKTexture.new(device, descriptor)
	local samples = sampleCountToVkSampleCount[descriptor.sampleCount or 0]
	if not samples then
		error("Unsupported sample count: " .. tostring(descriptor.sampleCount))
	end

	local layers = descriptor.extents.dim ~= "3d" and descriptor.extents.count or 1

	---@type vk.ImageUsageFlagBits
	local vkUsage = 0
	for _, usage in ipairs(descriptor.usages) do
		vkUsage = bit.bor(vkUsage, usageToVkUsage[usage])
	end

	local handle = device.handle:createImage({
		imageType = dimToImageType[descriptor.extents.dim],
		format = textureFormatToVkFormat[descriptor.format],
		extent = {
			width = descriptor.extents.width,
			height = descriptor.extents.height,
			depth = descriptor.extents.depth,
		},
		mipLevels = descriptor.mipLevelCount,
		arrayLayers = layers,
		samples = samples,
		tiling = vk.ImageTiling.OPTIMAL,
		usage = vkUsage,
		sharingMode = vk.SharingMode.EXCLUSIVE,
		initialLayout = vk.ImageLayout.UNDEFINED,
	})

	return setmetatable({ handle = handle }, VKTexture)
end

function VKTexture.fromRaw(device, handle, format, width, height)
	return setmetatable({ handle = handle, format = format, width = width, height = height }, VKTexture)
end

return VKTexture
