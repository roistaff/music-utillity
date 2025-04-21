query=""
case $1 in
	search)
		case $2 in
			-c)
				title=$(playerctl metadata title)
				artist=$(playerctl metadata artist)
				query=$title
				;;
			-i)
				artist=$(playerctl metadata artist)
				title=$(playerctl metadata title)
				echo "Now playing:${title} | ${artist}"
				query=$(gum input)
				;;
			*)
				query=""
				;;
		esac
		echo "Search with ${query}"
		query=$(echo "${query}" | jq -Rr @uri)
		list=$(curl  -s "https://lrclib.net/api/search?q=${query}" | jq '.[] | {title: .name, artist: .artistName}' | jq -r '"\(.title) | \(.artist)"')
		findquery=$(echo "${list}" | gum choose)
		title=$(echo ${findquery} | cut -d '|' -f 1 | jq -Rr @uri)
		artist=$(echo ${findquery} | cut -d '|' -f 2 | jq -Rr @uri)
		hoge=$(curl -s "https://lrclib.net/api/get?track_name=${title}&artist_name=${artist}" | jq -r '.plainLyrics')
		echo -e "\n"
		echo -e "${hoge}"
		;;
	*)
		echo "need help?"
		;;
esac 
#gum choose 
#gum input |jq -Rr @uri 
