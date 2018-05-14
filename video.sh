#!/bin/bash


echo Welcome to use You-Play of you-get
echo 欢迎使用you-get干儿子 看剧神器 
echo 如需帮助请执行 ./video.sh help


#arg
case $1 in
    play)
        #default player
        player=$4
        if [ "$player" = "" ]  
        then  
        player=iina     
        fi       
        echo -e "Search Keyword to Play \n bin/playvideo.sh play $2 $3  $5" 

        url=`curl -s  $(curl -s https://helloacm.com/api/urlencode/\?cached\&s\=$2 | cut -d "\"" -f 2 | sed 's/^/http:\/\/so.iqiyi.com\/so\/q_&/g') |   grep -B1   "第$3集" | head -1 | cut -d "\"" -f 2`

        echo  获取地址
        case ${url:7:8}  in
            so.iqiyi)  
                newurl=`curl -s $url | cut -d "'" -f 2`
                echo 这不是奇艺视频,需要用浏览器观看.
                ;;
            www.iqiy)
                newurl=$url
                ;;
            esac 

        echo $newurl
        
        echo 打开播放器 $player
        case $player in
            browser)
                open $newurl    
                ;;
            download)              
                you-get $newurl 
                ;;                 
            *)              
                you-get $newurl -p $player $5
                ;; 
            esac

        ;;


    link-play) 
        echo  -e "Link to Play \n you-get --format=TD_H265 $(url) -p iina"

        you-get --format=TD_H265 $2 -p iina
        ;;

    link-rtmp)
        echo -e "推流Link push to RTMP \n video.sh link-rtmp $(url)" 

        vurl=`you-get $2 --json | jq '.streams.HD.m3u8_url'`
        ffmpeg -re -analyzeduration 8000 -probesize 200000  -i ${vurl//\"/} -bsf:a aac_adtstoasc -c copy -f flv rtmp://localhost:1935/live/movie
        ;;

    help)
        echo -e "video.sh install"
        echo -e "video.sh play 学园奶爸 3 vlc --format=TD_H265"
        echo -e "--format=TD_H265,4k,HD,TD,HD_H265,SD"
        echo -e "video.sh play 学园奶爸 3 browser  #如果这个视频无法播放,可以直接浏览器打开视频"
        echo .
        echo .
        echo .
        echo .
        ;;

    install)
        brew install curl
        brew install jq
        brew install ffmpeg
        brew install you-get
        brew cask install iina        
        echo -e "测试播放"
        ./vide.sh  play 学园奶爸 3 --format=TD_H265
        ;;

esac
