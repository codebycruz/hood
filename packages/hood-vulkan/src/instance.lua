local ffi = require("ffi")

---@param vk vk
return function(vk)
	local VKDevice = require("hood-vulkan.device")(vk)

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

		return VKDevice.new(device[0])
	end

	---@return vk.ffi.PhysicalDevice[]
	function VKInstance:enumeratePhysicalDevices()
		local deviceCount = ffi.new("uint32_t[1]", 0)
		local result = self.v1_0.vkEnumeratePhysicalDevices(self.handle, deviceCount, nil)
		if result ~= 0 then
			error("Failed to enumerate physical devices, error code: " .. tostring(result))
		end

		local devices = ffi.new("VkPhysicalDevice[?]", deviceCount[0])
		result = self.v1_0.vkEnumeratePhysicalDevices(self.handle, deviceCount, devices)
		if result ~= 0 then
			error("Failed to enumerate physical devices, error code: " .. tostring(result))
		end

		local deviceList = {}
		for i = 0, deviceCount[0] - 1 do
			deviceList[i + 1] = devices[i]
		end

		return deviceList
	end

	---@class vk.Instance.Fns
	---@field vkCreateDevice fun(physicalDevice: vk.ffi.PhysicalDevice, info: vk.ffi.DeviceCreateInfo?, allocator: ffi.cdata*?, device: vk.ffi.Device*): vk.ffi.Result
	---@field vkEnumeratePhysicalDevices fun(instance: vk.ffi.Instance, count: ffi.cdata*, devices: ffi.cdata*?): vk.ffi.Result

	---@param handle vk.ffi.Instance
	function VKInstance.new(handle)
		local v1_0Types = {
			vkCreateDevice = "VkResult(*)(VkPhysicalDevice, const VkDeviceCreateInfo*, const void*, VkDevice*)",
			vkEnumeratePhysicalDevices = "VkResult(*)(VkInstance, uint32_t*, VkPhysicalDevice*)",
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

	return VKInstance
end
