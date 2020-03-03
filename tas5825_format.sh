#!/bin/sh
#first version for formating TAS5825 amp I2C config file

#backup file
cp $1 $1.back
dos2unix $1

#delete first 50 lines
sed -i -e '1,53d' $1
#delete lines which start with //Re to last lines
sed -i -e '/^\/\/Re/,$d' $1
#delete lines which start with //
sed -i -e '/^\/\//d' $1
#delete first 32 lines
sed -i -e '1,32d' $1
#delete lines whitch start with }
sed -i -e '/^\}/d' $1

#generate script file for mtk tools debug
#get a new file
echo "generate script file for mtk tools debug"
cp $1 $1_mtk.txt
#delete extra blanks
sed -i -e 's/^    //g' $1_mtk.txt
#replace {  with mtk cli start
sed -i -e 's/^{/CLI\(CLI_app.audio.reg_rw 0x9A/g' $1_mtk.txt
#delete middle ','
sed -i -e 's/, / /g' $1_mtk.txt
#delete last ','
sed -i -e 's/ \},/\)/g' $1_mtk.txt
#delete blank lines
sed -i -e '/^$/d' $1_mtk.txt

#generate data format for code programming
echo "generate data format for code programming"
cp $1 $1_code.h
#delete extra blanks
sed -i -e 's/^    //g' $1_code.h
#replace '{' with '{{'
sed -i -e 's/{ /\{\{/g' $1_code.h
#replace '}' with '}}'
sed -i -e 's/\}/\}\}/g' $1_code.h

#restore back file
mv $1.back $1
mkdir format
mv $1_mtk.txt format
mv $1_code.h format
