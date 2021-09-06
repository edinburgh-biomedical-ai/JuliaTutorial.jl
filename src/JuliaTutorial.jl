# This is only here to define a namespace
module JuliaTutorial


###############################################################################
# BASICS OF TYPES AND PACKAGES
###############################################################################
# # This is how every packages that you will use work udner the hood.

# # 1/ Use the function typeof() to get the type of anything you like


# # 2/ Investigate the type hierarchy: 

# 1 isa Real
# 1 isa Integer
# Integer <: Real

# # 3/ Multiple dispatch: Define a function to add 2 numbers

# function myaddition(a, b)
#     return a + b 
# end

# myaddition(1, 2)

# function myaddition(a, b::AbstractFloat)
#     return a / b
# end

# myaddition(1, 2.)

# # 4/ Defining a new type and extending our function

struct Cocktail
    ingredients::Tuple
end

# sexonthebeach = Cocktail(("vodka", "schnaps", "orange juice", "cranberry juice"))
# tipunch = Cocktail(("rhum", "sugar", "lime juice"))

# specialised function
function myaddition(a::Cocktail, b::Cocktail)
    return Cocktail((a.ingredients..., b.ingredients...))
end


# olivierssecret = myaddition(sexonthebeach, tipunch)

# olivierssecret isa Cocktail
# # Make your great function `myaddition` available to the public

# c = (1, 1, 2, 5, 6)
# function toto(a, b, args...;d=1)
#     return d
# end

# toto(c...;d=10)

# to make available outside the module (e.g. available to the test function)
export myaddition, Cocktail

# 5/ Bonus: move the methods into `functions.jl` and include the file in this module

# Let's move to the ML part --> `machinelearning.jl`

end

