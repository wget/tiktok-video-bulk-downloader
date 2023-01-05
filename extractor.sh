#!/usr/bin/env bash

# shellcheck disable=SC1091
. "${0%/*}/shut/utils.sh"

# Specifying the user agent or additional query strings items is not mandatory,
# but useful to be under the radar
API_URL="https://api19-core-useast5.us.tiktokv.com/aweme/v1/feed/?aweme_id=[VIDEO_ID]&version_code=262&app_name=musical_ly&channel=App&device_id=null&os_version=14.4.2&device_platform=iphone&device_type=iPhone9"
USER_AGENT='TikTok 26.2.0 rv:262018 (iPhone; iOS 14.4.2; en_US) Cronet'

function getVideoId() {
    unset retval
    local url="$1"
    explode "/video/" "$url"
    local size=$((${#retval[@]} - 1))
    retval="${retval[$size]}"
}

function getVideoUrl() {
    unset retval
    local videoId="$1"
    apiUrl="${API_URL/\[VIDEO_ID\]/${videoId}}"

    json="$(curl -H 'User-Agent: TikTok 26.2.0 rv:262018 (iPhone; iOS 14.4.2; en_US) Cronet' "$apiUrl" 2>/dev/null)"
    retval="$(echo "$json" | jq .aweme_list[0].video.play_addr.url_list[0] 2>/dev/null)"
}

username="$1"

if [ -z "$username" ]; then
    die "Username not specified as argument. Aborting..."
fi

info "Checking dependencies..."
requireDeps "curl jq xmllint xmlstarlet"

info "Ensuring downloads/ is present..."
mkdir -p downloads

info "Gathering all video page URLs..."
# The html is invalid, we need to clean is with xmllint first otherwise
# xmlstarlet will complain
videos=($(xmllint -html -xmlout tiktok.html 2>/dev/null | xmlstarlet sel -t -v "//a[starts-with(@href,'https://www.tiktok.com/@$username/video')]/@href" -n 2>/dev/null))
totalVideos=${#videos[@]}

if (( $totalVideos == 0 )); then
    die "No video found for $username. Aborting..."
else
    info "$totalVideos videos found for $username."
fi

i=1
for video in "${videos[@]}"; do

    getVideoId "$video"
    videoId="$retval"

    if ! isNumber "$videoId"; then
        error "[$i/$totalVideos] No video id found in $video. Skipping..."
        ((i++))
        continue
    fi

    info "[$i/$totalVideos] Retrieving video URL for video $videoId..."
    getVideoUrl "$videoId"
    videoUrl="$retval"

    # The videoUrl is returned with quotes, remove them
    videoUrl="${videoUrl//\"/}"

    if [ -z "$videoUrl" ]; then
        error "[$i/$totalVideos] No video url found for video $videoId. Skipping..."
        ((i++))
        continue
    fi

    info "[$i/$totalVideos] Downloading $videoId to downloads/$videoId.mp4..."
    curl -H "User-Agent: $USER_AGENT" -LC - "$videoUrl" -o downloads/"${videoId}".mp4

    ((i++))

done
