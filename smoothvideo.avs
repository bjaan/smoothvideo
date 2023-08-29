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
#more examples here: https://github.com/Nuihc88/SVPlite

super_params="{pel:1,gpu:1,full:false}"

analyse_params="{block:{w:32,h:32,overlap:0},main:{
search:{distance:-0 ,type:4,satd:false,sort:true,
coarse:{distance:-21,type:2,satd:false,trymany:true,
width:481,bad:{range:0}}},levels:3,penalty:{lambda:3.3,
plevel:1.25,pnew:44,pglobal:104,pzero:240,pnbour:74,prev:-1}}}"

# num:60 means 60 frames per second, because abs(olute) is set to true, with 13nd SVP-shader
smoothfps_params = "{rate:{num:60, abs:true}, algo:13,mask:{area:200},scene:{} }"

threads=10

SetFilterMTMode("SVSuper", MT_SERIALIZED)
SetFilterMTMode("SVAnalyse", MT_SERIALIZED)
SetFilterMTMode("SVSmoothFps", MT_SERIALIZED)

super=SVSuper(input, super_params)
vectors=SVAnalyse(super, analyse_params, src=input)
SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads)