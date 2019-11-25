# Poisson-Image-Blending
 
This project aims to provide an implementation of an blending algorithm described in paper Poisson Image Editing by P. Perez, M. Gangnet.

The project consists of 5 parts each corresponds to an individual function as depicted in original paper.

* task1 : region smoothing
* task2a : seamless cloning by importing gradient
* task2b : seamless cloning by mixing gradient
* task3  : RGB version for mixing gradient
* task5  : local colour changes


With all of above provided, we can have an nearly seameless image blending effect:

Input

![before](https://github.com/pleaseRedo/Poisson-Image-Blending/blob/master/Poisson%20Image%20Editing/trump.jpg)
![before](https://github.com/pleaseRedo/Poisson-Image-Blending/blob/master/Poisson%20Image%20Editing/lisa.jpg)

Output

![After](https://github.com/pleaseRedo/Poisson-Image-Blending/blob/master/Poisson%20Image%20Editing/results/gradient_mix.jpg)

All intermediate process can be found in *results*
