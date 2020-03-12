#/bin/sh
#get the working file
echo "splite the $1 file"

#get splite key words
echo "splite key words $2 "

#get max num for splite
num=`grep -c $2 $1`
let num=num+1
echo "splite $1 to $num files"

grep -n $2 $1 | awk -F : '{print $1}' > line.txt
wc -l $1| awk '{print $1}' >> line.txt

i=1
start=1
while read end
do
let end=end-1
sed -n "$start,$end p" $1  >$i.txt
#rm -rf $i.txt
let i=i+1
let start=end+1
done < line.txt
rm -rf line.txt
