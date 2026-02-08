local ffi = require("ffi")

ffi.cdef([[#embed "ffi/ffidefs.h"]])

local vkEnums = require("hood-vulkan.ffi.enums")

---@class vk: vk.RawEnums
local vk = {}
for k, v in pairs(vkEnums) do
	vk[k] = v
end

local VKDevice = require("hood-vulkan.device")(vk)
vk.Device = VKDevice

local VKInstance = require("hood-vulkan.instance")(vk)

do
	local C = ffi.load("vulkan.so.1")

	---@param info vk.ffi.InstanceCreateInfo
	---@param allocator ffi.cdata*?
	---@return vk.Instance
	function vk.createInstance(info, allocator)
		local instance = ffi.new("VkInstance[1]")
		local info = ffi.new("VkInstanceCreateInfo", info)
		info.sType = vkEnums.StructureType.INSTANCE_CREATE_INFO

		local result = C.vkCreateInstance(info, allocator, instance)
		if result ~= 0 then
			error("Failed to create Vulkan instance, error code: " .. tostring(result))
		end

		return VKInstance.new(instance[0])
	end

	---@param instance vk.Instance
	---@return vk.ffi.PhysicalDevice[]
	function vk.enumeratePhysicalDevices(instance)
		local deviceCount = ffi.new("uint32_t[1]", 0)
		local result = C.vkEnumeratePhysicalDevices(instance, deviceCount, nil)
		if result ~= 0 then
			error("Failed to enumerate physical devices, error code: " .. tostring(result))
		end

		local devices = ffi.new("VkPhysicalDevice[?]", deviceCount[0])
		result = C.vkEnumeratePhysicalDevices(instance, deviceCount, devices)
		if result ~= 0 then
			error("Failed to enumerate physical devices, error code: " .. tostring(result))
		end

		local deviceList = {}
		for i = 0, deviceCount[0] - 1 do
			deviceList[i + 1] = devices[i]
		end

		return deviceList
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	function vk.getPhysicalDeviceProperties(physicalDevice)
		local properties = ffi.new("VkPhysicalDeviceProperties")
		C.vkGetPhysicalDeviceProperties(physicalDevice, properties)
		return properties --[[@as vk.ffi.PhysicalDeviceProperties]]
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@return vk.ffi.PhysicalDeviceMemoryProperties
	function vk.getPhysicalDeviceMemoryProperties(physicalDevice)
		local memProperties = ffi.new("VkPhysicalDeviceMemoryProperties")
		C.vkGetPhysicalDeviceMemoryProperties(physicalDevice, memProperties)
		return memProperties --[[@as vk.ffi.PhysicalDeviceMemoryProperties]]
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@return vk.ffi.QueueFamilyProperties[]
	function vk.getPhysicalDeviceQueueFamilyProperties(physicalDevice)
		local count = ffi.new("uint32_t[1]")
		C.vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, count, nil)

		local properties = ffi.new("VkQueueFamilyProperties[?]", count[0])
		C.vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, count, properties)

		local propertyTable = {}
		for i = 0, count[0] - 1 do
			propertyTable[i + 1] = properties[i]
		end
		return propertyTable
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@param surface vk.ffi.SurfaceKHR
	---@return vk.ffi.SurfaceCapabilitiesKHR
	function vk.getPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface)
		local capabilities = ffi.new("VkSurfaceCapabilitiesKHR")
		local result = C.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, capabilities)
		if result ~= 0 then
			error("Failed to get physical device surface capabilities, error code: " .. tostring(result))
		end
		return capabilities --[[@as vk.ffi.SurfaceCapabilitiesKHR]]
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@param surface vk.ffi.SurfaceKHR
	---@return vk.ffi.SurfaceFormatKHR[]
	function vk.getPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface)
		local count = ffi.new("uint32_t[1]")
		local result = C.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, count, nil)
		if result ~= 0 then
			error("Failed to get surface format count, error code: " .. tostring(result))
		end

		local formats = ffi.new("VkSurfaceFormatKHR[?]", count[0])
		result = C.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, count, formats)
		if result ~= 0 then
			error("Failed to get surface formats, error code: " .. tostring(result))
		end

		local formatTable = {}
		for i = 0, count[0] - 1 do
			formatTable[i + 1] = formats[i]
		end
		return formatTable
	end

	---@param physicalDevice vk.ffi.PhysicalDevice
	---@param surface vk.ffi.SurfaceKHR
	---@return number[]
	function vk.getPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface)
		local count = ffi.new("uint32_t[1]")
		local result = C.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, count, nil)
		if result ~= 0 then
			error("Failed to get present mode count, error code: " .. tostring(result))
		end

		local modes = ffi.new("VkPresentModeKHR[?]", count[0])
		result = C.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, count, modes)
		if result ~= 0 then
			error("Failed to get present modes, error code: " .. tostring(result))
		end

		local modeTable = {}
		for i = 0, count[0] - 1 do
			modeTable[i + 1] = modes[i]
		end
		return modeTable
	end

	---@type fun(instance: vk.ffi.Instance, name: string): ffi.cdata*
	vk.getInstanceProcAddr = C.vkGetInstanceProcAddr

	---@type fun(device: vk.ffi.Device, name: string): ffi.cdata*
	vk.getDeviceProcAddr = C.vkGetDeviceProcAddr
end

function vk.newRenderPassBeginInfo()
	local info = ffi.new("VkRenderPassBeginInfo")
	info.sType = vk.StructureType.RENDER_PASS_BEGIN_INFO
	return info --[[@as vk.ffi.RenderPassBeginInfo]]
end

return vk
