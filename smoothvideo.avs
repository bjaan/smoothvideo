Import("parameters.avs")

SetWorkingDir(v_workingdir)
input = FFmpegSource2(source=v_source)

#Convert to YV12 color space when needed - needed by SVPflow
input = input.PixelType == "YV12" ? input : input.PixelType == "RGB24" ? ConvertToYV12(input) : ConvertToYV12(ConvertToRGB24(input))

#Upscale to HD 1080p if lower resolution is provided
h = 1080
w = round(float(input.Width) / float(input.Height) * float(h))
w = w % 2 > 0 ? w + 1 : w
input = input.Height < h ? spline64resize(input, w, h) : input

#current settings: Maximum smoothness for animation
#more information about the parameters https://www.svp-team.com/wiki/Manual:SVPflow

super_params = "{pel:2,scale:{up:2},gpu:1,rc:true}"

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