PRODUCT_BRAND ?= cyanogenmod

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/cm/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/cm/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/cm/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BOOTANIMATION := vendor/cm/prebuilt/common/bootanimation/marsh.zip

ifdef CM_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/cm/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cm/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/cm/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/cm/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# What is FishPond?
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/app/re.codefi.savoca.kcal-1/base.apk:/system/app/re.codefi.savoca.kcal-1/base.apk \
    vendor/cm/prebuilt/common/app/re.codefi.savoca.kcal-1/oat/arm/base.odex:/system/app/re.codefi.savoca.kcal-1/oat/arm/base.odex \
    vendor/cm/prebuilt/common/app/CameraNext/CameraNext.apk:/system/app/CameraNext/CameraNext.apk \
    vendor/cm/prebuilt/common/app/CameraNext/lib/arm/libjni_mosaic_next.so:/system/app/CameraNext/lib/arm/libjni_mosaic_next.so \
    vendor/cm/prebuilt/common/app/CameraNext/lib/arm/libjni_tinyplanet_next.so:/system/app/CameraNext/lib/arm/libjni_tinyplanet_next.so \
    vendor/cm/prebuilt/common/app/ChromeCustomizations/ChromeCustomizations.apk:/system/app/ChromeCustomizations/ChromeCustomizations.apk \
    vendor/cm/prebuilt/common/app/FishPond/FishPond.apk:/system/app/FishPond/FishPond.apk \
    vendor/cm/prebuilt/common/app/GalleryNext/GalleryNext.apk:/system/app/GalleryNext/GalleryNext.apk \
    vendor/cm/prebuilt/common/app/LiveLockScreen/LiveLockScreen.apk:/system/app/LiveLockScreen/LiveLockScreen.apk \
    vendor/cm/prebuilt/common/priv-app/AudioFX/AudioFX.apk:/system/priv-app/AudioFX/AudioFX.apk \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/base.apk:/system/app/org.notphenom.swe.browser-1/base.apk \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/oat/arm/base.odex:/system/app/org.notphenom.swe.browser-1/oat/arm/base.odex \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libc++_shared.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libc++_shared.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libgiga_client.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libgiga_client.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libsta.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libsta.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libswenetxt_plugin.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libswenetxt_plugin.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libicui18n.cr.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libicui18n.cr.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libicuuc.cr.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libicuuc.cr.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libswe.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libswe.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_22_plugin.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_22_plugin.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_23_plugin.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_23_plugin.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_plugin.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libsweadrenoext_plugin.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libswecore.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libswecore.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libsweskia.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libsweskia.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libswev8.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libswev8.so \
    vendor/cm/prebuilt/common/app/org.notphenom.swe.browser-1/lib/arm/libswewebrefiner.so:/system/app/org.notphenom.swe.browser-1/lib/arm/libswewebrefiner.so \
    vendor/cm/prebuilt/common/etc/init.d/91zipalign:/system/etc/init.d/91zipalign \
    vendor/cm/prebuilt/common/etc/init.d/92sqlite:/system/etc/init.d/92sqlite

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Theme engine
include vendor/cm/config/themes_common.mk

# CMSDK
include vendor/cm/config/cmsdk_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    Profiles

# Optional CM packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    CMWallpapers \
    CMFileManager \
    Eleven \
    LockClock \
    CMUpdater \
    CyanogenSetupWizard \
    CMSettingsProvider \
    ExactCalculator \
    LiveLockScreenService \
    WeatherProvider

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

DEVICE_PACKAGE_OVERLAYS += vendor/cm/overlay/common

# Determine whether this build is a Developer version or Release version
ifneq ($(TARGET_BUILD_DEVELOPER),no)
PRODUCT_DEVELOPER_VERSION = DEVELOPER
endif
PRODUCT_VERSION = 1.1
PRODUCT_VERSION_MAINTENANCE = 0-RC0

CM_VERSION := TekOS-$(PRODUCT_VERSION)-$(PRODUCT_DEVELOPER_VERSION)-$(PRODUCT_VERSION_MAINTENANCE)
CM_BUILDTYPE := Official

PRODUCT_PROPERTY_OVERRIDES += \
  ro.tekos.version=$(CM_VERSION) \
  ro.tekos.releasetype=$(CM_BUILDTYPE) \
  ro.modversion=$(CM_VERSION) \
  ro.cmlegal.url=https://cyngn.com/legal/privacy-policy

-include vendor/cm-priv/keys/keys.mk

CM_DISPLAY_VERSION := $(CM_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.display.version=$(CM_DISPLAY_VERSION)

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Oxygen.ogg \
    ro.config.ringtone=Titania.ogg

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.strictmode.disable=true \
    ro.config.nocheckin=1

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
