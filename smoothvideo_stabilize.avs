Import("parameters.avs")

SetWorkingDir(v_workingdir)
input = FFmpegSource2(source=v_source)

#Convert to YV12 color space when needed - needed by SVPflow
input = input.PixelType == "YV12" ? input : input.PixelType == "RGB24" ? ConvertToYV12(input) : ConvertToYV12(ConvertToRGB24(input))

#stablize
input = FilmGateFix(input)

#darken lines
function FastLineDarkenMOD2( clip c, int "strength", int "luma_cap", int "threshold", int "thinning")
{
## parameters ##
str     = string(default(strength, 48) /128.)
lum     = string(default(luma_cap, 191))
thr     = string(default(threshold, 4))
thinning = default(thinning,24)
thn     = string(thinning /16.)
 
## filtering ##
exin    = c.mt_expand().mt_inpand()
diff    = mt_lutxy(c,exin,yexpr="y "+lum+" < y "+lum+" ? x "+thr+" + > x y "+lum+" < y "+lum+" ? - 0 ? 127 +",uexpr="x",vexpr="x",u=2, v=2)
linemask= mt_lut(diff.mt_inpand(),"x 127 - "+thn+" * 255 +").mt_convolution("1 1 1","1 1 1",y=3,u=0,v=0)#".RemoveGrain(20,-1)" gives a little speed boost.
thick   = mt_lutxy(c, exin, yexpr="y "+lum+" < y "+lum+" ? x "+thr+" + > x y "+lum+" < y "+lum+" ? - 0 ? "+str+" * x +",uexpr="x",vexpr="x",u=2, v=2)
thin    = mt_lutxy(c.mt_expand(U=2,V=2),diff,yexpr="x y 127 - "+str+" 1 + * +",u=2, v=2)
 
return (thinning == 0) ? thick : mt_merge(thin,thick,linemask,y=3,u=2,v=2)
}

input = FastLineDarkenMOD2(input)

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