#!/bin/sh
# https://github.com/aaronmlucas/alienvault_backup_to_s3
CURRENTDATETIME=$(date +%Y-%m-%-d-%H:%M:%S);
LOCALDIR='/var/lib/ossim/backup'
S3BUCKET='s3://alienvault-backup/'
LOG=yes
# Sync data
s3cmd sync --recursive --skip-existing --no-delete-removed --no-check-md5 --server-side-encryption --storage-class=STANDARD_IA --region=us-east-1 $LOCALDIR $S3BUCKET;
# raw: s3cmd sync --recursive --skip-existing --no-check-md5 --no-delete-removed --server-side-encryption --storage-class=STANDARD_IA --region=us-east-1 /var/lib/ossim/backup s3://alienvault-backup/
# Logging
if [ "${LOG}" = "yes" ]; then
        TMPFILE=/var/log/s3backupsynclog.txt;
        echo "STARTED: ${CURRENTDATETIME}" > $TMPFILE;
        echo "ENDED  : $(date +%Y-%m-%-d-%H:%M:%S)" >> $TMPFILE;
        echo '' >> $TMPFILE;
        s3cmd du -H $S3BUCKET >> $TMPFILE;
        echo '' >> $TMPFILE;
        rm $TMPFILE;
fi
