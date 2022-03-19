# ART
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-minidebuginfo=false \
    dalvik.vm.minidebuginfo=false

# IORap: Disable
PRODUCT_PROPERTY_OVERRIDES += \
    ro.iorapd.enable=false

# IORap: Disable iorapd perfetto tracing for app starts
PRODUCT_PROPERTY_OVERRIDES += \
    persist.device_config.runtime_native_boot.iorap_perfetto_enable=false

# IORap: Disable iorapd readahead for app starts
PRODUCT_PROPERTY_OVERRIDES += \
    persist.device_config.runtime_native_boot.iorap_readahead_enable=false
