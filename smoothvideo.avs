Import("parameters.avs")

SetWorkingDir(v_workingdir)
input = FFmpegSource2(source=v_source)

#more information about the parameters https://www.svp-team.com/wiki/Manual:SVPflow

super_params = "{gpu:1}"

analyse_params = "{gpu:1}"

#num:60 means 60 frames per second, because abs(olute) is set to true
smoothfps_params = "{rate:{num:60, abs:true}}"

threads=10

SetFilterMTMode("SVSuper", MT_SERIALIZED)
SetFilterMTMode("SVAnalyse", MT_SERIALIZED)
SetFilterMTMode("SVSmoothFps", MT_SERIALIZED)

super=SVSuper(input, super_params)
vectors=SVAnalyse(super, analyse_params, src=input)
SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads)