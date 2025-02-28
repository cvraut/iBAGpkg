% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graper.R
\name{graper}
\alias{graper}
\title{Fit a regression model with graper}
\usage{
graper(
  X,
  y,
  annot,
  factoriseQ = TRUE,
  spikeslab = TRUE,
  intercept = TRUE,
  family = "gaussian",
  standardize = TRUE,
  n_rep = 1,
  max_iter = 3000,
  th = 0.01,
  d_tau = 0.001,
  r_tau = 0.001,
  d_gamma = 0.001,
  r_gamma = 0.001,
  r_pi = 1,
  d_pi = 1,
  calcELB = TRUE,
  verbose = TRUE,
  freqELB = 1,
  nogamma = FALSE,
  init_psi = 1
)
}
\arguments{
\item{X}{design matrix of size n (samples) x p (features)}

\item{y}{response vector of size n}

\item{annot}{factor of length p indicating group membership
of each feature (column) in X}

\item{factoriseQ}{if set to TRUE, the variational
distribution is assumed to fully factorize across
features (faster, default). If FALSE, a
multivariate variational distribution is used.}

\item{spikeslab}{if set to TRUE, a spike and slab prior
on the coefficients (default).}

\item{intercept}{whether to include an intercept into the model}

\item{family}{Likelihood model for the response,
either "gaussian" for linear regression or
"binomial" for logistic regression}

\item{standardize}{whether to standardize the predictors
to unit variance}

\item{n_rep}{number of repetitions with different random
initializations  to be fit}

\item{max_iter}{maximum number of iterations}

\item{th}{convergence threshold for the evidence lower bound (ELB)}

\item{d_tau}{hyper-parameters for prior of tau (noise precision)}

\item{r_tau}{hyper-parameters for prior of tau (noise precision)}

\item{d_gamma}{hyper-parameters for prior of gamma
(coefficients' prior precision)}

\item{r_gamma}{hyper-parameters for prior of gamma
(coefficients' prior precision)}

\item{r_pi}{hyper-parameters for Beta prior of the mixture
probabilities in the spike and slab prior}

\item{d_pi}{hyper-parameters for Beta prior of the mixture
probabilities in the spike and slab prior}

\item{calcELB}{whether to calculate the evidence lower bound (ELB)}

\item{verbose}{whether to print out intermediate messages
during fitting}

\item{freqELB}{frequency at which the evidence lower bound (ELB)
is to be calculated, i.e. each freqELB-th iteration}

\item{nogamma}{if TRUE, the normal prior will have same
variance for all groups (only relevant for spikeslab = TRUE)}

\item{init_psi}{initial value for the spike variables}
}
\value{
A graper object containing
\describe{
\item{EW_beta}{estimated model coefficients in liner/logistic
regression}
\item{EW_s}{estimated posterior-inclusion probabilities
for each feature}
\item{intercept}{estimated intercept term}
\item{annot}{annotation vector of features to the groups as
specified when calling \code{\link{graper}}}
\item{EW_gamma}{estimated penalty factor per group}
\item{EW_pi}{estimated sparsity level per group
(from 1 (dense) to 0 (sparse))}
\item{EW_tau}{estimated noise precision}
\item{sigma2_tildebeta_s1, EW_tildebeta_s1, alpha_gamma,
alpha_tau, beta_tau, Sigma_beta, alpha_pi, beta_pi}{parameters
of the variational distributions of beta, gamma, tau and pi}
\item{ELB}{final value of the evidence lower bound}
\item{ELB_trace}{values of the  evidence lower bound
for all iterations}
\item{Options}{other options used when calling \code{\link{graper}}}
}
}
\description{
Fit a regression model with graper given a matrix
of predictors (\code{X}), a response vector (\code{y}) and
a vector of group memberships for each predictor
in \code{X} (\code{annot}).
For each group a different strength of penalization
is determined adaptively.
}
\details{
The function trains the graper model given
a matrix of predictors (\code{X}), a response vector (\code{y})
and a vector of group memberships for each predictor in \code{X}
(\code{annot}). For each feature group as specified in
\code{annot} a penalty factor and sparsity level is learnt.

By default it uses a Spike-and-Slab prior on the coefficients
and uses a fully factorized variational distribution
in the inference. This provides a fast way to train the model.
Using \code{spikeslab=FALSE} a ridge regression like model can
be fitted using a normal instead of the spike and slab prior.
Setting \code{factoriseQ = FALSE} gives a more exact inference
scheme based on a multivariate variational distribution,
but can be much slower.

As the optimization is non-convex is can be helpful to
use multiple random initializations by setting \code{n_rep}
to a value larger 1. The returned model is then chosen
as the optimal fit with respect to the evidence lower bound (ELB).

Depending on the response vector a linear regression model
(\code{family = "gaussian"}) or a logistic regression model
(\code{family = "binomial"}) is fitted.
Note, that the implementation of logistic regression is still
experimental.
}
\examples{
# create data
dat <- makeExampleData()

# fit a sparse model with spike and slab prior
fit <- graper(dat$X, dat$y, dat$annot)
fit # print fitted object
beta <- coef(fit, include_intercept=FALSE) # model coeffients
pips <- getPIPs(fit) # posterior inclusion probabilities
pf <- fit$EW_gamma # penalty factors per group
sparsities <- fit$EW_pi # sparsity levels per group

# fit a dense model without spike and slab prior
fit <- graper(dat$X, dat$y, dat$annot, spikeslab=FALSE)

# fit a dense model using a multivariate variational distribution
fit <- graper(dat$X, dat$y, dat$annot, factoriseQ=TRUE,
      spikeslab=FALSE)
}
