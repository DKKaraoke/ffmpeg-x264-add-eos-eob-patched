# ffmpeg-x264-add-eos-eob-patched

## Summary

DAM Karaoke machines need End of sequence (EOS) and End of stream (EOB) NAL units in H.264 bitstreams. This Docker image provides FFmpeg with patched x264.

Refer to: https://mailman.videolan.org/pipermail/x264-devel/2021-April/012885.html

## Build

```
docker build . -t ffmpeg_with_eos_eob
```

## Usage

If you want to encode for DAM Karaoke Machines, DO NOT CHANGE encoding parameters.

```
docker run -v $(pwd):$(pwd) -w $(pwd) ffmpeg_with_eos_eob -i SOURCE_PATH -r 30000/1001 -c:v libx264 -bsf:v h264_mp4toannexb -profile:v main -pix_fmt yuv420p -level:v 4.0 -x264-params "fps=30000/1001:force_cfr=1:slices=1:interlaced=tff:bluray_compat=1:bframes=2:opengop=0:keyint=15:keyint_min=15:scenecut=-1:rc=cbr:bitrate=8000:vbv_maxrate=8000:vbv_bufsize=8000:nal_hrd=cbr:eob=1:eos=1" DESTINATION_PATH
```

## List of verified DAM Karaoke machine

- DAM-XG5000[G,R] (LIVE DAM [(GOLD EDITION|RED TUNE)])
- DAM-XG7000[Ⅱ] (LIVE DAM STADIUM [STAGE])
- DAM-XG8000[R] (LIVE DAM Ai[R])

## Authors

- soltia48 (ソルティアよんはち)

## Thanks

- [Niranjan Kumar B](mailto:niranjan@multicorewareinc.com) - Author of original patch

## License

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2023 soltia48 (ソルティアよんはち)
