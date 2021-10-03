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

line=`echo $max|awk '{print $NF}'`
echo $lang,$line
rm AMF-Placer -rf

git clone --branch cloc_code https://github.com/zslwyuan/AMF-Placer.git
cd  AMF-Placer

wget https://img.shields.io/badge/$lang-$line-green?style=for-the-badge -O cloc_code.svg

git config --global user.email "push@no-reply.github.com"
git config --global user.name "Cloc Badge Action"
if [ -z "$(git status --porcelain)" ]; then
    echo "Clean!"
else
    git add --all
    git commit -m "Auto Cloc Commit"
    git push origin cloc_code
fi
