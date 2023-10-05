n <- 2000
f <- c(0.01,0.05,0.1,0.2,0.3,0.4,0.5)
x <- matrix(nrow=n,ncol=length(f))
b <- matrix(ncol=1,nrow=length(f),data=1)
beta <- matrix(ncol=2,nrow=length(f))
beta1 <- matrix(ncol=2,nrow=length(f))
beta2 <- matrix(ncol=2,nrow=length(f))
beta3 <- matrix(ncol=2,nrow=length(f))
for( i in 1:length(f) ){
    x[,i]=rbinom(n,2,f[i])
}

f1 <- runif(1000)/2+0.01
x1 <- matrix(nrow=n,ncol=length(f1))
beta.null <- matrix(ncol=2,nrow=length(f1))
beta.null1 <- matrix(ncol=2,nrow=length(f1))
beta.null2 <- matrix(ncol=2,nrow=length(f1))
beta.null3 <- matrix(ncol=2,nrow=length(f1))
for( i in 1:length(f1) ){
    x1[,i]=rbinom(n,2,f1[i])
}


e <- rnorm(n)
a <- rnorm(n)
y <- x %*% b + a + e
fit <- lm( y ~ a )
yy <- fit$residuals / sd(fit$residuals)
yyy <- y/sd(y)

for( i in 1:length(f) ){
    beta[i,] <- summary(lm( y ~ x[,i] + a ))$coefficients[2,1:2]
    beta1[i,] <- summary(lm( yy ~ x[,i] ))$coefficients[2,1:2]
    beta2[i,] <- summary(lm( y ~ x[,i] ))$coefficients[2,1:2]
    beta3[i,] <- summary(lm( yyy ~ x[,i] ))$coefficients[2,1:2]
}
for( i in 1:length(f1) ){
    beta.null[i,] <- summary(lm( y ~ x1[,i] + a ))$coefficients[2,1:2]
    beta.null1[i,] <- summary(lm( yy ~ x1[,i] ))$coefficients[2,1:2]
    beta.null2[i,] <- summary(lm( y ~ x1[,i] ))$coefficients[2,1:2]
    beta.null3[i,] <- summary(lm( yyy ~ x1[,i] ))$coefficients[2,1:2]
}

sqrt(4000*beta[,2]*beta[,2]*f*(1-f))
sqrt(4000*beta1[,2]*beta1[,2]*f*(1-f))

###################################
n1 <- 8000
n2 <- 5000
f1 <- c( 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 )
f2 <- c( 0.3, 0.4, 0.5, 0.01, 0.05, 0.1, 0.2 )

x1 <- matrix(nrow=n1,ncol=length(f1))
x2 <- matrix(nrow=n2,ncol=length(f2))

b <- matrix(ncol=1,nrow=length(f1),data=1)
beta1 <- matrix(ncol=2,nrow=length(f1))
beta2 <- matrix(ncol=2,nrow=length(f2))
beta22 <- matrix(ncol=2,nrow=length(f2))
for( i in 1:length(f1) ){
    x1[,i]=rbinom(n1,2,f1[i])
    x2[,i]=rbinom(n2,2,f2[i])
}

f11 <- runif(1000)/2+0.05
f22 <- runif(1000)/2+0.05
x11 <- matrix(nrow=n1,ncol=length(f11))
x22 <- matrix(nrow=n2,ncol=length(f22))
beta.null1 <- matrix(ncol=2,nrow=length(f11))
beta.null2 <- matrix(ncol=2,nrow=length(f22))
beta.null22 <- matrix(ncol=2,nrow=length(f22))
for( i in 1:length(f11) ){
    x11[,i]=rbinom(n1,2,f11[i])
    x22[,i]=rbinom(n2,2,f22[i])
}


e1 <- rnorm(n1)*3
a1 <- rnorm(n1)*2
y1 <- x1 %*% b + a1 + e1

e2 <- rnorm(n2)*3
a2 <- rnorm(n2)*1
y2 <- x2 %*% b + a2 + e2
fit <- lm( y2 ~ a2 )
yy <- fit$residuals / sd(fit$residuals)

for( i in 1:length(f1) ){
    beta1[i,] <- summary(lm( y1 ~ x1[,i] + a1 ))$coefficients[2,1:2]
    beta2[i,] <- summary(lm( y2 ~ x2[,i] ))$coefficients[2,1:2]
    beta22[i,] <- summary(lm( yy ~ x2[,i] ))$coefficients[2,1:2]
}
for( i in 1:length(f11) ){
    beta.null1[i,] <- summary(lm( y1 ~ x11[,i] + a1 ))$coefficients[2,1:2]
    beta.null2[i,] <- summary(lm( y2 ~ x22[,i] ))$coefficients[2,1:2]
    beta.null22[i,] <- summary(lm( yy ~ x22[,i] ))$coefficients[2,1:2]
}
sd(beta.null1[,1]) / sd(beta.null2[,1])
beta1[,1]/beta22[,1]

sd(fit$residuals)

mean(sqrt(2*n1*beta.null1[,2]*beta.null1[,2]*f11*(1-f11)))
mean(sqrt(2*n2*beta.null2[,2]*beta.null2[,2]*f22*(1-f22)))
mean(sqrt(2*n2*beta.null22[,2]*beta.null22[,2]*f22*(1-f22)))

sd( lm( y1 ~ a1 )$residuals )
sd(y1)
sd(y2)
