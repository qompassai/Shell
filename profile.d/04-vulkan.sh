export VULKAN_SDK=$HOME/.vulkan/1.4.309.0/x86_64
export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
export PATH=$VULKAN_SDK/bin:$PATH
export PKG_CONFIG_PATH=$VULKAN_SDK/lib/pkgconfig:$PKG_CONFIG_PATH
export VK_LAYER_PATH=$HOME/.local/share/vulkan/explicit_layer.d
export VK_LAYER_SETTINGS_PATH=$HOME/.local/share/vulkan/settings.d
