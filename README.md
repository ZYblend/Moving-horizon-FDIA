# Moving-horizon-FDIA

FDIA generation design aginst L2 estimators (including least-square observer, Luenberger observer, Kalman filter) have been well studied, and motivates model-based and learning-based approaches for attack generation problem.

However, we recently observer the ineffectiveness of those FDIA designs against moving-horizon estimators (MHE). Thus, we are sharing a heuristic moving-hroizon FDIA design framework and algorithm in our paper:
`Moving-horizon False Data Injection Attack Design against Cyber-Physical Systems` (under review).

In the scenario of MHE, we will call "static state estimators" as those estiamtors which are designed with window's size equal to 1 (including those L2 estimators we mention at the beginning).

We share the simulation of MH-FDIA design here: <br>
![image](https://user-images.githubusercontent.com/36635562/167336746-5fd512fc-063f-490e-bee7-f0b780f1d4c5.png)

# Autonomous Vehicle Example
The vehicle model, controller design, and the uncented Kalman filter design can be found in our paper 

