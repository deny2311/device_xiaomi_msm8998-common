#
# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Radio
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.fflag.override.settings_network_and_internet_v2=true \
    persist.sys.fflag.override.settings_provider_model=false \

# BPF
PRODUCT_SYSTEM_PROPERTIES += \
    ro.kernel.ebpf.supported=true

# Camera
PRODUCT_SYSTEM_PROPERTIES += \
    vendor.camera.aux.packagelist=com.android.camera,org.lineageos.snap

# RCS
PRODUCT_SYSTEM_PROPERTIES += \
    persist.rcs.supported=1

# RIL
PRODUCT_SYSTEM_PROPERTIES += \
    rild.libpath=/vendor/lib64/libril-qc-hal-qmi.so \
    persist.vendor.radio.atfwd.start=true \
    vendor.service.qti.ims.enabled=1

# Dirac
PRODUCT_SYSTEM_PROPERTIES += \
    audio.dirac.logging=0 \
    ro.audio.soundfx.dirac=true \
    persist.audio.dirac.speaker=true \
    persist.dirac.acs.controller=qem \
    persist.dirac.acs.storeSettings=1 \
    persist.dirac.acs.ignore_error=1

# DPM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.dpm.feature=1 \
    persist.vendor.dpm.nsrm.bkg.evt=3955 \
    persist.vendor.dpmhalservice.enable=1

#Volte
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dbg.ims_volte_enable=1 \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1

# Zygote preforking
PRODUCT_PROPERTY_OVERRIDES += \
    persist.device_config.runtime_native.usap_pool_enabled=true
