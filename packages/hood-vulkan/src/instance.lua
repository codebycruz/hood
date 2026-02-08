local ffi = require("ffi")

---@param vk vk
return function(vk)
	---@class vk.Instance
	---@field handle vk.ffi.Instance
	---@field v1_0 vk.Instance.Fns
	local VKInstance = {}
	VKInstance.__index = VKInstance

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@param info vk.ffi.DeviceCreateInfo?
	---@param allocator ffi.cdata*?
	---@return vk.Device
	function VKInstance:createDevice(physicalDevice, info, allocator)
		local device = ffi.new("VkDevice[1]")
		local info = ffi.new("VkDeviceCreateInfo", info or {})
		info.sType = vk.StructureType.DEVICE_CREATE_INFO

		local result = self.v1_0.vkCreateDevice(physicalDevice, info, allocator, device)
		if result ~= 0 then
			error("Failed to create Vulkan device, error code: " .. tostring(result))
		end

		return vk.Device.new(device[0])
	end

	---@class vk.Instance.Fns
	---@field vkCreateDevice fun(physicalDevice: vk.ffi.PhysicalDevice, info: vk.ffi.DeviceCreateInfo?, allocator: ffi.cdata*?, device: vk.ffi.Device*): vk.ffi.Result

	---@param handle vk.ffi.Instance
	function VKInstance.new(handle)
		local v1_0Types = {
			vkCreateDevice = "VkResult(*)(VkPhysicalDevice, const VkDeviceCreateInfo*, const void*, VkDevice*)",
		}

		---@type vk.Instance.Fns
		local v1_0 = {}
		for name, funcType in pairs(v1_0Types) do
			v1_0[name] = ffi.cast(funcType, vk.getInstanceProcAddr(handle, name))
		end

		return setmetatable({
			handle = handle,
			v1_0 = v1_0,
		}, VKInstance)
	end
end
