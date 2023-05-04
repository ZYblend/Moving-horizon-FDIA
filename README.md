# Moving-horizon-FDIA

FDIA generation design aginst L2 estimators (including least-square observer, Luenberger observer, Kalman filter) have been well studied, and motivates model-based and learning-based approaches for attack generation problem.

However, we recently observer the ineffectiveness of those FDIA designs against moving-horizon estimators (MHE). Thus, we are sharing a heuristic moving-hroizon FDIA design framework and algorithm in our paper:
```
@article{ZHENG2023105552,
title = {Moving-horizon false data injection attack design against cyber–physical systems},
journal = {Control Engineering Practice},
volume = {136},
pages = {105552},
year = {2023},
issn = {0967-0661},
author = {Yu Zheng and Sridhar Babu Mudhangulla and Olugbenga Moses Anubi},
doi = {https://doi.org/10.1016/j.conengprac.2023.105552}
}
```

In the scenario of MHE, we will call "static state estimators" as those estiamtors which are designed with window's size equal to 1 (including those L2 estimators we mention at the beginning).

We share the simulation of MH-FDIA design here: <br>
![image](https://user-images.githubusercontent.com/36635562/235937437-0a4e7100-5d42-4662-9edb-d83aaa1efd10.png)


In this repo, I am presenting two demos to validate the proposed MH-FDIA:
1. linear control system of IEEE 14-bus system (see branch **demo_14_bus_system**)
<p align="center">
<img src="https://user-images.githubusercontent.com/36635562/235938166-48947ee4-a53f-45cd-9197-c9ef2701ebd3.png" width="500" />
 </p>

2. nonlinear path-tracking control system of differential--driven mobile wheeled robot (see branch **demo_auto_vehicle**, **experiment_auto_vehicle**)
<p align="center">
<img src="https://user-images.githubusercontent.com/36635562/235938124-d9e474ed-8cba-4ff7-9261-fa977180ab17.png" width="500" />
 </p>

