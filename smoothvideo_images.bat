@echo off
set FFMPEG_ROOT=C:\Apps\ffmpeg-2021-07-06-git-758e2da289-full_build

rem path tilde tricks see https://ss64.com/nt/syntax-args.html

if "%~1" == "" goto usage
if "%~2" == "" goto usage
if "%~3" == "" goto usage
if "%~4" == "" goto usage
if "%~5" == "" goto usage

echo v_workingdir="%~dp0" > %~dp0\parameters.avs
echo v_source="%1" >> %~dp0\parameters.avs
echo v_start=%2 >> %~dp0\parameters.avs
echo v_stop=%3 >> %~dp0\parameters.avs
echo v_fps=%4 >> %~dp0\parameters.avs
echo on

rem smooth video, also writes setoffset.bat for audio offset
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i %~dp0\smoothvideo_images.avs -pix_fmt yuv420p -vcodec libx265 -crf 15 -preset fast "%~d5%~p5%~n5_no_audio.mkv"

if "%~6" == "" goto end

rem call setoffset.bat
call setoffset.bat

rem merge audio with smoothed video file
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i "%~d5%~p5%~n5_no_audio.mkv" -ss %offset% -i "%~f6" -c:v copy -map 0:v:0 -map 1:a:0 -c:a copy -shortest "%~p5%~n5.mkv"

goto end

:usage
echo Smooth a folder of images
echo smoothvideo_images.bat file_pattern start_frame stop_frame frames_per_second_original smooth_videofile.mkv videofile_with_audio_or_audiofile.mkv
echo  file_pattern: e.g. c:\folder\image_%d.png. It uses the ImageSource function of AviSynth+ to read the images: see http://avisynth.nl/index.php/ImageSource for details
echo  start_frame: first frame number e.g. 1: gets replaced with %d in the file pattern
echo  stop_frame: last frame number: gets replaced with %d in the file pattern
echo  frames_per_second_original: number of frames per second before smoothing: e.g. 30
echo  smooth_videofile.mkv : resulting video file
echo  videofile_with_audio_or_audiofile.mp4: optional: take the audio from this file and place it in the resulting video file

:end