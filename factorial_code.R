######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: May 2018 						                                                                                     ###
### Content: This script contains the R code for the final assignment of Advanced R programming course             ###
######################################################################################################################

# Access all the needed libraries:
library(dplyr)
library(purrr)
library(ggplot2)
library(microbenchmark)

######################################################################################################################
### PART 1: FACTORIAL FUNCTION
######################################################################################################################

######################################################################################################################
# MY FOUR DIFFERENT VERSIONS OF THE FACTORIAL FUNCTION:

#   1. Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)

factorial_loop <- function(n) {     ## My function takes one input, n  
  stopifnot(n >= 0)                 ## It requires n to be non-negative
  if (n == 0){                      ## If n equals 0, function returns 1, which is defined as the factorial of 0
    f <- 1                        
  } else {                          ## Otherwise the function...
    f <- 1                          ## ... sets f equal to one
    for(i in 1:n) {                 ## ... performs a for loop that iterates over the sequence 1 to n
      f <- f*i                      ## ... and sets f equal to f (from the previous iteration) times the iterated value
    } 
    f
  } 
}

# Check that the function works (note that here, in order to see the value of f we need to print it):
factorial(0)
factorial_loop(0) %>% print()
factorial(8)
factorial_loop(8) %>% print()

#   2. Factorial_reduce: a version that computes the factorial using the reduce() function in the purrr package. 

# The function reduce() from purrr iteratively combines the first element of a vector with the second element of a
#   vector, then that combined result is combined with the third element of the vector, and so on until the end of
#   the vector is reached. The function to be applied should take at least two arguments. Reducing returns a 
#   single value.

factorial_reduce <- function(n) {   ## My function takes one input, n  
  stopifnot(n >= 0)                 ## It requires n to be non-negative
  if (n == 0){                      ## If n equals 0, function returns 1, which is defined as the factorial of 0
    f <- 1  
    print(f)                        ## Prints the value of f (reduce prints by default)
  } else {                          ## Otherwise the function...
    reduce(c(1:n), function(x, y) { ## ... uses reduce to iteratively combine the elements of 1:n ...
      f <- x * y                    ## ... by applying function(x,y) = x*y to the elements and setting that value
    })                              ##      equal to f
  }
}

# Check that the function works:
factorial(0)
factorial_reduce(0)
factorial(8)
factorial_reduce(8)

#   3. Factorial_func: a version that uses recursion to compute the factorial.

# Solving factorial recursively means that we build on the previous iteration of the problem until the initial 
#   condition is met. 

factorial_func <- function(n) {     ## My function takes one input, n
  stopifnot(n >= 0)                 ## It requires n to be non-negative
  if (n == 0){                      ## If n equals 0, function returns 1, which is defined as the factorial of 0
    f <- 1  
  } else {                          ## Otherwise the function...
    n * factorial_func(n-1)         ## ... multiplies by n the previous iteration of the problem and returns the result
  } 
}

# Check that the function works:
factorial(0)
factorial_func(0)
factorial(8)
factorial_func(8)

#   4. Factorial_mem: a version that uses memoization to compute the factorial.

# Memoization works a bit like the recursive method, but it instead stores the results by using extra memory space. 
#   This means that there will be no duplicate computation as there is in the recursive method. Memoization stores
#   each calculated value in a table so that once a number is calculated the function can look it up instead of 
#   needing to recalculate it.

fac_tbl <- c (1, rep(NA, 24))             ## Creates a simple table or a vector with 1 as a first element and then 
##    24 NAs
factorial_mem <- function(n) {            ## My function takes one input, n 
  stopifnot(n >= 0)                       ## It requires n to be non-negative
  if (n == 0){                            ## If n equals 0, function returns 1, which is defined as the factorial of 0
    1
  } else {                                ## Otherwise the function...
    if(!is.na(fac_tbl[n])){               ## ... first checks whether the factorial of n is in fac_tbl-table
      fac_tbl[n]                          ## ... and returns it if it is
    } else {                              ## Otherwise the function...
      fac_tbl[n-1] <<- factorial_mem(n-1) ## ... recursively calculates and stores the factorial of n 
      n * fac_tbl[n-1]                    ##      into the fac_tbl-table (Note that you need to use the complex
    }                                     ##      assignment operator <<- in order to modify the table outside the
  }                                       ##      the scope of the function)
}

