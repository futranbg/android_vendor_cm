#!/sbin/sh
#
# Script: /system/addon.d/90-Maxxaudio.sh
# This addon.d script backs up Maxxaudio and deletes stock AudioFX.apk

. /tmp/backuptool.functions

list_files() {
cat << EOF
etc/waves/default.mps
priv-app/AudioFX/AudioFX.apk
vendor/etc/audio_effects.conf
vendor/lib/libMA3-wavesfx-Coretex_A9.so
vendor/lib/libMA3-wavesfx-Qualcomm.so
vendor/lib/libgnustl_shared.so
vendor/lib/soundfx/libmaxxeffect-cembedded.so
vendor/lib/soundfx/libqcbassboost.so
vendor/lib/soundfx/libqcreverb.so
vendor/lib/soundfx/libqcvirt.so
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done

  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
