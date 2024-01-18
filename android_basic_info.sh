#!/bin/bash
# 2024-01
# Collecting basic info from Android with adb.
# Requirements: adb, tesseract

TIME=$(date +"%Y.%m.%d_%H.%M.%S")
MANUFACTURER=$(adb shell getprop ro.product.manufacturer)
MODEL=$(adb shell getprop ro.product.model)
MODEL=$(echo ${MODEL// /_})
OUTFILE=$MANUFACTURER"_"$MODEL
OUTFOLDER=$TIME"_"$OUTFILE
mkdir -p ${OUTFOLDER}
cd ${OUTFOLDER}

clear
echo "Forensic computer date and time:" $(date +"%Y-%m-%d %H:%M:%S.%Z.%z") | tee -a ${OUTFILE}.txt
echo "Device times:" $(adb shell uptime) | tee -a ${OUTFILE}.txt
echo "Manufacturer:" $(adb shell getprop ro.product.manufacturer) | tee -a ${OUTFILE}.txt
echo "Model:" $(adb shell getprop ro.product.model) | tee -a  ${OUTFILE}.txt
echo "Product device:" $(adb shell getprop ro.product.device) | tee -a ${OUTFILE}.txt
echo "Product name:" $(adb shell getprop ro.product.name) | tee -a ${OUTFILE}.txt
echo "Product code:" $(adb shell getprop ro.product.code) | tee -a ${OUTFILE}.txt
echo "Airplane mode (0/1, doesnt care about WiFi/BT):" $(adb shell settings get global airplane_mode_on) | tee -a ${OUTFILE}.txt
echo "Serial number:" $(adb shell getprop ro.serialno) | tee -a ${OUTFILE}.txt
echo "Android OS:" $(adb shell getprop ro.build.version.release) | tee -a ${OUTFILE}.txt
echo "Fingerprint:" $(adb shell getprop ro.build.fingerprint) | tee -a ${OUTFILE}.txt
echo "Build date:" $(adb shell getprop ro.build.date) | tee -a ${OUTFILE}.txt
echo "Build ID:" $(adb shell getprop ro.build.id) | tee -a ${OUTFILE}.txt
echo "Bootloader:" $(adb shell getprop ro.boot.bootloader) | tee -a ${OUTFILE}.txt
echo "Security patch:" $(adb shell getprop ro.build.version.security_patch) | tee -a ${OUTFILE}.txt
echo "Chip name:" $(adb shell getprop ro.chipname) | tee -a ${OUTFILE}.txt
echo "IP:" $(adb shell ip address show wlan0) | tee -a ${OUTFILE}.txt
echo "Default dialer:" $(adb shell telecom get-default-dialer) | tee -a ${OUTFILE}.txt
echo "Max phones (IMEIs ??):" $(adb shell telecom get-max-phones) | tee -a ${OUTFILE}.txt
echo "Dual SIM posibility? (dsds=yes):" $(adb shell telecom get-sim-config) | tee -a ${OUTFILE}.txt
echo "Bluetooth Address:" $(adb shell settings get secure bluetooth_address) | tee -a ${OUTFILE}.txt
echo "Bluetooth name:" $(adb shell settings get secure bluetooth_name) | tee -a ${OUTFILE}.txt
echo "Timezone:" $(adb shell getprop persist.sys.timezone) | tee -a ${OUTFILE}.txt
echo "Baseband:" $(adb shell getprop gsm.version.baseband) | tee -a ${OUTFILE}.txt
echo "Country code:" $(adb shell getprop ro.csc.country_code) | tee -a ${OUTFILE}.txt
echo "USB config:" $(adb shell getprop persist.sys.usb.config) | tee -a ${OUTFILE}.txt
echo "Storage size:" $(adb shell getprop storage.mmc.size) | tee -a ${OUTFILE}.txt
echo "Max users:" $(adb shell pm get-max-users) | tee -a ${OUTFILE}.txt
echo "Users:" $(adb shell pm list users) | tee -a ${OUTFILE}.txt
echo "Encryption:" $(adb shell getprop crypto.state) | tee -a ${OUTFILE}.txt
echo "Android ID:" $(adb shell settings get secure android_id) | tee -a ${OUTFILE}.txt
echo ""
echo ""
echo "Collecting settings..."
echo "Global Settings:" $(adb shell settings list global) | tee -a ${OUTFILE}.global.settings.txt
echo "System Settings:" $(adb shell settings list system) | tee -a ${OUTFILE}.system.settings.txt
echo "Secure Settings:" $(adb shell settings list secure) | tee -a ${OUTFILE}.secure.settings.txt
#ABX format, use https://github.com/cclgroupltd/android-bits/tree/main/ccl_abx
echo ""
echo ""
echo "Collecting data with dumpsys and logcat..."
echo "Dumpsys User:" $(adb shell dumpsys user) | tee -a ${OUTFILE}.dumpsys.user.txt
echo "Dumpsys UsageStats:" $(adb shell dumpsys usagestats) | tee -a ${OUTFILE}.usagestats.txt
echo "Dumpsys Wifi:" $(adb shell dumpsys wifi) | tee -a ${OUTFILE}.wifi.txt
echo "Dumpsys Batterystats:" $(adb shell dumpsys batterystats) | tee -a ${OUTFILE}.batterystats.txt
echo "Dumpsys Activity:" $(adb shell dumpsys activity) | tee -a ${OUTFILE}.dumpsys.activity.txt
echo "Dumpsys Appops:" $(adb shell dumpsys appops) | tee -a ${OUTFILE}.dumpsys.appops.txt
echo "Dumpsys Account:" $(adb shell dumpsys account) | tee -a ${OUTFILE}.dumpsys.account.txt
echo "Dumpsys Dbinfo:" $(adb shell dumpsys dbinfo) | tee -a ${OUTFILE}.dumpsys.dbinfo.txt
echo "Dumpsys Telecom:" $(adb shell dumpsys telecom) | tee -a ${OUTFILE}.dumpsys.telecom.txt
echo "Dumpsys Battery:" $(adb shell dumpsys battery) | tee -a ${OUTFILE}.dumpsys.battery.txt
echo "Dumpsys MemInfo:" $(adb shell dumpsys meminfo) | tee -a ${OUTFILE}.dumpsys.meminfo.txt
echo "Dumpsys Procstats:" $(adb shell dumpsys procstats --full-details) | tee -a ${OUTFILE}.dumpsys.procstats.txt
echo "Logcat Top:" $(adb shell logcat -S -b all) | tee -a  ${OUTFILE}.logcat.top.txt
echo "Logcat All:" $(adb shell logcat -d -b all V:*) | tee -a ${OUTFILE}.logcat.txt
echo ""
echo "" 
echo "Trying to retrieve IMEI with keycode. Review the phone display."
sleep 2
adb shell "input keyevent KEYCODE_CALL;sleep 1;input text '*#06#'"
sleep 2
echo ""
echo "Trying to capture the screen. Review folder."
adb shell "screencap -p /storage/self/primary/ITF_EVIDENCE_IMEI.png" #will store data on device!
echo "Downloading screenshot from device..."
adb pull "/storage/self/primary/ITF_EVIDENCE_IMEI.png" .
#adb shell rm "/storage/self/primary/ITF_EVIDENCE_IMEI.png"
echo ""
echo "Result from screenshot OCR scanning:"
tess=$(which tesseract)
#echo "DEBUG:" ${tess}
${tess} ITF_EVIDENCE_IMEI.png tesseract_imei
echo ""
echo "IMEI info from OCR scan. Compare with image."
cat tesseract_imei.txt | awk 'NF' | tee -a ${OUTFILE}.txt
echo "Done."
exit 0






