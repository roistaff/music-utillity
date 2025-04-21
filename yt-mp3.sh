link=""
case $1 in
	-c)
		link=$(xclip -o -selection c)
		;;
	*)
		link="${1}"
		;;
esac
echo "${link}"
yt-dlp -f bestaudio -x --audio-format  mp3 --add-metada --output "download" "${link}"
wait
id=$(ffmpeg -i download.mp3 2>&1 | grep comment | sed 's/.*comment\s*:\s*\(.*\)/\1/' | grep -oP '=\K.*')
title=$(ffmpeg -i download.mp3 2>&1 | grep title | sed 's/.*title\s*:\s*\(.*\)/\1/')
artist=$(ffmpeg -i download.mp3 2>&1 | grep artist | sed 's/.*artist\s*:\s*\(.*\)/\1/')
name="${artist} - ${title}"
name=$(echo ${name//\//})
echo ${name}
response=$(wget -O /tmp/yt-cover.jpg "https://img.youtube.com/vi/${id}/maxresdefault.jpg" 2>&1)
state=$(echo $response | grep "404 Not Found")
if [ "${state}" = "" ];then
	magick /tmp/yt-cover.jpg -gravity center -crop 720x720+0+0 /tmp/yt-cover.jpg
	wait
else
	response=$(wget -O /tmp/yt-cover.jpg "https://img.youtube.com/vi/${id}/hqdefault.jpg" 2>&1)
	state=$(echo $response | grep "404 Not Found")
	if [ "${state}" = "" ];then
		magick /tmp/yt-cover.jpg -gravity center -crop 270x270+0+0 /tmp/yt-cover.jpg
		wait
	else
		wget -O /tmp/yt-cover.jpg "https://img.youtube.com/vi/${id}/default.jpg"
		magick /tmp/yt-cover.jpg -gravity center -crop 74x74+0+0 /tmp/yt-cover.jpg
		wait
	fi
fi
ffmpeg -i download.mp3  -i /tmp/yt-cover.jpg -map 0:a -map 1:v -c copy -disposition:1 attached_pic -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "${name}.mp3" -y
wait
rm download.mp3
echo "Complete!"
