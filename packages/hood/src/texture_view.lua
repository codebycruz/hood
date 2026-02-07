---@class hood.TextureView
local TextureView = VULKAN and require("hood.texture_view.vk")
	or require("hood.texture_view.gl") --[[@as hood.TextureView]]
