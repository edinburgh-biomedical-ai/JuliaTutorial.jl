###############################################################################
# Machine Learning
###############################################################################


###############################################################################
# Introduction

using MLJ, RDatasets


# Let's load some synthetic dataset

iris = RDatasets.dataset("datasets", "iris")

y, X = unpack(iris, ==(:Species), colname -> true)

# 1/ What is the type of X? What is the type of y? X should respect the Tables.jl interface to work with MLJ models.


# Let's see what models are available to fit this dataset

models(matching(X,y))

# MLJ does not define any model but only an interface. 
# This means we need to install and load the different libraries where the models are implemented.
# The following is the MLJ facility to load a model but using `using` or `import` will also work of course.

# Enter the Package manager and run: `add MLJLinearModels NearestNeighborModels MLJFlux MLJDecisionTreeInterface Plots`

RandomForestClassifier= @load RandomForestClassifier pkg=DecisionTree verbosity = 0
NeuralNetworkClassifier = @load NeuralNetworkClassifier pkg=MLJFlux verbosity = 0
LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels verbosity = 0
KNNClassifier = @load KNNClassifier pkg=NearestNeighborModels verbosity = 0

###############################################################################
# Fitting Models

# Let's look at the API with a simple model fit

# A model is simply a container for hyperparmeters describing the procedure
model = LogisticClassifier()
# The machine wraps a procedure with data
mach = machine(model, X, y)
# The estimation part
fit!(mach)
fp = fitted_params(mach)
fp.coefs
fp.intercept

# Investigate the following result
ypred = predict(mach)

# rand(ypred[end]) to sample from the categorical distribution

# Evaluate our fit
# log_loss(ypred, y) # applied element-wise
mean(log_loss(ypred, y))

# A caveat: X should respect the Tables.jl interface

Xmatrix = MLJ.matrix(X)
# This will raise a warning and subsequenti fit potentially fail
mach = machine(RandomForestClassifier(), Xmatrix, y)


# Now for the Stack
library = (rf=RandomForestClassifier(), 
            svr=NeuralNetworkClassifier(), 
            lr=LogisticClassifier(),
            lr1=LogisticClassifier(lambda=10),
            knn=KNNClassifier())

stack = Stack(;metalearner=LogisticClassifier(), 
                resampling=CV(nfolds=30), 
                library...) # dots to tell julia to unpack the various models # if don't want everything printed can add a ;

# TODO: Now fit the stack

super_mach = machine(stack, X, y)
fit!(super_mach)
super_fp = fitted_params(super_mach)
super_fp.metalearner.coefs

super_ypred = predict(super_mach)

###############################################################################
# Model Comparison
# TODO: What does the following code do?
# Use the push!(array, new_element) function to extend the results for each model
# Notice the "!", this isyntax tells you that the first argument will be modified by the function

allmodels = (stack=stack, library...)
results = []
for model in allmodels
    res = evaluate(model, X, y, resampling=Holdout(), measure=log_loss, verbosity=0)
    push!(results,res.measurement[1])
end

results

using Plots
plot([string(x) for x in keys(allmodels)], results, 
        seriestype=:bar, 
        label=:none,
        title="Log Loss")
