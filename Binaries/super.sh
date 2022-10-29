#program necessary coding do not touch
cd ..
chmod u+x *
chmod u+x ./Binaries/*
SAMPLE=./Sample/MiUi_STAR_21.10.13_by_XD.zip
ZIPNAME="$(ls ./input)"
echo "$SAMPLE"
echo "$ZIPNAME"
SAMPLE_DEST=./Output/$ZIPNAME
mkdir $SAMPLE_DEST
unzip $SAMPLE -d $SAMPLE_DEST
unzip ./Input/*.zip payload.bin
./Binaries/payload -o ./Output/images/ payload.bin
rm payload.bin
OD=$(stat -c %s ./Output/images/odm.img)
echo "ODM=$OD"
PR=$(stat -c %s ./Output/images/product.img)
echo "PRODUCT=$PR"
SY=$(stat -c %s ./Output/images/system.img)
echo "SYSTEM=$SY"
SE=$(stat -c %s ./Output/images/system_ext.img)
echo "SYSTEM_EXT=$SE"
VE=$(stat -c %s ./Output/images/vendor.img)
echo "VENDOR=$VE"
SUM=`expr $OD + $PR + $SY + $SE + $VE`
echo "All=$SUM"
echo "Building super image please wait..."
./Binaries/lpmake --device-size 9126805504 --metadata-size 65536 --metadata-slots 3 --super-name super  --group qti_dynamic_partitions:$SUM --partition system_a:readonly:$SY:qti_dynamic_partitions --partition system_b:readonly:0:qti_dynamic_partitions --partition system_ext_a:readonly:$SE:qti_dynamic_partitions --partition system_ext_b:readonly:0:qti_dynamic_partitions --partition vendor_a:readonly:$VE:qti_dynamic_partitions --partition vendor_b:readonly:0:qti_dynamic_partitions --partition product_a:readonly:$PR:qti_dynamic_partitions --partition product_b:readonly:0:qti_dynamic_partitions --partition odm_a:readonly:$OD:qti_dynamic_partitions --partition odm_b:readonly:0:qti_dynamic_partitions --image system_a=./Output/images/system.img --image system_ext_a=./Output/images/system_ext.img --image vendor_a=./Output/images/vendor.img --image product_a=./Output/images/product.img --image odm_a=./Output/images/odm.img --virtual-ab --sparse --output ./Output/images/super.img
echo "Building Super Image Finished"
rm ./Output/images/odm.img ./Output/images/product.img ./Output/images/system.img ./Output/images/system_ext.img ./Output/images/vendor.img
mv ./output/images/* $SAMPLE_DEST/images/