# arima-exercise

This repository contains a solution to Exercise 8.11.9 from the book "Forecasting: principles and practice" by Rob j. Hyndman and George Athanasopoulos: https://www.otexts.org/fpp/8/11

The exercise asks to consider a time series for the data set "mcopper" and to construct an appropriate ARIMA-model for forecasting. The data sets mcopper contains monthly data of copper price from 1960 until 2006 and can be found in the package "fpp".

First of all, the data is transformed with a Box Cox transformation for a suitable parameter lambda.Two possible ARIMA models are considered (one of them suggested by the auto.arima() function). Finally, a forecast with the fitted model is produced and compared with the one provided by the ets() function without transformation.

The models used follow the theory explained in the book: https://www.otexts.org/fpp (In particular, see Chapter 8).
