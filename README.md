# TikTok video bulk downloader (Bash)

## Dependencies

While this script is writen in Bash, it does require the following dependencies to be installed:
* `curl`
* `jq`
* `xmllint`
* `xmlstarlet`

This cript also require a small lib called `shut` that will be cloned when you will pull this repository.

You'll also need a web browser at hand.

## Instructions

1. Clone this repo and init the submodules with a command like this:
   ```
   git clone --recurse-submodules -j8 https://github.com/wget/tiktok-video-bulk-downloader
   ```
   Note: `-j8` is an optional performance optimization that became available in version 2.8, and fetches up to 8 submodules at a time in parallel ([src.](https://stackoverflow.com/a/4438292))
2. Visit an user page like https://www.tiktok.com/@username with your favourite web browser, scroll down to the end of the page to fetch all the list of the tiktok videos (this can be long if the username is publishing a lot of videos, using the `end` keyboard key can be easier)
3. Save the html page under the filename `tiktok.html` and put it alongside the script file `extractor.sh`
4. Run the script with `./extractor.sh my_tiktok_username`. Non watermarked videos will be downloaded to the `downloads/` folder that will be created alongside this script.

## Limitations

* The API URL may change or TikTok may introduce a new device fingerprinting with encryption in the future. Who knows?
* We experienced some failure to retrieve the JSON file (likely a rate limit by Tiktok WAF system, adding some sleep() or human-like latency can help). If it happens, just rerun the script and it will continue to download the missing ones (curl used with the continue option). Then compare the number of videos returned by this script and the number you have on your computer. It should be good. There is a match between the video ID and the time, meaning a lower number means an older video and a higher number means a more recent video.

## Licence

MIT

Based on the research made by @karim0sec (https://github.com/karim0sec/tiktokdl)
