#!/bin/sh
# Export md5 hashes from NIST RDS hash dbs.
# 2023-09-12

hashdb=$1
outfile=${hashdb}_md5.txt

if [ -z "$hashdb" ] || [ ! -f "$hashdb" ]
then
	echo "Bad input db".
	exit
fi

if ! command -v sqlite3 ${hashdb}  &> /dev/null
then
    echo "sqlite3 not in path."
    exit
fi

#cp ${hashdb} ./backup.db

sqlite3 ${hashdb} <<EOF
DROP TABLE IF EXISTS EXPORT;
CREATE TABLE EXPORT AS SELECT md5 FROM FILE;
.mode csv
.mode csv
.headers off
.output output.txt
SELECT md5 FROM EXPORT ORDER BY md5;
.q
EOF

echo "MD5" > ${outfile}
cat output.txt >> ${outfile}
head -n 2 ${outfile}
tail -n 2 ${outfile}
wc -l ${outfile}
rm output.txt
