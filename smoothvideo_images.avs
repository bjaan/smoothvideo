Import("parameters.avs")

SetWorkingDir(v_workingdir)

input = ImageSource(file=v_source, start=v_start, end=v_stop, fps=v_fps)

#write batch file that sets the offset for audio
offset = "set offset="+String(v_start / v_fps)
WriteFileStart(input, "setoffset.bat", "offset")

#Convert to YV12 color space - needed by SVPflow
input = input.PixelType == "YV12" ? input : input.PixelType == "RGB24" ? ConvertToYV12(input) : ConvertToYV12(ConvertToRGB24(input))

#current settings: Maximum smoothness for animation
#more information about the parameters https://www.svp-team.com/wiki/Manual:SVPflow

super_params = "{scale:{up:0},gpu:1,rc:true}"

analyse_params = "{main:{search:{coarse:{distance:-8,bad:{sad:2000,range:24}},type:2}},refine:[{thsad:250}]}"

# num:60 means 60 frames per second, because abs(olute) is set to true, with 13nd SVP-shader
smoothfps_params = "{rate:{num:60, abs:true}, algo:13,mask:{area:200},scene:{} }"

threads=10

SetFilterMTMode("SVSuper", MT_SERIALIZED)
SetFilterMTMode("SVAnalyse", MT_SERIALIZED)
SetFilterMTMode("SVSmoothFps", MT_SERIALIZED)

super=SVSuper(input, super_params)
vectors=SVAnalyse(super, analyse_params, src=input)
SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads)