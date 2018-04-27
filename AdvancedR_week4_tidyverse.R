######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 4th week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:
library(dplyr)
library(tidyr)
library(readxl)
library(stringr)
library(readr)
library(lubridate)
library(ggplot2)


######################################################################################################################
###             TIDYVERSE
######################################################################################################################


######################################################################################################################
### REUSE EXISTING DATA STRUCTURES
######################################################################################################################

#R has a number of data structures (data frames, vectors, etc.) that people have grown accustomed to over the many 
#   years of R’s existence. While it is often tempting to develop custom data structures, for example, by using S3 or
#   S4 classes, it is often worthwhile to consider reusing a commonly used structure. You’ll notice that many 
#   tidyverse functions make heavy use of the data frame (typically as their first argument), because the data frame 
#   is a well-known, well-understood structure used by many analysts. Data frames have a well-known and reasonably
#   standardized corresponding file format in the CSV file.

#While common data structures like the data frame may not be perfectly suited to your needs as you develop your own
#   software, it is worth considering using them anyway because the enormous value to the community that is already 
#   familiar with them. If the user community feels familiar with the data structures required by your code, they are
#   likely to adopt them more quickly.

######################################################################################################################
### COMPOSE SIMPLE FUNCTIONS WITH THE PIPE
######################################################################################################################

#One of the original principles of the Unix operating system was that every program should do “one thing well”. The
#   limitation of only doing one thing (but well!) was removed by being able to easily pipe the output of one function
#   to be the input of another function (the pipe operator on Unix was the | symbol). Typical Unix commands would
#   contain long strings commands piped together to (eventually) produce some useful output. On Unix systems, the 
#   unifying concept that allowed programs to pipe to each other was the use of [textual formats]. All data was 
#   rendered in textual formats so that if you wrote a new program, you would not need to worry about decoding some
#   obscure proprietary format.

#Much like the original Unix systems, the tidyverse eschews building monolithic functions that have many bells and 
#   whistles. Rather, once you are finished writing a simple function, it is better to start afresh and work off the
#   input of another function to produce new output (using the %>% operator, for example). The key to this type of 
#   development is having clean interfaces between functions and an expectation that the output of every function may
#   serve as the input to another function. This is why the first principle (reuse existing data structures) is 
#   important, because the reuse of data structures that are well-understood and characterized lessens the burden on
#   other developers who are developing new code and would prefer not to worry about new-fangled data structures at 
#   every turn.

######################################################################################################################
### EMBRACE FUNCTIONAL PROGRAMMING
######################################################################################################################

#This can be a tough principle for people coming from other non-functional programming languages. But the reality is,
#   R is a functional programming language (with its roots in Scheme) and it’s best not to go against the grain. 
#   In our section on Functional Programming, we outlined many of the principles that are fundamental to 
#   functional-style programming. In particular, the purrr package implements many of those ideas.

#One benefit to functional programming is that it can at times be easier to reason about when simply looking at the 
#   code. The inability to modify arguments enables us to predict what the output of a function will be given a 
#   certain input, allowing for things like memoization. Functional programming also allows for simple 
#   parallelization, so that we can quickly parallelize any code that uses lapply() or map().

#Making your code readable and usable by people is goal that is overlooked surprisingly often. The result is things
#   like function names that are obscure and do not actually communicate what they do. When writing code, using things
#   like good, explicit, function names, with descriptive arguments, can allow for users to quickly learn your API. 
#   If you have a set of functions with a similar purpose, they might share a prefix (see e.g. geom_point(), 
#   geom_line(), etc.). If you have an argument like color that could either take arguments 1, 2, and 3, or black, 
#   red, and green, think about which set of arguments might be easier for humans to handle.



