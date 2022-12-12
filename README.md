# TikTok video bulk downloader (Bash)

## Instructions

1. Visit an user page like https://www.tiktok.com/@username
2. Save the html page under the filename tiktok.html and put it alongside this file
3. Run the script, non watermarked video will be downloaded to the the downloads/ folder alongside this script

## Limitations

* The API URL may change or TikTok may introduce a new device fingerprinting with encryption in the future. Who knows?
* We experienced some failure to retrieve the JSON file (likely a rate limit by Tiktok WAF system, adding some sleep() or human-like latency can help). If it happens, just rerun the script and it will continue to download the missing ones (curl used with the continue option). Then compare the number of videos returned by this script and the number you have on your computer. It should be good. There is a match between the video ID and the time, meaning a lower number means an older video and a higher number means a more recent video.

## Licence

MIT

Based on the research made by @karim0sec (https://github.com/karim0sec/tiktokdl)
