-- DONT USE THIS

SELECT
	ZADDITIONALASSETATTRIBUTES.Z_PK,
	ZADDITIONALASSETATTRIBUTES.ZASSET,
	ZADDITIONALASSETATTRIBUTES.ZIMPORTEDBYBUNDLEIDENTIFIER,
	ZADDITIONALASSETATTRIBUTES.ZEXIFTIMESTAMPSTRING,
	ZADDITIONALASSETATTRIBUTES.ZTIMEZONEOFFSET as 'ZTIMEZONEOFFSET (MIN)',
	ZADDITIONALASSETATTRIBUTES.ZMASTERFINGERPRINT,
	ZADDITIONALASSETATTRIBUTES.ZORIGINALFILENAME,
	ZADDITIONALASSETATTRIBUTES.ZPUBLICGLOBALUUID,
	ZADDITIONALASSETATTRIBUTES.ZTIMEZONENAME,
	ZADDITIONALASSETATTRIBUTES.ZIMPORTEDBYDISPLAYNAME,
	ZADDITIONALASSETATTRIBUTES.ZMEDIAMETADATATYPE,
	ZASSET.ZFILENAME,
	ZASSET.ZDIRECTORY,
	ZASSET.ZLOCATIONDATA,
	DateTime(ZASSET.ZDATECREATED + 978307200, 'UNIXEPOCH') as 'ZDATECREATED (UTC ?)',
	ZASSET.ZDURATION as 'ZDURATION (S)',
	ZASSET.ZCLOUDLOCALSTATE  as 'ZCLOUDLOCALSTATE (Sync iCloud)',
	ZASSET.ZCLOUDASSETGUID,
	ZASSET.ZHIDDEN as 'ZASSET.ZHIDDEN (Album)',
	ZCLOUDMASTERMEDIAMETADATA.ZDATA as 'ZDATA (PLIST)',
	ZMOMENT.ZAPPROXIMATELATITUDE,
	ZMOMENT.ZAPPROXIMATELONGITUDE,
	ZMOMENT.ZTITLE,
	ZMOMENT.ZUUID,
	ZEXTENDEDATTRIBUTES.ZLENSMODEL,
	ZEXTENDEDATTRIBUTES.ZCODEC,
	ZEXTENDEDATTRIBUTES.ZCAMERAMODEL

from ZADDITIONALASSETATTRIBUTES

left JOIN ZASSET ON ZASSET.Z_PK = ZADDITIONALASSETATTRIBUTES.ZASSET
left JOIN ZCLOUDMASTER ON ZCLOUDMASTER.ZCLOUDMASTERGUID = ZADDITIONALASSETATTRIBUTES.ZMASTERFINGERPRINT
left JOIN ZCLOUDMASTERMEDIAMETADATA ON ZCLOUDMASTERMEDIAMETADATA.Z_PK = ZCLOUDMASTER.ZMEDIAMETADATA
left JOIN ZMOMENT on ZMOMENT.ZUUID = ZASSET.ZMOMENT
left JOIN ZEXTENDEDATTRIBUTES on ZEXTENDEDATTRIBUTES.ZASSET = ZASSET.Z_PK

-- FILTER
-- Filename from i.g. /mobile/Media/PhotoData/CPL/storage/filecache/Acv/cplXXXXXXXXXXXXXXXXXXXXX.mp4
--WHERE ZADDITIONALASSETATTRIBUTES.ZMASTERFINGERPRINT = ''
--WHERE ZADDITIONALASSETATTRIBUTES.ZIMPORTEDBYBUNDLEIDENTIFIER = 'com.toyopagroup.picaboo'
--com.toyopagroup.picaboo
--com.apple.springboard
--com.apple.camera.CameraMessageApp

-- Snapchat
-- recorded-123435789765.mp4 probobly recorded with the device.
-- cm-chat-media-video-1_1234567-a123-1a2b-1122-123456ab7cd8_9_0_0.mov probobly recieved via Snapchat (or other app).
-- USERNAME_REDACTED~121212DD-01ED-1234-BC1C-0F6CEA11121E.mov probobly sent from device via Snapchat.
