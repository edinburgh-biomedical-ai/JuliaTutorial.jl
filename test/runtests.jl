using JuliaTutorial
using Test

# to group test together, to oranise serveral tests
# @testset "JuliaTutorial.jl" begin
#     # @test myaddition(1, 1) == 2
# end

sexonthebeach = Cocktail(("vodka", "schnaps", "orange juice", "cranberry juice"))
tipunch = Cocktail(("rhum", "sugar", "lime juice"))

olivierssecret = myaddition(sexonthebeach, tipunch)

@test olivierssecret isa Cocktail