#!/bin/bash
# 2023-03-20
# Collecting basic info from Android with adb.
# Requirements: adb, tesseract

NOW=$(date +"%Y-%m-%d_%H-%M-%S")
MANUFACTURER=$(adb shell getprop ro.product.manufacturer)
MODEL=$(adb shell getprop ro.product.model)
SAVEPATH=$NOW"_"$MANUFACTURER"_"$MODEL
mkdir -p ${SAVEPATH}
cd ${SAVEPATH}
clear
echo "Forensic computer date and time:" $(date +"%Y-%m-%d_%H-%M-%S-%Z-%z") | tee -a ${SAVEPATH}.txt
echo "" | tee -a  ${SAVEPATH}.txt
echo "Device times:" $(adb shell uptime) | tee -a ${SAVEPATH}.txt
echo "Manufacturer:" $(adb shell getprop ro.product.manufacturer) | tee -a ${SAVEPATH}.txt
echo "Model:" $(adb shell getprop ro.product.model) | tee -a  ${SAVEPATH}.txt
echo "Product device:" $(adb shell getprop ro.product.device) | tee -a ${SAVEPATH}.txt
echo "Product name:" $(adb shell getprop ro.product.name) | tee -a ${SAVEPATH}.txt
echo "Product code:" $(adb shell getprop ro.product.code) | tee -a ${SAVEPATH}.txt
echo "Airplane mode (0/1, doesnt care about WiFi/BT):" $(adb shell settings get global airplane_mode_on) | tee -a ${SAVEPATH}.txt
echo "Serial number:" $(adb shell getprop ro.serialno) | tee -a ${SAVEPATH}.txt
echo "Android OS:" $(adb shell getprop ro.build.version.release) | tee -a ${SAVEPATH}.txt
echo "Fingerprint:" $(adb shell getprop ro.build.fingerprint) | tee -a ${SAVEPATH}.txt
echo "Build date:" $(adb shell getprop ro.build.date) | tee -a ${SAVEPATH}.txt
echo "Build ID:" $(adb shell getprop ro.build.id) | tee -a ${SAVEPATH}.txt
echo "Bootloader:" $(adb shell getprop ro.boot.bootloader) | tee -a ${SAVEPATH}.txt
echo "Security patch:" $(adb shell getprop ro.build.version.security_patch) | tee -a ${SAVEPATH}.txt
echo "Chip name:" $(adb shell getprop ro.chipname) | tee -a ${SAVEPATH}.txt
echo "IP:" $(adb shell ip address show wlan0) | tee -a ${SAVEPATH}.txt
echo "Default dialer:" $(adb shell telecom get-default-dialer) | tee -a ${SAVEPATH}.txt
echo "Max phones (IMEIs ??):" $(adb shell telecom get-max-phones) | tee -a ${SAVEPATH}.txt
echo "Dual SIM posibility? (dsds=yes):" $(adb shell telecom get-sim-config) | tee -a ${SAVEPATH}.txt
echo "Bluetooth Address:" $(adb shell settings get secure bluetooth_address) | tee -a ${SAVEPATH}.txt
echo "Bluetooth name:" $(adb shell settings get secure bluetooth_name) | tee -a ${SAVEPATH}.txt
echo "Timezone:" $(adb shell getprop persist.sys.timezone) | tee -a ${SAVEPATH}.txt
echo "Baseband:" $(adb shell getprop gsm.version.baseband) | tee -a ${SAVEPATH}.txt
echo "Country code:" $(adb shell getprop ro.csc.country_code) | tee -a ${SAVEPATH}.txt
echo "USB config:" $(adb shell getprop persist.sys.usb.config) | tee -a ${SAVEPATH}.txt
echo "Storage size:" $(adb shell getprop storage.mmc.size) | tee -a ${SAVEPATH}.txt
echo "Max users:" $(adb shell pm get-max-users) | tee -a ${SAVEPATH}.txt
echo "Users:" $(adb shell pm list users) | tee -a ${SAVEPATH}.txt
echo "Encryption:" $(adb shell getprop crypto.state) | tee -a ${SAVEPATH}.txt
echo "Android ID:" $(adb shell settings get secure android_id) | tee -a ${SAVEPATH}.txt
echo ""
echo "Above data saved to file ${SAVEPATH}.txt"
echo ""
echo "Trying to retrieve IMEI with keycode. Review the phones display."
adb shell "input keyevent KEYCODE_CALL;sleep 1;input text '*#06#'"
sleep 2
echo ""
echo "Trying to capture the screen. Review folder."
adb shell "screencap -p /storage/self/primary/ITF_EVIDENCE_IMEI.png" #will store data on device!
echo "Downloading screenshot from device..."
adb pull "/storage/self/primary/ITF_EVIDENCE_IMEI.png" .
#adb shell rm "/storage/self/primary/ITF_EVIDENCE_IMEI.png"
echo ""
echo "OCR scanning of the screenshot..."
tesseract=$(which tesseract)
tesseract ITF_EVIDENCE_IMEI.png tesseract_imei
echo ""
echo "IMEI info from OCR scan:"
cat tesseract_imei.txt | awk 'NF' | tee -a ${SAVEPATH}.txt
echo ""
echo "Done."
exit 0
