@echo off
set FFMPEG_ROOT=C:\Apps\ffmpeg-2021-07-06-git-758e2da289-full_build

rem path tilde tricks see https://ss64.com/nt/syntax-args.html

if "%~1" == "" goto usage

echo v_workingdir="%~dp0" > parameters.avs
echo v_source="%~f1" >> parameters.avs
echo on

rem smooth video
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i %~dp0\smoothvideo.avs -pix_fmt yuv420p -vcodec libx265 -crf 15 -preset fast "%~d1%~p1%~n1_smooth_no_audio.mkv"

rem merge audio with smoothed video file
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i "%~d1%~p1%~n1_smooth_no_audio.mkv" -i "%~f1" -c:v copy -map 0:v:0 -map 1:a:0 -c:a copy -shortest "%~p1%~n1_smooth.mkv"

goto end

:usage
echo Smooth a video file
echo smoothvideo.bat videofile_with_audio.mp4
echo   videofile_with_audio.mp4: take the audio from this file and the video of it in the resulting video file

:end