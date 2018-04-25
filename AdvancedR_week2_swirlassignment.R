######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 2nd week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:

######################################################################################################################
###             SWIRL ASSIGNMENT: Advanced R Programming Functional Programming with purrr
######################################################################################################################

######################################################################################################################
## MAP
######################################################################################################################

#The map family of functions applies a function to the elements of a data structure, usually a list or a vector. The
# function is evaluated once for each element of the vector with the vector element as the first argument to the
# function. The return value is the same kind if data structure (a list or vector) but with every element replaced by
# the result of the function being evaluated with the corresponding element as the argument to the function.

#In the purrr package the map() function returns a list, while the map_lgl(), map_chr(), and map_dbl() functions
# return vectors of logical values, strings, or numbers respectively.

map_chr(c(5,3,4), int_to_string)

#Think about evaluating the int_to_string() function with just one of the arguments in the specified numeric vector,
# and then combining all of those function results into one vector. That's essentially how the map functions work!

#Let's try using a function that has two arguments with a map function. Use map_lgl() to map the function gt() to
# vector c(1, 2, 3, 4, 5) to see which elements of that vector are greater than 3. Make sure to specify the last
# argument of map_lgl() as b = 3.

## Don't use gt(), but instead drop the parentheses.

map_lgl(c(1,2,3,4,5), gt, b=3)

#The map_if() function takes as its arguments a list or vector containing data, a predicate function, and then a
# function to be applied.

#A predicate function is a function that returns TRUE or FALSE for each element in the provided list or vector. In
# the case of map_if(): if the predicate functions evaluates to TRUE, then the function is applied to the
# corresponding vector element, however if the predicate function evaluates to FALSE then the function is not applied.

#Use map_if() to map square() to the even elements of the vector c(1, 2, 3, 4). Use the is_even() function as a
# predicate.

map_if(c(1,2,3,4), is_even, square)

#Take a look at the output - all of the even numbers were squared while the odd numbers were left alone! Notice that
# the map_if() function always returns a list. ##You can use unlist() to unlist the output.

#The map_at() function only applies the provided function to elements of a vector specified by their indexes. Like
# map_if(), map_at() always returns a list. 
#Use the map_at() function to map square() to the first, third, and fourth element of the vector c(4, 6, 2, 3, 8).

map_at(c(4,6,2,3,8), c(1,3,4), square)

#In each of the previous examples we have only been mapping a function over one data structure, however you can map a
# function over two data structures with the map2() family of functions. The first two arguments should be two vectors
# of the same length, followed by a function which will be evaluated with an element of the first vector as the first
# argument and an element of the second vector as the second argument.
#Use map2_chr() to apply the paste() function to the sequence of integers from 1 to 26 and all the letters of the
# alphabet in lowercase.

map2_chr(letters, 1:26, paste)

######################################################################################################################
## REDUCE
######################################################################################################################

#List or vector reduction iteratively combines the first element of a vector with the second element of a vector,
# then that combined result is combined with the third element of the vector, and so on until the end of the vector is
# reached. The function to be applied should take at least two arguments. Where mapping returns a vector or a list,
# reducing should return a single value.
#Reduce the vector c(1, 3, 5, 7) with the function add_talk() using the reduce() function.

reduce(c(1,3,5,7), add_talk)

#On the first iteration x has the value 1 and y has the value 3, then the two values are combined (they<U+2019>re added
# together). On the second iteration x has the value of the result from the first iteration (4) and y has the value of
# the third element in the provided numeric vector (5). This process is repeated for each iteration.
#Reduce the vector c("a", "b", "c", "d") into one string using the paste_talk() function and the reduce() function.

reduce(c("a", "b", "c", "d"), paste_talk)

#By default reduce() starts with the first element of a vector and then the second element and so on. In contrast the
# reduce_right() function starts with the last element of a vector and then proceeds to the second to last element of
# a vector and so on.
#Reduce the vector c("a", "b", "c", "d") into one string using the paste_talk() function and the reduce_right()
# function.

reduce_right(c("a", "b", "c", "d"), paste_talk)

######################################################################################################################
## SEARCH
######################################################################################################################

#You can search for specific elements of a vector using the has_element() and detect() functions. has_element() will
#   return TRUE if a specified element is present in a vector, otherwise it returns FALSE.
#Use the has_element() function to see if the vector random_ints contains the number 45.

has_element(random_ints, 45)

#The detect() function takes a vector and a predicate function as arguments and it returns the first element of the
# vector for which the predicate function returns TRUE. Use detect() and is_even() to find the first element of
# random_ints that is an even number.

detect(random_ints, is_even)

#The detect_index() function takes the same arguments as detect(), however it returns the index of the provided
# vector which contains the first element that satisfies the predicate function. Use detect_index() and is_even() to
# find the index of the first element of random_ints that is an even number.

detect_index(random_ints, is_even)

######################################################################################################################
## FILTER
######################################################################################################################

#The group of functions that includes keep(), discard(), every(), and some() are known as filter functions. Each of
# these functions takes a vector and a predicate function as arguments.

#For keep() only the elements of the vector that satisfy the predicate function are returned while all other elements
# are removed. Use the keep() function with random_ints and is_even() to extract the even elements of random_ints.

keep(random_ints, is_even)

#The discard() function works similarly, it only returns elements that don't satisfy the predicate function. Use
# discard() to filter out the even elements of random_ints.

discard(random_ints, is_even)

#The every() function returns TRUE only if every element in the vector satisfies the predicate function, while the
# some() function returns TRUE if at least one element in the vector satisfies the predicate function. Use every() to
# see if every value of random_ints is less than 100.

every(random_ints, function(x){    ##are all values even?
  x <= 100
})

######################################################################################################################
## OTHER
######################################################################################################################

#Finally let's talk about two functions - partial() and walk().

#Partial application of functions can allow functions to behave a little like data structures. Using the partial()
# function from the purrr package you can specify some of the arguments of a function, and then partial() will return
# a function that only takes the unspecified arguments. Use partial() to create a new function caled gt_10 which
# returns TRUE if its only argument is greater than ten and FALSE otherwise.

gt_10 <- partial(gt, b = 10)
gt_10(11)

#Side effects of functions occur whenever a function interacts with the "outside world" - reading or writing data,
# printing to the console, and displaying a graph are all side effects. The results of side effects are one of the
# main motivations for writing code in the first place! Side effects can be tricky to handle though, since the order
# in which functions with side effects are executed often matters and there are variables that are external to the
# program (the relative location of some data).

#If you want to evaluate a function across a data structure you should use the walk() function from purrr. Use walk()
# across the vector called mark_antony with the message function.

walk(mark_antony, message)
