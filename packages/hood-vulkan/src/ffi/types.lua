---@class vk.ffi.BaseStruct
---@field sType vk.StructureType?
---@field pNext userdata?
---@field flags number?

---@class vk.ffi.Instance: number
---@class vk.ffi.Result: number
---@class vk.ffi.PhysicalDevice: ffi.cdata*
---@class vk.ffi.Device: number
---@class vk.ffi.PipelineCache: number
---@class vk.ffi.DeviceSize: number
---@class vk.ffi.Buffer: number
---@class vk.ffi.PipelineLayout: number
---@class vk.ffi.Pipeline: number
---@class vk.ffi.RenderPass: number
---@class vk.ffi.Framebuffer: number
---@class vk.ffi.ShaderModule: number
---@class vk.ffi.CommandPool: number
---@class vk.ffi.CommandBuffer: number
---@class vk.ffi.DescriptorSetLayout: number
---@class vk.ffi.DescriptorPool: number
---@class vk.ffi.DescriptorSet: number
---@class vk.ffi.Queue: number
---@class vk.ffi.Semaphore: number
---@class vk.ffi.Fence: number
---@class vk.ffi.Image: number
---@class vk.ffi.DeviceMemory: number
---@class vk.ffi.Sampler: number
---@class vk.ffi.ImageView: number
---@class vk.ffi.SwapchainKHR: number
---@class vk.ffi.SurfaceKHR: number

---@class vk.ffi.MemoryRequirements: ffi.cdata*
---@field size vk.ffi.DeviceSize
---@field alignment vk.ffi.DeviceSize
---@field memoryTypeBits number

---@class vk.ffi.CreateImageInfo: vk.ffi.BaseStruct
---@field imageType vk.ImageType
---@field format vk.Format
---@field extent vk.ffi.Extent3D
---@field mipLevels number
---@field arrayLayers number
---@field samples vk.SamplecountFlags
---@field tiling vk.ImageTiling
---@field usage vk.ImageUsageFlags
---@field sharingMode vk.SharingMode
---@field queueFamilyIndexCount number?
---@field pQueueFamilyIndices ffi.cdata*?
---@field initialLayout vk.ImageLayout

---@class vk.ffi.MemoryType: ffi.cdata*
---@field propertyFlags number
---@field heapIndex number

---@class vk.ffi.MemoryHeap: ffi.cdata*
---@field size number
---@field flags number

---@class vk.ffi.Extent2D: ffi.cdata*
---@field width number
---@field height number

---@class vk.ffi.Extent3D: ffi.cdata*
---@field width number
---@field height number
---@field depth number

---@class vk.ffi.PhysicalDeviceMemoryProperties: ffi.cdata*
---@field memoryTypeCount number
---@field memoryTypes ffi.cdata*
---@field memoryHeapCount number
---@field memoryHeaps ffi.cdata*

---@class vk.ffi.QueueFamilyProperties: ffi.cdata*
---@field queueFlags number
---@field queueCount number
---@field timestampValidBits number
---@field minImageTransferGranularity vk.ffi.Extent3D

---@class vk.ffi.MemoryAllocateInfo: vk.ffi.BaseStruct
---@field allocationSize number
---@field memoryTypeIndex number

---@class vk.ffi.SurfaceCapabilitiesKHR: ffi.cdata*
---@field minImageCount number
---@field maxImageCount number
---@field currentExtent table
---@field minImageExtent table
---@field maxImageExtent table
---@field maxImageArrayLayers number
---@field supportedTransforms number
---@field currentTransform number
---@field supportedCompositeAlpha number
---@field supportedUsageFlags number

---@class vk.ffi.SurfaceFormatKHR: ffi.cdata*
---@field format number
---@field colorSpace number

---@class vk.ffi.ApplicationInfo: vk.ffi.BaseStruct
---@field pApplicationName ffi.cdata*?
---@field applicationVersion number
---@field pEngineName ffi.cdata*?
---@field engineVersion number
---@field apiVersion vk.ApiVersion

