library(MASS)
library(Matrix)
clumps <- 100 
k <- 3*clumps
Phi <- diag(6:4)
Phi[upper.tri(Phi)] <- 1:3
Phi[lower.tri(Phi)] <- 1:3
invPhi <- solve(Phi)

Phi1 <- list()
for( l in 1:clumps ){
    Phi1[[l]] <- Phi
}
Phi1 <- bdiag(Phi1)
invPhi1 <- solve(Phi1)

nn <- 30000

x <- mvrnorm(n=nn,mu=rep(1,k),Sigma=Phi1)
x.test <- x[20001:30000,]

M=3
ptr.M <- list()
ptr.M[[1]] <- 1:3
ptr.M[[2]] <- 1:30
ptr.M[[3]] <- 1:300
beta <- cbind( c( rep( c(1,0,0), clumps )),
              c( rep( c(1,0,0), 10 ), rep(0,270) ),
              c( 1, rep(0,k-1) ) )
G <- x%*%beta
herit <- c(0.5,0.5,0.5)
tau <- apply( G, 2, var )
sigma2 <- tau * (1/herit -1)
n <- rep(20000,M)

iter <- 100
r2 <- matrix(ncol=M,nrow=iter)
r2.locus <- matrix(ncol=M,nrow=iter)
r2.complete <- matrix(ncol=M,nrow=iter)
for( i in 1:iter ){
    for( j in 1:M ){
        beta.hat <- vector()
        y <- G[,j] + rnorm(n=nn,sd=sqrt(sigma2[j]))
        y.test <- y[20001:30000]

        for( kk in 1:k ){
            beta.hat[kk] <- summary(lm(y~x[,kk],subset=1:n[j]))$coefficients[2,1]
        }

        beta.tilde1 <- invPhi1 %*% t(t(beta.hat*diag(Phi1)))
        pred <- x.test %*% beta.tilde1
        r2.complete[i,j] <- 1-sd(pred-y.test)/sd(y.test)

        beta.tilde <- matrix(ncol=1,nrow=k)
        for( l in 1:clumps ){
            ptr <- 1:3 + (l-1)*3
            beta.tilde[ptr,1] <- invPhi %*% t(t(beta.hat[ptr]*diag(Phi)))
        }
        pred <- x.test[,ptr.M[[j]]] %*% beta.tilde[ptr.M[[j]],]
        r2.locus[i,j] <- 1-sd(pred-y.test)/sd(y.test)

        beta.complete <- summary(lm(y~x[,ptr.M[[j]]],subset=1:n[j]))$coefficients[-1,1]
        pred <- x.test[,ptr.M[[j]]] %*% beta.complete
        r2[i,j] <- 1-sd((pred-y.test))/sd(y.test)
    }
}
print(apply(r2,2,mean))
print(apply(r2,2,mean)/herit)
print(apply(r2.locus,2,mean))
print(apply(r2.locus,2,mean)/herit)
#print(apply(r2.complete,2,mean))
#print(apply(r2.complete,2,mean)/herit)

