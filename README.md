# Agent-based modelling of microtubule dynamics

This repository contains Julia scripts to model and test the dynamical instabilty of Microtubules *in silico*.

The model is an Agent Based Model with a two dimensional periodic gridspace. The original scripts can be found at: https://github.com/vh94/microtubule

The original model was further adapted and analyzed. A detailed description of the most important aspects of the model are given in the notebook called "00_Introduction.ipynb" to facilitate its understanding.

## Dependencies :
Julia v1.7 Packages:
```
  Agents v4.5.7
  ColorSchemes v3.16.0
  DataFrames v1.3.1
  DataFramesMeta v0.10.0
  Distributions v0.25.40
  DrWatson v2.8.0
  GLMakie v0.4.7
  InteractiveDynamics v0.18.1
  StatsBase v0.33.14
  Serialization
  Statistics
  ```
## Model functions:
```
01_Agent.jl
02_Initialization.jl
03_AgentStep.jl
04_ModelStep.jl
05_Analysis.jl
```
## Model Analysis:
Model analysis was done in separate notebooks for each parameter and topic. Only one data file was uploaded to this repository ("paramscan_p_depolym_GDP_10ensemble.jls") and used in the "00_Introduction.ipynb" notebook as an example of how the collected data was structured and analyzed.

## Presentation
The power point presentation that was used to present the results created during this internship is included in this repository, as well ("Microtubule_Presentation_BV.pptx").