---@class vk.ffi.InstanceCreateInfo: vk.ffi.BaseStruct
---@field pApplicationInfo vk.ffi.ApplicationInfo?
---@field enabledLayerCount number?
---@field ppEnabledLayerNames ffi.cdata*?
---@field enabledExtensionCount number?
---@field ppEnabledExtensionNames ffi.cdata*?

---@class vk.ffi.DeviceCreateInfo: vk.ffi.BaseStruct
---@field queueCreateInfoCount number?
---@field pQueueCreateInfos userdata?
---@field enabledExtensionCount number?
---@field ppEnabledExtensionNames userdata?
---@field pEnabledFeatures userdata?

---@class vk.ffi.BufferCreateInfo: vk.ffi.BaseStruct
---@field size number
---@field usage vk.BufferUsage
---@field sharingMode vk.SharingMode?
---@field queueFamilyIndexCount number?
---@field pQueueFamilyIndices userdata?

---@class vk.ffi.ShaderModuleCreateInfo: vk.ffi.BaseStruct
---@field codeSize number
---@field pCode userdata

---@class vk.ffi.PipelineLayoutCreateInfo: vk.ffi.BaseStruct
---@field setLayoutCount number?
---@field pSetLayouts userdata?
---@field pushConstantRangeCount number?
---@field pPushConstantRanges userdata?

---@class vk.ffi.SpecializationInfo: ffi.cdata*
---@field mapEntryCount number
---@field pMapEntries ffi.cdata*
---@field dataSize number
---@field pData ffi.cdata*

---@class vk.ffi.PipelineShaderStageCreateInfo: vk.ffi.BaseStruct
---@field stage vk.ShaderStageFlagBits
---@field module vk.ffi.ShaderModule
---@field pName ffi.cdata*
---@field pSpecializationInfo vk.ffi.SpecializationInfo?

---@class vk.ffi.VertexInputBindingDescription: ffi.cdata*
---@field binding number
---@field stride number
---@field inputRate vk.VertexInputRate

---@class vk.ffi.VertexInputAttributeDescription: ffi.cdata*
---@field location number
---@field binding number
---@field format vk.Format
---@field offset number

---@class vk.ffi.PipelineVertexInputStateCreateInfo: vk.ffi.BaseStruct
---@field vertexBindingDescriptionCount number
---@field pVertexBindingDescriptions vk.ffi.VertexInputBindingDescription*
---@field vertexAttributeDescriptionCount number
---@field pVertexAttributeDescriptions vk.ffi.VertexInputAttributeDescription*

---@class vk.ffi.GraphicsPipelineCreateInfo: vk.ffi.BaseStruct
---@field stageCount number
---@field pStages vk.ffi.PipelineShaderStageCreateInfo
---@field pVertexInputState userdata?
---@field pInputAssemblyState userdata?
---@field pTessellationState userdata?
---@field pViewportState userdata?
---@field pRasterizationState userdata?
---@field pMultisampleState userdata?
---@field pDepthStencilState userdata?
---@field pColorBlendState userdata?
---@field pDynamicState userdata?
---@field layout vk.ffi.PipelineLayout
---@field renderPass vk.ffi.RenderPass
---@field subpass number?

---@class vk.ffi.RenderPassCreateInfo: vk.ffi.BaseStruct
---@field attachmentCount number?
---@field pAttachments userdata?
---@field subpassCount number
---@field pSubpasses userdata
---@field dependencyCount number?
---@field pDependencies userdata?

---@class vk.ffi.FramebufferCreateInfo: vk.ffi.BaseStruct
---@field renderPass vk.ffi.RenderPass
---@field attachmentCount number?
---@field pAttachments userdata?
---@field width number
---@field height number
---@field layers number

---@class vk.ffi.CommandPoolCreateInfo: vk.ffi.BaseStruct
---@field flags number?
---@field queueFamilyIndex number

---@class vk.ffi.CommandBufferAllocateInfo: vk.ffi.BaseStruct
---@field commandPool vk.ffi.CommandPool
---@field level number
---@field commandBufferCount number