# Check that the function works:
factorial(0)
factorial_mem(0)
factorial(8)
factorial_mem(8)

######################################################################################################################
# EVALUATION USING THE MICROBENCHMARK:

#The microbenchmark package can be used to compare functions that take the same inputs and produce the same outputs in 
#   order to find which version of the function is the most efficient to run in terms of time consumed. The 
#   microbenchmark function from this package will run code multiple times (100 times is the default) and provide 
#   summary statistics describing how long the code took to run across those iterations.

#Now we want to write a function that evaluates my four different factorial functions and prints out the summary 
#   statistics once it is given a value for input n:

evaluate_perf <- function(n){
  factorial_perf <- microbenchmark(factorial_loop(n), 
                                   factorial_reduce(n),
                                   factorial_func(n),
                                   factorial_mem(n))
  factorial_perf
}

#Let's first compare the functions' performance using a small n. The first row of code below prints the summary 
#   statistics of the comparison and the second row draws an autoplot of the results which allow for comparing the 
#   results with a quick glance.

evaluate_perf(2) 
autoplot.microbenchmark(evaluate_perf(2))

#From the means of the amount of time in microseconds used to compute the factorials, we can see that the 
#   factorial_mem and factorial_loop are significantly faster than the other methods. The factorial_func, i.e. the 
#   recursive method is more than twice as slow, while factorial_reduce use about six times more time. 

#The results change quite interestingly when we use a bigger value for n:

evaluate_perf(5) 
autoplot.microbenchmark(evaluate_perf(5))

#The functions using loop and memoization remain the fastest and the function using reduce the slowest, but the amount 
#   of time the recursive function factorial_func uses is doubled from the case of n=2. The time taken by the others 
#   increases only marginally.

#Let's double the size of n:

evaluate_perf(10) 
autoplot.microbenchmark(evaluate_perf(10))

#Now the mean time taken by factorial_mem about doubles but factorial_loop hardly changes. Factorial_loop is this the 
#   fastest method by a large margin as n grows. The time taken by factorial_reduce is also about double the before, 
#   but the time taken by factorial_func is almost four times what it was when n=5. 

#Let's try an even larger value for n:

evaluate_perf(20) 
autoplot.microbenchmark(evaluate_perf(20))

#Now it seems that we have hit the limits of my computer as we run into overflow warnings. Let's find the maximum number
#   of n my computer can handle by trying out different values. Let's start with the average between 10 and 20:

evaluate_perf(15)   #overflow warnings -> try the average between 10 and 15
evaluate_perf(13)   #overflow warnings -> try the average between 10 and 13
evaluate_perf(12)   #no warnings

#That is, my computer can compute the microbenchmark function for up to n=12. Let's write a loop that prints out the 
#   evaluation statistics for the range of inputs from 1 to 12. For the loop to print out the summary statistics of each
#   round of comparison, we must use a slightly more complicated function for the evaluating function:

evaluate_perf_loop <- function(n){
  factorial_perf_loop <- summary(microbenchmark(factorial_loop(n), 
                                                factorial_reduce(n),
                                                factorial_func(n),
                                                factorial_mem(n)))   #summarizes the result
  factorial_perf_loop.df <- data.frame(factorial_perf_loop)           #presents the result as a data frame
  print(factorial_perf_loop.df)                                       #prints the data frame
} 

for (i in 1:12){
  print(i)
  evaluate_perf_loop(i)
}

######################################################################################################################
