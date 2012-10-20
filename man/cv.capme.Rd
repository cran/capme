\name{cv.capme} 
\alias{cv.capme}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{k-fold cross validation for capme.}
\description{
  Perform a k-fold cross validation for selecting tau.
}
\usage{ cv.capme(fold = 5, loss = c("likelihood", "tracel2"), x, y, 
                 lambda = NULL,  
                 nlambda = ifelse(is.null(lambda),10,length(lambda)),
                 lambda.max = max(cov(x)*(1-1/nrow(x)))*
                 max(cov(y)*(1-1/nrow(y)))*
                 sqrt(4*log(ncol(x))*log(ncol(y))/n),
                 lambda.min = ifelse(nrow(x)>ncol(x), 1e-6, 1e-4),
                 logspaced.lambda = TRUE,
                 linsolver.Gamma = c("simplex","primaldual"), 
                 ntau = ifelse(is.null(tau),50,length(tau)),
                 tau = NULL,
                 tau.max = 0.8,
                 tau.min = ifelse(nrow(x)>ncol(x), 1e-6, 1e-4),
                 perturb = TRUE,
                 logspaced.tau = TRUE,
                 linsolver.Omega = c("simplex","primaldual")) }
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{loss}{
    loss to be used in cross validation.  Currently, two losses are
    available: "likelihood" and "tracel2".  Default "likelihood". See \code{details}
    for more information.
  }
  \item{fold}{
    number of folds used in cross validation.  Default 5.
  }
  \item{x}{Input the design matrix of size n (observations) times q (variables).
    Each column is a covariate of length n.}
  \item{y}{Input the outcome matrix of size n (observations) times p (variables).
    Each column is an outcome variable of length n.}
  \item{lambda}{Grid of non-negative values for the constraint
    parameter lambda. If missing, nlambda values from lambda.min to
    lambda.max will be generated.}
  \item{nlambda}{Number of values for program generated lambda. Default 100.}
  \item{lambda.max}{Maximum value of program generated lambda.
    The default value is 
    \deqn{\max(\sigma_X)\max(\sigma_Y)\sqrt(4(\log p+\log q)/n)}.}
  \item{lambda.min}{Minimum value of program generated lambda.
    Default 1e-3 (\eqn{n > p}) or 1e-2 (\eqn{n < p}).
  }
  \item{logspaced.lambda}{Whether program generated lambda should be
    log-spaced or linear spaced.  Default TRUE.
  }
  \item{linsolver.Gamma}{Whether simplex (default) or primaldual
  method should be employed. Rule of thumb: primaldual for large q, 
  simplex for small q.}
  \item{tau}{Grid of non-negative values for the constraint
                 parameter tau. If missing, ntau  values from tau.min to
                 tau.max will be generated.}
  \item{ntau}{Number of values for program generated tau. Default 100.}
  \item{tau.max}{Maximum value of program generated tau. Default 0.8.}
  \item{tau.min}{Minimum value of program generated tau. 
    Default 1e-3(\eqn{n > p}) or 1e-2(\eqn{n < p}).
  }
  \item{perturb}{Whether a perturbed Sigma should be used or
    the positive perturbation added if it is numerical. Default FALSE.}
  \item{logspaced.tau}{Whether program generated lambda should be
    log-spaced or linear spaced. Default TRUE.
  }
  \item{linsolver.Omega}{Whether simplex (default) or primaldual method
    should be employed. Rule of thumb: primaldual for large p,
    simplex for small p.}
}

\details{
  Perform a k-fold cross validation  for selecting the tuning parameter
   \code{lambda} in clime.  Two losses are implemented currently:
  \deqn{
    \textrm{likelihood: } Tr[\Sigma \Omega] - \log|\Omega| -
    p,
  }
  and
  \deqn{
    \textrm{tracel2: } Tr[ diag(\Sigma \Omega - I)^2],
  }
  where \eqn{S_n} is the sample covariance matrix of the test data of \eqn{Z=Y-X\hat{\Gamma}} and \eqn{\Omega}
  is the precision matrix estimated using the training data.
}

\value{
  An object with S3 class \code{"cv.capme"}. You can use it as a
  regular R list with the following fields:
  \item{lambdaopt}{the lambda selected by cross validation to minimize the loss over
    the grid values of \code{tau}.}
  \item{tauopt}{the tau selected by cross validation to minimize the loss over
    the grid values of \code{tau}.}
  \item{lambda}{sequence of \code{lambda} used in the program.}
  \item{tau}{sequence of \code{tau} used in the program.}
  \item{loss}{loss used in the program.}
  \item{loss.mean}{average k-fold loss values for each grid value (\code{lambda},\code{tau}).
  }
  \item{loss.sd}{
    standard deviation of k-fold loss values for each grid value (\code{lambda},\code{tau}).
  }
  \item{\code{lpfun.Gamma}}{Linear programming solver used for estimating the regression coefficient.}
  \item{\code{lpfun.Omega}}{Linear programming solver used for estimating the precision matrix.}
}

\references{
Cai, T.T., Li, H., Liu, W., and Xie, J. (2012). Covariate
adjusted precision matrix estimation with an application in genetical
genomics. \emph{Biometrika}, to appear.
}

\author{T. Tony Cai,  Hongzhe Li, Weidong Liu and Jichun Xie.\cr
  Maintainer: Jichun Xie \email{jichun@temple.edu} }

% \note{
% \section{TODO}{More features will be added very soon.}
% }

\examples{
set.seed(922)
x <- matrix(rnorm(1500,sd=0.5),50,30)
Gamma0 <- matrix(rnorm(600),30,20)*matrix(rbinom(600,1,0.2),30,20)

Omega0.tmp <- matrix(rnorm(400),20,20)*matrix(rbinom(400,1,0.1),20,20)
Omega0.tmp <- (Omega0.tmp+t(Omega0.tmp))
diag(Omega0.tmp) <- 1
Omega0 <- make.pd(Omega0.tmp,cond.num=20)

v <- matrix(rnorm(100),20,5)
y <- x%*%Gamma0+v%*%Mpower(solve(Omega0),1/2)

## Choose the best fist stage estimator of the regression 
##   coefficient using cross-validation.
cv.capme.obj <- cv.capme(loss = "likelihood", fold = 5, x = x ,y = y,
    lambda.min = 0.05, lambda.max = 0.4, nlambda = 2,
    tau.min = 0.05, tau.max = 0.4,ntau = 2, linsolver.Gamma = "simplex",
    linsolver.Omega = "simplex")
lambdaopt <- cv.capme.obj$lambdaopt
tauopt <- cv.capme.obj$tauopt

## Resove the m.clime object using the selected tuning parameter.
capme.obj <- capme(x = x, y = y, lambda = lambdaopt, tau = tauopt,
                   linsolver.Gamma = "simplex", linsolver.Omega = "simplex")
capme.obj
}
\keyword{models}
\keyword{multivariate}
