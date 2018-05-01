######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 1st week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:

######################################################################################################################
###             CONTROL STRUCTURES
######################################################################################################################

######################################################################################################################
### if, if-else AND if-else if-else STRUCTURES

## Allows you to test a condition and act on it depending on wheter itäs true or false.

#if(<condition>) {
  ## do something, if else (if) not specified and condition is false, this does nothing
#} else if (<condition 2>) {
  ## do something different
#} else {
  ## do something different yet
#}

## Example: generate a uniform random number:

x <- runif(1, 0, 10)
if(x > 3) {
  y <- 10
} else {
  y <- 0
}


## If-clauses can be a series:

x <- runif(1, 0, 10)
if(x > 3) {
  y <- 10
} 
if(x < 5) {
  z <- 0
}

######################################################################################################################
## for LOOPS

## Pretty much the only looping construct you will need in R. For loops take an iterator variable and assign it 
##    successive values from a sequence or vector. For loops are most commonly used for iterating over the elements of 
##    an object (list, vector, etc.).

# Loop through and print the characters a, b, c, d
for(letter in c("a","b","c","d")) {
  print(letter)
}

# Loop through integers 1, 2, 3, 4, 5
for(i in 1:5) {
  print(i + 5)
}

# Write a for-loop that prints out "One more time!" 27 times
for(x in 1:27) {
  x <- "One more time!"
  print(x)
}

# Loop through integers 1:10 and 
numbers <- rnorm(10)
for(i in 1:10) {
  print(numbers[i])
}

# Other loops:
x <- c("a", "b", "c", "d")
for(i in 1:4) {
  ## Print each element in x
  print(x[i])
}

# The seq_along() function is commonly used in conjuction with for loops in order to generate an integer sequence
#   based on the length of an object:

# Generate a sequence based on the lenght of 'x':
for(i in seq_along(x)) {
  print(x[i])
}

# Index-type variable is not necessary:
for(letter in x) {
  print(letter)
}

# One line loops -> no need for curly brackets:
for(i in 1:4) print(x[i])

######################################################################################################################
## NESTED for LOOPS

x <- matrix(1:6, 2, 3)
x
for(i in seq_len(nrow(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i,j])
  }
}

######################################################################################################################
## SKIPPING IN for LOOPS: next, break

# next skips an iteration ofa loop:
for(i in 1:100) {
  print(i + 5)
  if(i <= 20) {
    next ##skip the first 20 iterations
  }
}

# break exits the loop immediately:
for(i in 1:100) {
  print(i + 5)
    if(i > 20) {
    break ##stop after the first 20 iterations
  }
}

######################################################################################################################
###             FUNCTIONS
######################################################################################################################

######################################################################################################################
## CODE

# Code takes care of the task at hand:

library(readr)
library(dplyr)

## Download data from RStudio (if we haven't already)
if(!file.exists("data/2016-07-20.csv.gz")) {
  download.file("http://cran-logs.rstudio.com/2016/2016-07-20.csv.gz", 
                "data/2016-07-20.csv.gz")
}
cran <- read_csv("data/2016-07-20.csv.gz", col_types = "ccicccccci")
cran %>% filter(package == "filehash") %>% nrow

#Once we've identified which aspects of a block of code we might want to modify or vary, we can take those things and 
#   abstract them to be arguments of a function.

######################################################################################################################
## FUNCTION INTERFACE

#The following function has two arguments:
#   pkgname, the name of the package as a character string
#   date, a character string indicating the date for which you want download statistics, in year-month-day format

library(dplyr)
library(readr)

## pkgname: package name (character)
## date: YYYY-MM-DD format (character)
num_download <- function(pkgname, date) {
  ## Construct web URL
  year <- substr(date, 1, 4)
  src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                 year, date)
  
  ## Construct path for storing local file
  dest <- file.path("data", basename(src))
  
  ## Don't download if the file is already there!
  if(!file.exists(dest))
    download.file(src, dest, quiet = TRUE)
  
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package == pkgname) %>% nrow
}

num_download("filehash", "2016-07-20")

num_download("Rcpp", "2016-07-19")

######################################################################################################################
## DEFAULT VALUES

# Setting a certain date as a default value in the example:

num_download <- function(pkgname, date = "2016-07-20") {
  year <- substr(date, 1, 4)
  src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                 year, date)
  dest <- file.path("data", basename(src))
  if(!file.exists(dest))
    download.file(src, dest, quiet = TRUE)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package == pkgname) %>% nrow
}

