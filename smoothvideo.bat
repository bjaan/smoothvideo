@echo off
set FFMPEG_ROOT=C:\Apps\ffmpeg-2021-07-06-git-758e2da289-full_build

rem path tilde tricks see https://ss64.com/nt/syntax-args.html

echo v_workingdir="%~dp0" > parameters.avs
echo v_source="%~f1" >> parameters.avs

rem smooth video
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i smoothvideo.avs -vcodec libx265 -crf 28 -preset fast "%~d1%~p1%~n1_output_no_audio.mkv"

rem merge audio with smoothed video file
"%FFMPEG_ROOT%\bin\ffmpeg.exe" -i "%~d1%~p1%~n1_output_no_audio.mkv" -i "%~f1" -c:v copy -map 0:v:0 -map 1:a:0 -c:a copy -shortest "%~p1%~n1_output.mkv"