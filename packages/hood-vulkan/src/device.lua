local ffi = require("ffi")

---@param vk vk
return function(vk)
	---@class vk.Device
	---@field handle vk.ffi.Device
	---@field v1_0 vk.Device.Fns
	local VKDevice = {}
	VKDevice.__index = VKDevice

	---@class vk.Device.Fns

	---@param handle vk.ffi.Device
	function VKDevice.new(handle)
		local v1_0Types = {
			-- types go here
		}

		---@type vk.Device.Fns
		local v1_0 = {}
		for name, funcType in pairs(v1_0Types) do
			v1_0[name] = ffi.cast(funcType, vk.getDeviceProcAddr(handle, name))
		end

		return setmetatable({
			handle = handle,
			v1_0 = v1_0,
		}, VKDevice)
	end

	return VKDevice
end