num_download("Rcpp")

######################################################################################################################
## RE-FACTORING CODE

# It might make sense to abstract the first two things on this list into a separate function. For example, we could 
#   create a function called check_for_logfile() to see if we need to download the log file and then num_download() 
#   could call this function.

check_for_logfile <- function(date) {
  year <- substr(date, 1, 4)
  src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                 year, date)
  dest <- file.path("data", basename(src))
  if(!file.exists(dest)) {
    val <- download.file(src, dest, quiet = TRUE)
    if(!val)
      stop("unable to download file ", src)
  }
  dest
}

#This file takes the original download code from num_download() and adds a bit of error checking to see if 
#   download.file()was successful (if not, an error is thrown with stop()). Now the num_download() function is somewhat
#   simpler.

num_download <- function(pkgname, date = "2016-07-20") {
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package == pkgname) %>% nrow
}   

######################################################################################################################
## DEPENDENCY CHECKING

# The num_downloads() function depends on the readr and dplyr packages. Without them installed, the function won't 
#   run. Sometimes it is useful to check to see that the needed packages are installed so that a useful error 
#   message (or other behavior) can be provided for the user. We can write a separate function to check that the 
#   packages are installed.

check_pkg_deps <- function() {
  if(!require(readr)) {
    message("installing the 'readr' package")
    install.packages("readr")
  }
  if(!require(dplyr))
    stop("the 'dplyr' package needs to be installed first")
}

# The require() function is similar to library(), however library() stops with an error if the package cannot be 
#   loaded whereas require() returns TRUE or FALSE depending on whether the package can be loaded or not. For both 
#   functions, if the package is available, it is loaded and attached to the search() path.

# Now, our updated function can check for package dependencies.

num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package == pkgname) %>% nrow
}

######################################################################################################################
## VECTORIZATION

# One final aspect of this function that is worth noting is that as currently written it is not vectorized. This 
#   means that each argument must be a single value---a single package name and a single date. However, in R, it is 
#   a common paradigm for functions to take vector arguments and for those functions to return vector or list 
#   results. Often, users are bitten by unexpected behavior because a function is assumed to be vectorized when it 
#   is not.

# One way to vectorize this function is to allow the pkgname argument to be a character vector of package names. 
#   This way we can get download statistics for multiple packages with a single function call. Luckily, this is 
#   fairly straightforward to do. The two things we need to do are:
#       Adjust our call to filter() to grab rows of the data frame that fall within a vector of package names
#       Use a group_by() %>% summarize() combination to count the downloads for each package.

## 'pkgname' can now be a character vector of names
num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package %in% pkgname) %>% 
    group_by(package) %>%
    summarize(n = n())
}    

#Now we can call the following
num_download(c("filehash", "weathermetrics"))

# Note that the output of num_download() has changed. While it previously returned an integer vector, the vectorized 
#   function returns a data frame. If you are authoring a function that is used by many people, it is usually wise 
#   to give them some warning before changing the nature of the output.

######################################################################################################################
## ARGUMENT CHECKING

# Checking that the arguments supplied by the reader are proper is a good way to prevent confusing results or error 
#   messages from occurring later on in the function. It is also a useful way to enforce documented requirements for 
#   a function.

# In this case, the num_download() function is expecting both the pkgname and date arguments to be character vectors. 
#   In particular, the date argument should be a character vector of length 1. We can check the class of an argument 
#   usingis.character() and the length using the length() function.

num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  
  ## Check arguments
  if(!is.character(pkgname))
    stop("'pkgname' should be character")
  if(!is.character(date))
    stop("'date' should be character")
  if(length(date) != 1)
    stop("'date' should be length 1")
  
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", 
                   progress = FALSE)
  cran %>% filter(package %in% pkgname) %>% 
    group_by(package) %>%
    summarize(n = n())
}    

num_download("filehash", c("2016-07-20", "2016-0-21"))

# Note that here, we chose to stop() and throw an error if the argument was not of the appropriate type. However, an 
#   alternative would have been to simply coerce the argument to be of character type using the as.character() 
#   function.

######################################################################################################################
## WHEN SHOULD I WRITE A FUNCTION?

