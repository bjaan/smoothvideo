# Smoothvideo
Script to *smooth* a video file, of lesser than 60 frames per second, to 60 frames per second. It uses the free SVPflow plugins from the *SmoothVideo Project* over at https://www.svp-team.com/, Avisynth+, and FFMPEG. The script can be easily adjusted for more frames per second.

This script should work on AMD & nVidia GPUs. When you change `GPU:1` to `GPU:0`, even without GPU hardware acceleration.

Works on only Windows!

More information about the SVPflow parameters https://www.svp-team.com/wiki/Manual:SVPflow

# Installation

1. Install FFMPEG from https://ffmpeg.org/download.html.  I extracted the latest `ffmpeg-git-full.7z` archive over at https://www.gyan.dev/ffmpeg/builds/ to `C:\Apps\ffmpeg-2021-07-06-git-758e2da289-full_build`. Folder is different for each day.
2. Install AviSynth+ 64-bit from https://github.com/AviSynth/AviSynthPlus/releases/.  I installed `AviSynthPlus_3.7.0_20210111.exe`.
3. Install the *FFMS* AviSynth+ plugin: download *FFMS* https://github.com/FFMS/ffms2/releases  I used `ffms2-2.40-msvc.7z` and copied the three files `ffms2.dll`, `ffms2.lib` and `ffmsindex.exe` in `x64` to `C:\Program Files (x86)\AviSynth+\plugins64`
4. Install the *SVPflow* AviSynth+ plugin. The latest version is not recommended as there will be a red border in the resulting video, see https://forum.doom9.org/showthread.php?t=181379. I downloaded first the latest `svpflow-4.3.0.168.zip` from https://www.svp-team.com/get/ and copied two files in `svpflow1_64.dll` and `svpflow2_64.dll` in the `lib-windows\avisynth\x64` folder to the `C:\Program Files (x86)\AviSynth+\plugins64` folder. 
   
	So instead, I used these instead an older version I found here http://k007.kiwi6.com/hotlink/6k2losau0b/SVPflow_LastGoodVersions.7z (and backed this up in this repository) and copied `svpflow1.dll` and `svpflow2.dll` in `lib-windows\avisynth\x64` to the `C:\Program Files (x86)\AviSynth+\plugins64` folder. 
   
	[rant] The latest versions of SVPflow add a CONTRAPRODUCTIVE red border to the resulting file, WHICH I DON'T WANT TO REMOVE, as I am losing extra pixels on each side of the video, because THEY decided to add it as an EFFECT. Their release notes say: "Please note that SVPflow libs require a SVP Manager running (Windows and macOS only), otherwise you'll see a red rectangle around the video frame."  So, as long as I NOT install and keep running THEIR bloatware, THEY decide to ANNOY ME for the rest of my days of using MY computer. What will be added next? A spinning logo of their religion on top of my video, because I MUST LOVE THEIR god?  Or an additional high pitched sound that wakes the neighbour's dogs and make them bark everytime I play a video file - especially during nighttime?  Are these guys insane!?  Extortion! mob practices galore!

	OK, OK, calm down now. I could have used something else than SVP-teams' software, but it is not nice find out when your script is finally working that they pulled this trick.  When I like their software, I might have bought a license, but now - after finding out about this - never!!	On the contrary, Plex doesn't do this type of practices and I have bought their great product.
			
	Oh look! An alternative to consider: https://github.com/nihui/rife-ncnn-vulkan [/rant]

5. Download a copy of this reposity, and adjust the second line in `smoothvideo.bat` or `smoothvideo_images.bat` to match the FFMPEG folder and feel free to update the command line parameters for `ffmpeg.exe`.

# Usage

1. Smooth a video file: run `smoothvideo.bat videofile_with_audio.mp4`
* `videofile_with_audio.mp4`: take the audio from this file and the video of it in the resulting video file

2. Smooth a folder of images: run `smoothvideo_images.bat file_pattern start_frame stop_frame smooth_videofile.mkv videofile_with_audio_or_audiofile.mkv`
* `file_pattern`: e.g. `c:\folder\image_%d.png`. It uses the ImageSource function of AviSynth+ to read the images: see http://avisynth.nl/index.php/ImageSource for details
* `start_frame`: first frame number e.g. 1: gets replaced with `%d` in the file pattern
* `stop_frame`: last frame number: gets replaced with `%d` in the file pattern
*  `frames_per_second_original`: number of frames per second before smoothing
*  `smooth_videofile.mkv` : resulting video file
* `videofile_with_audio_or_audiofile.mp4`: optional: take the audio from this file and place it in the resulting video file

It will output a temporary smoothed video file - first - without audio, ends with `_smooth_no_audio.mkv`, and afterwards a second file, ends with `_smooth.mkv`, which is smoothed and has the original audio.  Note: this only works with video files that have single audio tracks.

# Contents

* `smoothvideo.bat` script to smooth a video file, calls FFMPEG with `smoothvideo.avs` and re-encodes the result, and re-adds the original audio.
 
* `smoothvideo.avs` AviSynth+ script that reads a videofile using the FFMS plug-in and performs the smoothing operation.

* `SVPflow_LastGoodVersions.7z` the last good SVPflow version.

* `plugins64.zip` backup of my `C:\Program Files (x86)\AviSynth+\plugins64` folder. 

# Screenshot

![screenshot](https://raw.githubusercontent.com/bjaan/smoothvideo/master/screenshot.png)
