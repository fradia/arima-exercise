library(fpp)
library(forecast)
#A plot of the time series:

png(filename="mcopper.png")
plot.ts(mcopper)
dev.off()

#Since the data shows variations that change with the time, I apply a BoxCox transformation for different parameters lambda:

png(filename="BoxCox.png")
par(mfrow=c(2,2))
plot(BoxCox(mcopper,0), ylab="BoxCox with lambda=0")
plot(BoxCox(mcopper,0.3), ylab="BoxCox with lambda=0.3")
plot(BoxCox(mcopper,0.6), ylab="BoxCox with lambda=0.6")
plot(BoxCox(mcopper,0.9), ylab="BoxCox with lambda=0.9")
dev.off()

#From the plots I see that a value of lamba close to zero would be more suitable. I verify this using the BoxCox.lambda function

l <- BoxCox.lambda(mcopper)
print(paste('BoxCox parameter:', l))

bc_mcopper <- BoxCox(mcopper,l)

#The series is not stationary (this can be seen also from the Acf(bc_mcopper)) so it needs to be differentiated. 
#There is a clear trend but no clear seasonality so I choose to differenciate once (take the difference of consecutive values)

#plot.ts(diff(bc_mcopper,1))

diff_bc_mcopper <- diff(bc_mcopper,1)

#I want to find a suitable (non-seasonal) ARIMA(p,d,q) model. Since I choose to differentiate once, the parameter d will be
#equal to 1. To choose the appropriate values for p and q, I need to plot the (partial) autocorrelation.

png(filename="Acf_Pacf.png")
par(mfrow=c(2,1))
Acf(diff_bc_mcopper)
Pacf(diff_bc_mcopper)
dev.off()

#The alternating positive and negative spikes of Acf would suggest an autoregressive
#model. There is a significant spike in Pacf at level 2. So I could try 
#with ARIMA(2,1,0)

print(Arima(bc_mcopper, order=c(2,1,0)))

#on the other hand, the auto.arima function gives:

print(auto.arima(bc_mcopper))

#The result suggest that an ARIMA(0,1,1) model might be better (the AICc is lower).
# I check the residuals

arima_mcopper <- auto.arima(bc_mcopper)
png(filename="residuals.png")
par(mfrow=c(2,1))
plot(residuals(arima_mcopper))
Acf(residuals(arima_mcopper))
dev.off()

#From Acf plot I see that there is no correlation between the residuals. Finally the forecast:

fcast <- forecast(arima_mcopper)
png(filename="forecast_arima.png")
plot(fcast)
dev.off()

#This is equivalent to applying a simple exponential smoothing to a transformed series. The forecast is constant.
#Inverting the Box-Cox transformation, I obtain the forecast for the original time series.

print(InvBoxCox(fcast$mean,l))


#Finally I apply ets() to the non-transformed data. In this case the forecast predicts a downward trend

ets <- ets(bc_mcopper)
print(ets)
print(forecast(ets)$mean)
png(filename="forecast_ets.png")
plot(forecast(ets))
dev.off()