# If you're going to do something once (that does happen on occasion), just write some code and document it very well.
#   The important thing is that you want to make sure that you understand what the code does, and so that requires 
#   both writing the code well and writing documentation. You want to be able to reproduce it later on if you ever 
#   come back to it, or if someone else comes back to it.

# If you're going to do something twice, write a function. This allows you to abstract a small piece of code, and it 
#   forces you to define an interface, so you have well defined inputs and outputs.

# If you're going to do something three times or more, you should think about writing a small package. It doesn't 
#   have to be commercial level software, but a small package which encapsulates the set of operations that you're 
#   going to be doing in a given analysis. It's also important to write some real documentation so that people can 
#   understand what's supposed to be going on, and can apply the software to a different situation if they have to.

######################################################################################################################
###             ASSIGNMENT: FUNCTIONS
######################################################################################################################

swirl()

#The Sys.Date() function returns a string representing today's date.

#The mean() function takes a vector of numbers as input, and returns the average of all of the numbers in the input
# vector. Inputs to functions are often called arguments. Providing arguments to a function is also sometimes called
# passing arguments to that function. Arguments you want to pass to a function go inside the function's parentheses.
# Try passing the argument c(2, 4, 5) to the mean() function.

 mean(c(2,4,5))

 # Just like you would assign a value to a variable with the assignment operator, you assign functions in the 
 # following way:
 #
 # function_name <- function(arg1, arg2){
 #	# Manipulate arguments in some way
 #	# Return a value
 # }
 #
 # The "variable name" you assign will become the name of your function. arg1 and
 # arg2 represent the arguments of your function. You can manipulate the arguments
 # you specify within the function. After sourcing the function, you can use the 
 # function by typing:
 # 
 # function_name(value1, value2)
 
 ## A simple example:
 boring_function <- function(x) {
   x
 }
 
 # If you want to see the source code for any function, just type the function name without any arguments or
 # parentheses.
 
 ## A more useful function:
 my_mean <- function(my_vector) {
   sum(my_vector)/length(my_vector)
 }
 
 my_mean(c(4,5,10))

