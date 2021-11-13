# 3-Sigma-Finger-Vein-ROI
In this paper, we propose a robust finger-vein ROI localization method, which is based on the 3-Sigma criterion dynamic threshold strategy. 
The proposed method includes three main steps: First, the Kirsch edge detector is introduced to detect the horizontal-like edges in the 
acquired finger-vein image. Then, the obtained edge gradient image is divided into four parts: upper-left, upper-right, lower-left, and
lower-right. For each part of the image, the three-level dynamic threshold, which is based on the 3-sigma criterion of the normal distribution, 
is imposed to obtain more distinct and complete edge information. Finally, through labeling the longest connected component at the same 
horizontal line, two reliable finger boundaries, which represent the upper and lower boundaries, respectively, are defined, and the ROI is
localized in the region between these two boundaries.

Please add reference below:
@article{FV_ROI,
  title={Robust Finger-vein ROI Localization Based on the 3σ Criterion Dynamic Threshold Strategy},
  author={ Yao, Q.  and  Song, D.  and  Xu, X. },
  journal={Sensors (Basel, Switzerland)},
  volume={20},
  number={14},
}
