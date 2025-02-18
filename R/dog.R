#' S4 example via Gemni.
#'
#' @param name Name.
#' @param breed Breed.
#' @return A tibble containing file name <chr> and audio time <dbl> in seconds.
#' @examples
#' # Create a Dog object
#' my_dog <- Dog("Buddy", "Golden Retriever")
#'
#' # Print the dog information
#' print(my_dog)
#' @export

# Define the "Dog" class
setClass("Dog",
         slots = list(name = "character", breed = "character"))

# Create a method for printing dog information
setMethod("print", "Dog",
          function(x) {
            cat("Name:", x@name, "\n") # Note the @ for accessing slots
            cat("Breed:", x@breed, "\n")
          })

# Create a constructor function (good practice with S4)
Dog <- function(name, breed) {
  new("Dog", name = name, breed = breed)
}
#
# # Example of another class inheriting from Dog
# setClass("HuntingDog",
#          slots = list(trainingLevel = "numeric"),
#          contains = "Dog") # Inherits from Dog
#
# # Add a method specific to HuntingDog
# setMethod("print", "HuntingDog",
#           function(x) {
#             callNextMethod() # Calls the print method of the parent class (Dog)
#             cat("Training Level:", x@trainingLevel, "\n")
#           })
#
# HuntingDog <- function(name, breed, trainingLevel) {
#   new("HuntingDog", name = name, breed = breed, trainingLevel = trainingLevel)
# }
#
# my_hunting_dog <- HuntingDog("Hunter", "German Shorthaired Pointer", 5)
#
# print(my_hunting_dog)
#
# # Example of using a generic function and dispatch
#
# # Define a generic function (can be used with different classes)
# setGeneric("dogBark", function(x) standardGeneric("dogBark"))
#
# # Define a method for the Dog class
# setMethod("dogBark", "Dog", function(x) {
#   print("Woof!")
# })
#
# # Define a method for the HuntingDog class (overriding the Dog method)
# setMethod("dogBark", "HuntingDog", function(x) {
#   print("WOOF WOOF! I'm a trained hunting dog!")
# })
#
# dogBark(my_dog)       # Output: Woof!
# dogBark(my_hunting_dog) # Output: WOOF WOOF! I'm a trained hunting dog!
#
# # Example of checking if an object belongs to a class
# is(my_dog, "Dog")          # TRUE
# is(my_hunting_dog, "Dog")  # TRUE (HuntingDog inherits from Dog)
# is(my_dog, "HuntingDog")   # FALSE
# is(my_hunting_dog, "HuntingDog") # TRUE
