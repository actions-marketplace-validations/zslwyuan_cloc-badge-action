#!/bin/sh -l

set
git clone https://github.com/zslwyuan/AMF-Placer.git
echo "Start to count lines of code..."
echo "using cloc to check ${RUNNER_WORKSPACE}/AMF-Placer/src/lib/HiFPlacer/"
echo "`ll`"
echo "`pwd`"
max=`cloc ./AMF-Placer/src/lib/HiFPlacer/|grep -A 2 code|sed -n '3p'`
if [ `echo $max|awk '{print NF}'` -eq 5 ]; then
    lang=`echo $max|awk '{print $1}'`
else
    lang=`echo $max|awk '{print $1_$2}'`
fi


max=`cloc ./AMF-Placer/src/lib/HiFPlacer/|grep SUM`
line=`echo $max|awk '{print $NF}'`
comment =`echo $max|awk '{print $4}'`
echo $lang,$line
rm AMF-Placer -rf

git clone --branch cloc_code https://github.com/zslwyuan/AMF-Placer.git
cd  AMF-Placer

wget https://img.shields.io/badge/$lang-$line-orange?style=plastic -O cloc_code.svg
wget https://img.shields.io/badge/comment-$comment-orange?style=plastic -O cloc_comment.svg

git config --global user.email "push@no-reply.github.com"
git config --global user.name "zslwyuan"
if [ -z "$(git status --porcelain)" ]; then
    echo "Clean!"
else
    git add --all
    git commit -m "Auto Cloc Commit"
    git push https://zslwyuan:"$1"@github.com/zslwyuan/AMF-Placer.git cloc_code
fi
