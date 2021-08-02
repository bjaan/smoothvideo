Import("parameters.avs")

SetWorkingDir(v_workingdir)
input = FFmpegSource2(source=v_source)

#current settings: Maximum smoothness for animation
#more information about the parameters https://www.svp-team.com/wiki/Manual:SVPflow

super_params = "{gpu:1}"
 
# Small 8x8 blocks with additional refine to 4x4
analyse_params = "{gpu:1, block:{w:8}, refine:[{thsad:1000}] }"

# num:60 means 60 frames per second, because abs(olute) is set to true, with 2nd SVP-shader
smoothfps_params = "{rate:{num:60, abs:true}, algo:2 }"

threads=10

SetFilterMTMode("SVSuper", MT_SERIALIZED)
SetFilterMTMode("SVAnalyse", MT_SERIALIZED)
SetFilterMTMode("SVSmoothFps", MT_SERIALIZED)

super=SVSuper(input, super_params)
vectors=SVAnalyse(super, analyse_params, src=input)
SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads)