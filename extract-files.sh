#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in

    vendor/lib/hw/activity_recognition.msm8998.so | vendor/lib64/hw/activity_recognition.msm8998.so)
        sed -i "s|activity_recognition.msm8937.so|activity_recognition.msm8998.so|g" "${2}"
        ;;

    vendor/lib64/hw/keystore.msm8998.so)
        sed -i "s|keystore.msm8937.so|keystore.msm8998.so|g" "${2}"
        ;;

    vendor/lib64/hw/gatekeeper.msm8998.so)
        sed -i "s|gatekeeper.msm8937.so|gatekeeper.msm8998.so|g" "${2}"
        ;;

    vendor/lib/hw/sound_trigger.primary.msm8998.so)
        sed -i "s|sound_trigger.primary.msm8937.so|sound_trigger.primary.msm8998.so|g" "${2}"
        ;;

    system_ext/etc/permissions/audiosphere.xml)
        sed -i 's|/system/framework/audiosphere.jar|/system_ext/framework/audiosphere.jar|g' "${2}"
        ;;

    system_ext/lib64/lib-imsvideocodec.so)
        for LIBDPM_SHIM in $(grep -L "libshim_imsvt.so" "${2}"); do
            "${PATCHELF}" --add-needed "libshim_imsvt.so" "$LIBDPM_SHIM"
        done
        ;;

    vendor/lib/hw/camera.msm8998.so)
        "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
        "${PATCHELF}" --replace-needed "libminikin.so" "libminikin-v28.so" "${2}"
        ;;

    vendor/lib/libFaceGrade.so)
        "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
        ;;

    vendor/lib/libMiCameraHal.so)
        "${PATCHELF}" --replace-needed "libicuuc.so" "libicuuc-v28.so" "${2}"
        "${PATCHELF}" --replace-needed "libminikin.so" "libminikin-v28.so" "${2}"
        ;;

    vendor/lib/libarcsoft_beauty_shot.so)
        "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
        ;;

    vendor/lib/libicuuc-v28.so)
        "${PATCHELF}" --set-soname "libicuuc-v28.so" "${2}"
        ;;

    vendor/lib/libminikin-v28.so)
        "${PATCHELF}" --set-soname "libminikin-v28.so" "${2}"
        "${PATCHELF}" --replace-needed "libicuuc.so" "libicuuc-v28.so" "${2}"
        ;;

    vendor/lib/libmmcamera2_sensor_modules.so)
        sed -i 's|/data/misc/camera/camera_lsc_caldata.txt|/data/vendor/camera/camera_lsc_calib.txt|g' "${2}"
        ;;

    vendor/lib/libmmcamera2_stats_modules.so)
        "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
        ;;

    vendor/lib/libmpbase.so)
        "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
        ;;

    esac
}

if [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/../${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

"${MY_DIR}/setup-makefiles.sh"
