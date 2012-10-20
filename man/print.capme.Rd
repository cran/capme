\name{print.capme}
\alias{print.capme}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{print a cv.capme object}
\description{
  Print a summary of the capme object.
} \usage{ \method{print}{capme}(x,digits = max(3, getOption("digits")
- 3), ... ) }
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{capme object.}
  \item{digits}{significant digits in printout.}
  \item{...}{additional print options.}
}


\details{
  This call simply outlines the options used for computing a cv.capme object.
}

\value{
  The output above is invisiblly returned.
}

\references{
Cai, T.T., Li, H., Liu, W., and Xie, J. (2012). Covariate
adjusted precision matrix estimation with an application in genetical
genomics. \emph{Biometrika}, to appear.
}

\author{T. Tony Cai,  Hongzhe Li, Weidong Liu and Jichun Xie.\cr
  Maintainer: Jichun Xie \email{jichun@mail.med.upenn.edu} }

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

v <- matrix(rnorm(1000),50,20)
y <- x%*%Gamma0+v%*%Mpower(solve(Omega0),1/2)

capme.obj <- capme(x,y,lambda=0.1, tau=0.1)
capme.obj

## Print the object.
print(capme.obj)
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{models}
\keyword{multivariate}% __ONLY ONE__ keyword per line
