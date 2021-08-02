# Smoothvideo
Script to *smooth* a video file, of lesser than 60 frames per second, to 60 frames per second. It uses the free SVPflow plugins from the *SmoothVideo Project* over at https://www.svp-team.com/, Avisynth+, and FFMPEG. The script can be easily adjusted for more frames per second.

This script should work on AMD & nVidia GPUs. When you change `GPU:1` to `GPU:0`, even without GPU hardware acceleration.

Works on only Windows!

More information about the SVPflow parameters https://www.svp-team.com/wiki/Manual:SVPflow

# Installation

1. Install FFMPEG from https://ffmpeg.org/download.html.  I extracted the latest `ffmpeg-git-full.7z` archive over at https://www.gyan.dev/ffmpeg/builds/ to `C:\Apps\ffmpeg-2021-07-06-git-758e2da289-full_build`. Folder is different for each day.
2. Install AviSynth+ 64-bit from https://github.com/AviSynth/AviSynthPlus/releases/.  I installed `AviSynthPlus_3.7.0_20210111.exe`.
3. Install AviSynth+ plugins: 
   a. Download *FFMS* https://github.com/FFMS/ffms2/releases  I used `ffms2-2.40-msvc.7z` and copied the three files `ffms2.dll`, `ffms2.lib` and `ffmsindex.exe` in `x64` to `C:\Program Files (x86)\AviSynth+\plugins64`
   b. Download *SVPflow*. The latest version is not recommended as there will be a red border in the resulting video, see https://forum.doom9.org/showthread.php?t=181379. I downloaded first the latest `svpflow-4.3.0.168.zip` from https://www.svp-team.com/get/ and copied two files in `svpflow1_64.dll` and `svpflow2_64.dll` in the `lib-windows\avisynth\x64` folder to the `C:\Program Files (x86)\AviSynth+\plugins64` folder. 
   So instead, I used these instead an older version I found here http://k007.kiwi6.com/hotlink/6k2losau0b/SVPflow_LastGoodVersions.7z (and backed this up in this repository) and copied `svpflow1.dll` and `svpflow2.dll` in `lib-windows\avisynth\x64`
   
   *[rant]
   The latest versions of SVPflow add a CONTRAPRODUCTIVE red border to the resulting file, WHICH I DON'T WANT TO REMOVE, as I am losing extra pixels on each side of the video, because THEY decided to add it as an EFFECT. Their release notes say: "Please note that SVPflow libs require a SVP Manager running (Windows and macOS only), otherwise you'll see a red rectangle around the video frame."  So, as long as I NOT install and keep running THEIR bloatware, THEY decide to ANNOY ME for the rest of my days of using MY computer. What will be added next? A spinning logo of their religion on top of my video, because I MUST LOVE THEIR god?  Or an additional high pitched sound that wakes the neighbour's dogs and make them bark everytime I play a video file - especially during nighttime?  Are these guys insane!?  Extortion! mob practices galore!
   [/rant]*
   
   OK, OK, calm down now. I could have used something else then SVP, but it is not nice find out when your script is finally working that they pulled this trick.  When I like it I could always have bought a license, but now never! Plex doesn't do this type of practices and I bought their great product.
   
4. Download a copy of this reposity, and adjust the first line in `smoothvideo.bat` to match the FFMPEG folder and feel free to update the command line parameters for `ffmpeg.exe`.

# Usage

Run `smoothvideo.bat videofile.mp4`

It will output a temporary smoothed video file - first - without audio, ends with `_output_no_audio.mkv`, and afterwards a third file, ends with `_output.mkv`, which is smoothed and has the original audio.  Note: this only works with video files that have single audio tracks.

# Contents

* `smoothvideo.bat` script to smooth a video file, calls FFMPEG with `smoothvideo.avs` and re-encodes the result, and re-adds the original audio.
 
* `smoothvideo.avs` AviSynth+ script that reads a videofile using the FFMS plug-in and performs the smoothing operation.

* `SVPflow_LastGoodVersions.7z` the last good SVPflow version.

* `plugins64.zip` backup of my `C:\Program Files (x86)\AviSynth+\plugins64` folder. 

# Screenshot

![screenshot](https://raw.githubusercontent.com/bjaan/smoothvideo/master/screenshot.png)
