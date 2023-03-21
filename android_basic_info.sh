#!/bin/bash
# 2023-03
# Collecting basic info from Android with adb.
# Requirements: adb, tesseract

TIME=$(date +"%Y.%m.%d_%H.%M.%S")
MANUFACTURER=$(adb shell getprop ro.product.manufacturer)
MODEL=$(adb shell getprop ro.product.model)
OUTFILE=$MANUFACTURER"_"$MODEL
OUTFOLDER=$TIME"_"$OUTFILE
mkdir -p ${OUTFOLDER}
cd ${OUTFOLDER}

clear
echo "Forensic computer date and time:" $(date +"%Y-%m-%d %H:%M:%S.%Z.%z") | tee -a ${OUTFILE}.txt
echo "" | tee -a  ${OUTFILE}.txt
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
echo "Collection data with dumpsys and logcat..."
adb shell dumpsys user > ${OUTFILE}.dumpsys.user.txt
adb shell dumpsys usagestats > ${OUTFILE}.usagestats.txt
adb shell dumpsys wifi > ${OUTFILE}.wifi.txt
adb shell dumpsys batterystats > ${OUTFILE}.batterystats.txt
adb shell dumpsys activity > ${OUTFILE}.dumpsys.activity.txt
adb shell dumpsys appops > ${OUTFILE}.dumpsys.apops.txt
adb shell dumpsys account > ${OUTFILE}.dumpsys.account.txt
adb shell dumpsys dbinfo > ${OUTFILE}.dumpsys.dbinfo.txt
adb shell dumpsys telecom > ${OUTFILE}.dumpsys.telecom.txt
adb shell dumpsys battery > ${OUTFILE}.dumpsys.battery.txt
adb shell dumpsys meminfo -a > ${OUTFILE}.dumpsys.meminfo.txt
adb shell dumpsys procstats --full-details > ${OUTFILE}.dumpsys.procstats.txt
adb shell logcat -S -b all > ${OUTFILE}.logcat.top.txt
adb shell logcat -d -b all V:* > ${OUTFILE}.logcat.txt
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
echo "DEBUG:" ${tess}
${tess} ITF_EVIDENCE_IMEI.png tesseract_imei
echo ""
echo "IMEI info from OCR scan. Compare with image."
cat tesseract_imei.txt | awk 'NF' | tee -a ${OUTFILE}.txt
echo "Done."
exit 0