## Default arguments: 

 # This function will take two arguments: "number" and
 # "by" where "number" is the digit I want to increment and "by" is the amount I
 # want to increment "number" by. 
 # increment <- function(number, by = 1){
 #     number + by
 # }
 #
 # However if I want to provide a value for the "by" argument I still can! The
 # expression: increment(5, 2) will evaluate to 7. 
 # 
 # remainder() will take
 # two arguments: "num" and "divisor" where "num" is divided by "divisor" and
 # the remainder is returned. Imagine that you usually want to know the remainder
 # when you divide by 2, so set the default value of "divisor" to 2. 
 # Hint #1: You can use the modulus operator %% to find the remainder.
 #   Ex: 7 %% 4 evaluates to 3. 
 #
 remainder <- function(num, divisor = 2) {
   num %% divisor
 }
 
 #You can also explicitly specify arguments in a function. When you explicitly designate argument values by name, the
 # ordering of the arguments becomes unimportant.
 
 #Type: args(remainder) to examine the arguments for the remainder function.
 
 # You can pass functions as arguments to other functions just like you can pass
 # data to functions. Let's say you define the following functions:
 #
 # add_two_numbers <- function(num1, num2){
 #    num1 + num2
 # }
 #
 # multiply_two_numbers <- function(num1, num2){
 #	num1 * num2
 # }
 #
 # some_function <- function(func){
 #    func(2, 4)
 # }
 #
 # As you can see we use the argument name "func" like a function inside of 
 # "some_function()." By passing functions as arguments 
 # some_function(add_two_numbers) will evaluate to 6, while
 # some_function(multiply_two_numbers) will evaluate to 8.
 # 
 # Finish the function definition below so that if a function is passed into the
 # "func" argument and some data (like a vector) is passed into the dat argument
 # the evaluate() function will return the result of dat being passed as an
 # argument to func.
 #
 # Hints: This exercise is a little tricky so I'll provide a few example of how
 # evaluate() should act:
 #    1. evaluate(sum, c(2, 4, 6)) should evaluate to 12
 #    2. evaluate(median, c(7, 40, 9)) should evaluate to 9
 #    3. evaluate(floor, 11.1) should evaluate to 11
 
 evaluate <- function(func, dat){
   func(dat)
 }
 
 evaluate(sd, c(1.4,3.6,7.9,8.8))

 evaluate(function(x){x+1},6)
 #The first argument is a tiny anonymous function that takes one argument `x` and returns `x+1`. We passed the number
 # 6 into this function so the entire expression evaluates to 7.
 
 #Try using evaluate() along with an anonymous function to return the first element of the vector c(8, 4, 0). Your
 # anonymous function should only take one argument which should be a variable `x`.
 
 evaluate(function(x){x[1]}, c(8, 4, 0))
 
 evaluate(function(x){x[length(x)]}, c(8,4,0))

 # The ellipses can be used to pass on arguments to other functions that are
 # used within the function you're writing. Usually a function that has the
 # ellipses as an argument has the ellipses as the last argument. The usage of
 # such a function would look like:
 #
 # ellipses_func(arg1, arg2 = TRUE, ...)
 #
 # In the above example arg1 has no default value, so a value must be provided
 # for arg1. arg2 has a default value, and other arguments can come after arg2
 # depending on how they're defined in the ellipses_func() documentation.
 # Interestingly the usage for the paste function is as follows:
 #
 # paste (..., sep = " ", collapse = NULL)
 #
 # Notice that the ellipses is the first argument, and all other arguments after
 # the ellipses have default values. This is a strict rule in R programming: all
 # arguments after an ellipses must have default values. Take a look at the
 # simon_says function below:
 #
 # simon_says <- function(...){
 #   paste("Simon says:", ...)
 # }
 #
 # The simon_says function works just like the paste function, except the
 # begining of every string is prepended by the string "Simon says:"
 #
 # Telegrams used to be peppered with the words START and STOP in order to
 # demarcate the beginning and end of sentences. Write a function below called 
 # telegram that formats sentences for telegrams.
 # For example the expression `telegram("Good", "morning")` should evaluate to:
 # "START Good morning STOP"
 
 telegram <- function(...){
   paste("START", ..., "STOP")
 }
 
 telegram("Pette", "on", "ihana")
 
 # Let's explore how to "unpack" arguments from an ellipses when you use the
 # ellipses as an argument in a function. Below I have an example function that
 # is supposed to add two explicitly named arguments called alpha and beta.
 # 
 # add_alpha_and_beta <- function(...){
 #   # First we must capture the ellipsis inside of a list
 #   # and then assign the list to a variable. Let's name this
 #   # variable `args`.
 #
 #   args <- list(...)
 #
 #   # We're now going to assume that there are two named arguments within args
 #   # with the names `alpha` and `beta.` We can extract named arguments from
 #   # the args list by using the name of the argument and double brackets. The
 #   # `args` variable is just a regular list after all!
 #   
 #   alpha <- args[["alpha"]]
 #   beta  <- args[["beta"]]
 #
 #   # Then we return the sum of alpha and beta.
 #
 #   alpha + beta 
 # }
 #
 # Have you ever played Mad Libs before? The function below will construct a
 # sentence from parts of speech that you provide as arguments. We'll write most
 # of the function, but you'll need to unpack the appropriate arguments from the
 # ellipses.
 
 mad_libs <- function(...){
   # Do your argument unpacking here!
   args <- list(...)
   place <- args[["place"]]
   adjective <- args[["adjective"]]
   noun <- args[["noun"]]
   # Don't modify any code below this comment.
   # Notice the variables you'll need to create in order for the code below to
   # be functional!
   paste("News from", place, "today where", adjective, "students took to the streets in protest of the new", noun, "being installed on campus.")
 }
 
 # The syntax for creating new binary operators in R is unlike anything else in
 # R, but it allows you to define a new syntax for your function. I would only
 # recommend making your own binary operator if you plan on using it often!
 #
 # User-defined binary operators have the following syntax:
 #      %[whatever]% 
 # where [whatever] represents any valid variable name.
 # 
 # Let's say I wanted to define a binary operator that multiplied two numbers and
 # then added one to the product. An implementation of that operator is below:
 #
 # "%mult_add_one%" <- function(left, right){ # Notice the quotation marks!
 #   left * right + 1
 # }
 #
 # I could then use this binary operator like `4 %mult_add_one% 5` which would
 # evaluate to 21.
 #
 # Write your own binary operator below from absolute scratch! Your binary
 # operator must be called %p% so that the expression:
 #
 #       "Good" %p% "job!"
 #
 # will evaluate to: "Good job!"
 
 "%p%" <- function(left, right){ # Remember to add arguments!
   paste(left, right)
 }
 
 
 
 
 
   