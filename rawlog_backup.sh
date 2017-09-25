#!/bin/sh
# https://github.com/aaronmlucas/alienvault_backup_to_s3
CURRENTDATETIME=$(date +%Y-%m-%-d-%H:%M:%S);
STAGEDIR= '/root/raw-log-backup'
S3BUCKET='s3://alienvault-backup/raw-logs/'
LOG=yes
#Compress and Migrate old data
cd /var/ossim/logs
 for Y in *; do
  pushd $Y
    for M in *; do
      pushd ..
        tar zcf $STAGEDIR/alienvault-rawlog-$Y.$M.tar.gz $Y/$M
      popd
    done
  popd
done
# Sync Data to S3
s3cmd sync --recursive --no-delete-removed --server-side-encryption --storage-class=STANDARD_IA --region=us-east-1 ${STAGEDIR}/ $S3BUCKET;
# Logging
if [ "${LOG}" = "yes" ]; then
        TMPFILE=/var/log/s3backupsynclog.txt;
        echo "STARTED: ${CURRENTDATETIME}" > $TMPFILE;
        echo "ENDED  : $(date +%Y-%m-%-d-%H:%M:%S)" >> $TMPFILE;
        echo '' >> $TMPFILE;
        s3cmd du -H $S3BUCKET >> $TMPFILE;
        echo '' >> $TMPFILE;
fi
