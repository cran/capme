\name{print.dantzig} 
\alias{print.dantzig}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{print a dantzig object}
\description{
  Print a summary of the dantzig object.
} \usage{ \method{print}{dantzig}(x,digits = max(3, getOption("digits")
- 3), ... ) }
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{dantzig object.}
  \item{digits}{significant digits in printout.}
  \item{...}{additional print options.}
}


\details{
  This call simply outlines the options used for computing a dantzig object.
}

\value{
  The output above is invisiblly returned.
}

\references{
Candes, E. and Tao, T. (2007). The Dantzig selector: Statistical estimation
when p is much larger than n. \emph{The Annals of Statistics},
\bold{35(6)}, 2313-2351.
Cai, T.T., Li, H., Liu, W., and Xie, J. (2012). Covariate
adjusted precision matrix estimation with an application in genetical
genomics. \emph{Biometrika}, to appear.
}

\author{T. Tony Cai,  Hongzhe Li, Weidong Liu and Jichun Xie.\cr
  Maintainer: Jichun Xie \email{jichun@mail.med.upenn.edu} }


\examples{
set.seed(922)
x <- matrix(rnorm(1500,sd=0.5),50,30)
Gamma0 <- matrix(rnorm(600),30,20)*matrix(rbinom(600,1,0.2),30,20)
y <- x%*%Gamma0 + matrix(rnorm(1000),50,20)
dantzig.obj <- dantzig(x,y,lambda=0.1,linsolver="simplex")
print(dantzig.obj)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{models}
\keyword{multivariate}% __ONLY ONE__ keyword per line
