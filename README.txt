——————————————————————————————————————————————————————————————— 
GENERAL INFORMATION

Code to implement mixture-of-delta-rules model from:

Wilson, R. C., Nassar, M. R., & Gold, J. I. (2013). A Delta-rule approximation to Bayesian inference in change-point problems. PLoS Computational Biology, 9(7), e1003150

To run the code you will need to edit the file “directories.m” such that the maindir variable matches the path on your machine.  

In addition to run some of the later analyses (Figures 10 and 11) you will need the raw behavioral data.  This can be obtained from the Gold lab by emailing jigold@mail.med.upenn.edu.



——————————————————————————————————————————————————————————————— 
BASIC SIMULATION (FIGURES 1, 2, 5 and 6)

Simple implementations of the model from Figure 6 can be found in:
	main_bernoulliSimulation.m - Bernoulli example
	main_gaussianUMKV.m - Gaussian with unknown mean but known variance
	main_gaussianKMUV.m - Gaussian with known mean but unknown variance

To generate figures 1, 2, 5 and 6 run:
	main_Figure1.m
	main_Figure2.m
	main_Figure5.m
	main_Figure6.m
	* Note that due to different random seeds, the figures you generate will not exactly match the figures in the paper but will be close.


——————————————————————————————————————————————————————————————— 
CONFUSION MATRIX / ANALYSIS OF SIMULATED DATA (FIGURE 10)

Simulating and fitting “fake data” to generate the confusion matrix is a fairly time-heavy process, taking about a day for 300 simulations.  Note that, because the observations in the simulated data are based on the observations used in the experiment, running this code requires the data.  This can be obtained from the Gold lab by emailing jigold@mail.med.upenn.edu.

First simulate fake data using (this part is pretty fast)
	main_simulateFakeData.m

Next fit the fake data using (this can be slow especially with recommended setting of nRepeats = 100)
	main_fitFake.m

Finally generate confusion matrix (fast) 
	main_confusionMatrix.m
	
——————————————————————————————————————————————————————————————— 
MODEL FITTING REAL DATA (FIGURE 11)

Note that running this requires the behavioral data.  This can be obtained from the Gold lab.


First run the model fits.  This saves the fit parameters and BICs the “realfits” directory.  This can take a while (an hour or so) if the number of initial conditions (set by nRepeats variable) is large.
	main_fitReal.m

Next plot the fit results using
	main_plotFit.m




