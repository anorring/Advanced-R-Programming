######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 2nd week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:

######################################################################################################################
###             FUNCTIONAL PROGRAMMING
######################################################################################################################

######################################################################################################################
## WHAT IS FUNCTIONAL PROGRAMMING?

# With functional programming you can also consider the possibility that you can provide a function as an argument to 
#   another function, and a function can return another function as its result.

adder_maker <- function(n){
  function(x){
    n + x
  }
}

add2 <- adder_maker(2)
add3 <- adder_maker(3)

add2(5)
add3(5)

# In the example above the function adder_maker() returns a function with no name. The function returned adds n to its 
#   only argument x.

######################################################################################################################
## MAP

# The map family of functions applies a function to the elements of a data structure, usually a list or a vector. The 
#   function is evaluated once for each element of the vector with the vector element as the first argument to the 
#   function. The return value is the same kind if data structure (a list or vector) but with every element replaced 
#   by the result of the function being evaluated with the corresponding element as the argument to the function. In 
#   the purrr package the map() function returns a list, while the map_lgl(), map_chr(), and map_dbl()functions 
#   return vectors of logical values, strings, or numbers respectively. Let’s take a look at a few examples:

library(purrr)

k <- c(1,2,3,4,5)

#Returns list:
map(k, function(x){
  c("one", "two", "three", "four", "five")[x]
})

#Returns a vector of logical values:
map_lgl(k, function(x){
  x > 3
})

#Returns a vector of strings, note that the output differs:
map_chr(c(5, 4, 3, 2, 1), function(x){
  c("one", "two", "three", "four", "five")[x]
})
map_chr(k, function(x){
  c("one", "two", "three", "four", "five")[x]
})

#Returns a vector of numbers, note that the output differs:
map_dbl(k, function(x){
  c(6,7,8,9,10)[x]
})
map_dbl(c(5, 4, 3, 2, 1), function(x){
  c(6,7,8,9,10)[x]
})

#The map_if() function takes as its arguments a list or vector containing data, a predicate function, and then a 
#   function to be applied. A predicate function is a function that returns TRUE orFALSE for each element in the 
#   provided list or vector. In the case ofmap_if(): if the predicate functions evaluates to TRUE, then the function 
#   is applied to the corresponding vector element, however if the predicate function evaluates to FALSE then the 
#   function is not applied. The map_if() function always returns a list, so I’m piping the result of map_if() to 
#   unlist() so it look prettier:

map_if(1:5, function(x){
  x %% 2 == 0             ## Checks if x is even, i.e. if the remainder from x/2 = 0
},
function(y){              ## Notice how only the even numbers are squared, while the odd numbers are left alone.
  y^2
}) %>% unlist()

# The map_at() function only applies the provided function to elements of a vector specified by their indexes. 
#   map_at() always returns a list so like before I’m piping the result to unlist():

seq(100, 500, 100)

map_at(seq(100, 500, 100), c(1, 3, 5), function(x){
  x - 10
}) %>% unlist()

#Like we expected to happen the providied function is only applied to the first, third, and fifth element of the 
#   vector provided.

#In each of the examples above we have only been mapping a function over one data structure, however you can map a 
#   function over TWO data structures with the map2() family of functions. The first two arguments should be two 
#   vectors of the same length, followed by a function which will be evaluated with an element of the first vector 
#   as the first argument and an element of the second vector as the second argument. For example:

map2_chr(letters, 1:26, paste) ## pairs letters and numbers

#The pmap() family of functions is similar to map2(), however instead of mapping across two vectors or lists, you 
#   can MAP ACROSS ANY NUMBER OF LISTS. The list argument is a list of lists that the function will map over, 
#   followed by the function that will applied:

pmap_chr(list(                 ## Pairs numbers to the two lists of words.
  list(1, 2, 3),
  list("one", "two", "three"),
  list("uno", "dos", "tres")
), paste)

#Mapping is a powerful technique for thinking about how to apply computational operations to your data.

######################################################################################################################
## REDUCE


