#!/bin/sh
echo "tas5805 trim tool version:v7.0"
echo "Auther:shenh@tcl.com"

caculate_md5sum(){
  md5sum $1 >> $2 		
}

echo "remove old trim file"
rm -rf *.trim*
echo "remove old checksum file"
rm -rf md5sum_*
for file in *.h
do
    echo "prepare temp file"
    cp $file $file.temp

    echo "start to trim tas5805 input mix data"
    sed -n -e '68,89p' $file.temp > $file.trim.input.h
    sed -i -e '2a{ 0x7f, 0x00 },' $file.trim.input.h
    sed -i -e '3s/^/\t/g' $file.trim.input.h
    sed -i -e '5a{ 0x00, 0x00 },' $file.trim.input.h
    sed -i -e '6s/^/\t/g' $file.trim.input.h
    caculate_md5sum $file.trim.input.h md5sum_input.txt
    #add file header comment
    sed -i -e '1i//'$file'' $file.trim.input.h
    sed -i -e '1s/.h$/_input_data/g' $file.trim.input.h

    echo "remove input mix data from temp file"
    sed -i -e '73,89d' $file.temp


    echo "start to trim tas5805 eq data"
    sed -n -e '68,851p' $file.temp > $file.trim.eq.h
    sed -i -e '4,175d' $file.trim.eq.h
    sed -i -e '2a{ 0x7f, 0x00 },' $file.trim.eq.h
    sed -i -e '3s/^/\t/g' $file.trim.eq.h
    sed -i -e '4s/86/84/g' $file.trim.eq.h
    #remove right channel EQ data
    sed -i -e '311,613d' $file.trim.eq.h
    caculate_md5sum $file.trim.eq.h md5sum_eq.txt
    #add file header comment
    sed -i -e '1i//'$file'' $file.trim.eq.h
    sed -i -e '1s/.h$/_eq_data/g' $file.trim.eq.h

    echo "start to trim tas5805 AGL data"
    sed -n -e '68,107p' $file.temp > $file.trim.agl.h
    sed -i -e '2a{ 0x7f, 0x00 },' $file.trim.agl.h
    sed -i -e '3s/^/\t/g' $file.trim.agl.h
    sed -i -e '4s/86/84/g' $file.trim.agl.h
    caculate_md5sum $file.trim.agl.h md5sum_agl.txt
    #add file header comment
    sed -i -e '1i//'$file'' $file.trim.agl.h
    sed -i -e '1s/.h$/_agl_data/g' $file.trim.agl.h

    echo "start to trim tas5805 DRC data"
    sed -n -e '68,1017p' $file.temp > $file.trim.drc.h
    sed -i -e '6,40d' $file.trim.drc.h
    sed -i -e '144,749d' $file.trim.drc.h
    sed -i -e '2a{ 0x7f, 0x00 },' $file.trim.drc.h
    sed -i -e '3s/^/\t/g' $file.trim.drc.h
    caculate_md5sum $file.trim.drc.h md5sum_drc.txt
    #add file header comment
    sed -i -e '1i//'$file'' $file.trim.drc.h
    sed -i -e '1s/.h$/_drc_data/g' $file.trim.drc.h

    echo "remove temp file"
    rm -rf $file.temp

done

