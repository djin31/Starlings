# Starlings
This project aims to simulate the Starlings Murmuration and study the effect of varying parameters on the motion.
The model is inspired from the boid model developed by Craig Reynolds. It also attempts to incorporate a few features from the model developed by Hildenbrandt
and Hemelrijk

## Documentation:
Find the documentation for the project in the doc folder

## Running the code:
To run from the source :
```
You need to have Processing3 installed in your system.
Click on any of the .pde files and run by clicking on play button on top left corner in Processing3 Application.
```
Or to run using command line interface
```
processing-java --sketch=src/starlings --run
```

## Interacting with the simulation:
The user is provided with numerous ways to interact with the simulation and observe corresponding changes and results. They are given the options to:  
1. Adjust the various hyper-parameters used for the simulation with the help of sliders.  
2. Add new boids to the simulation on click of a button. New boids are initialised at random locations.  
3. Increase / Decrease the speed of the boids with keyboard up / down arrows.  
4. Observe various real-time measurements like power, angular momentum and acceleration of the boids while changing parameters.

