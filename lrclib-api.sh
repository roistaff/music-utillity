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
		echo "${list}" | gum choose
		;;
	*)
		echo "need help?"
		;;
esac 
#gum choose 
#gum input |jq -Rr @uri 