---@class vk.DescriptorSetLayoutBinding: ffi.cdata*
---@field binding number
---@field descriptorType number
---@field descriptorCount number
---@field stageFlags number
---@field pImmutableSamplers ffi.cdata*?

---@class vk.ffi.DescriptorSetLayoutCreateInfo: vk.ffi.BaseStruct
---@field bindingCount number?
---@field pBindings ffi.cdata*?

---@class vk.ffi.DescriptorPoolSize: ffi.cdata*
---@field type number
---@field descriptorCount number

---@class vk.ffi.DescriptorPoolCreateInfo: vk.ffi.BaseStruct
---@field maxSets number
---@field poolSizeCount number?
---@field pPoolSizes ffi.cdata*?

---@class vk.ffi.DescriptorSetAllocateInfo: vk.ffi.BaseStruct
---@field descriptorPool vk.ffi.DescriptorPool
---@field descriptorSetCount number
---@field pSetLayouts ffi.cdata*

---@class vk.ffi.DescriptorBufferInfo: ffi.cdata*
---@field buffer vk.ffi.Buffer
---@field offset number
---@field range number

---@class vk.ffi.DescriptorImageInfo: ffi.cdata*
---@field sampler number
---@field imageView number
---@field imageLayout number

---@class vk.ffi.WriteDescriptorSet: vk.ffi.BaseStruct
---@field dstSet vk.ffi.DescriptorSet
---@field dstBinding number
---@field dstArrayElement number
---@field descriptorCount number
---@field descriptorType number
---@field pImageInfo ffi.cdata*?
---@field pBufferInfo ffi.cdata*?
---@field pTexelBufferView ffi.cdata*?

---@class vk.ffi.SwapchainCreateInfoKHR: vk.ffi.BaseStruct
---@field surface vk.ffi.SurfaceKHR
---@field minImageCount number
---@field imageFormat number
---@field imageColorSpace number
---@field imageExtent userdata
---@field imageArrayLayers number
---@field imageUsage number
---@field imageSharingMode number
---@field queueFamilyIndexCount number?
---@field pQueueFamilyIndices userdata?
---@field preTransform number
---@field compositeAlpha number
---@field presentMode number
---@field clipped number
---@field oldSwapchain vk.ffi.SwapchainKHR

---@class vk.ffi.CommandBufferBeginInfo: vk.ffi.BaseStruct
---@field pInheritanceInfo userdata?

---@class vk.ffi.RenderPassBeginInfo: vk.ffi.BaseStruct
---@field renderPass vk.ffi.RenderPass
---@field framebuffer vk.ffi.Framebuffer
---@field renderArea table
---@field clearValueCount number?
---@field pClearValues userdata?

---@class vk.ffi.SemaphoreCreateInfo: vk.ffi.BaseStruct

---@class vk.ffi.FenceCreateInfo: vk.ffi.BaseStruct

---@class vk.ffi.PresentInfoKHR: vk.ffi.BaseStruct
---@field waitSemaphoreCount number?
---@field pWaitSemaphores ffi.cdata*?
---@field swapchainCount number
---@field pSwapchains ffi.cdata*
---@field pImageIndices ffi.cdata*
---@field pResults ffi.cdata*?

---@class vk.ffi.SubmitInfo: vk.ffi.BaseStruct
---@field waitSemaphoreCount number?
---@field pWaitSemaphores ffi.cdata*?
---@field pWaitDstStageMask ffi.cdata*?
---@field commandBufferCount number
---@field pCommandBuffers ffi.cdata*?
---@field signalSemaphoreCount number?
---@field pSignalSemaphores ffi.cdata*?

---@class vk.ffi.PhysicalDeviceProperties: ffi.cdata*
---@field apiVersion number
---@field driverVersion number
---@field vendorID number
---@field deviceID number
---@field deviceType vk.PhysicalDeviceType
---@field deviceName ffi.cdata*
---@field pipelineCacheUUID ffi.cdata*
---@field limits ffi.cdata*
---@field sparseProperties ffi.cdata*
