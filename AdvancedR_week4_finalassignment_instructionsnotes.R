######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the final assignment of Advanced R programming course             ###
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
### INSTRUCTIONS
######################################################################################################################

#The overall purpose of this assessment is to evaluate your ability to apply functional programming and object 
#   oriented programming concepts in R. There are two parts to this assignment. The first part compares different 
#   functional programming techniques and benchmarks their performance. The second part uses object-oriented 
#   programming techniques to define a class to represent longitudinal data and provide a set of functions for 
#   interacting with such data.

### REVIEW CRITERIA

#For both parts of this assignment you are required to write R code and to produce some analysis or output. You will
#   be assessed on both the R code and the quality/accuracy of the output.

#Please note that you should never execute someone else's R code. Evaluation of R code should be done via inspecting
#   the code itself and by making your best assessment as to whether the code satisfies the rubric provided.

#For each part you will need to prepare a script file and an output file. The script file contains your code 
#   (i.e. functions, definitions) and the output file contains the output/analysis obtained by running your code. 
#   You will be evaluated on both the quality of the code and the appropriateness of the output.

######################################################################################################################
### STEP-BY-STEP ASSIGNMENT INSTRUCTIONS
######################################################################################################################

## PART 1: FACTORIAL FUNCTION

#The objective of Part 1 is to write a function that computes the factorial of an integer greater than or equal to 0.
#   Recall that the factorial of a number n is n * (n-1) * (n - 2) * … * 1. The factorial of 0 is defined to be 1.
#   Before taking on this part of the assignment, you may want to review the section on Functional Programming in 
#   this course (https://bookdown.org/rdpeng/RProgDA/functional-programming.html).

#For this Part you will need to write four different versions of the Factorial function:

#   1. Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)
#   2. Factorial_reduce: a version that computes the factorial using the reduce() function in the purrr package. Alternatively, you can use the Reduce() function in the base package.
#   3. Factorial_func: a version that uses recursion to compute the factorial.
#   4. Factorial_mem: a version that uses memoization to compute the factorial.

#After writing your four versions of the Factorial function, use the microbenchmark package to time the operation of
#   these functions and provide a summary of their performance. In addition to timing your functions for specific 
#   inputs, make sure to show a range of inputs in order to demonstrate the timing of each function for larger inputs.

#In order to submit this assignment, please prepare two files:
#   1. factorial_code.R: an R script file that contains the code implementing your classes, methods, and generics for
#         the longitudinal dataset.
#   2. factorial_output.txt: a text file that contains the results of your comparison of the four different 
#         implementations.

######################################################################################################################

## PART 2: LONGITUDINAL DATA CLASS AND METHODS

#The purpose of this part is to create a new class for representing longitudinal data, which is data that is 
#   collected over time on a given subject/person. This data may be collected at multiple visits, in multiple 
#   locations. You will need to write a series of generics and methods for interacting with this kind of data.

#The data for this part come from a small study on indoor air pollution on 10 subjects. Each subject was visited 3 
#   times for data collection. Indoor air pollution was measured using a high-resolution monitor which records 
#   pollutant levels every 5 minutes and the monitor was placed in the home for about 1 week. In addition to 
#   measuring pollutant levels in the bedroom, a separate monitor was usually placed in another room in the house at
#   roughly the same time.

#Before doing this part you may want to review the section on object oriented programming 
#   (https://bookdown.org/rdpeng/RProgDA/object-oriented-programming.html).

#Data: https://www.coursera.org/learn/advanced-r/peer/98rUI/functional-and-object-oriented-programming

#The variables in the dataset are
#     id: the subject identification number
#     visit: the visit number which can be 0, 1, or 2
#     room: the room in which the monitor was placed
#     value: the level of pollution in micrograms per cubic meter
#     timepoint: the time point of the monitor value for a given visit/room

#You will need to design a class called “LongitudinalData” that characterizes the structure of this longitudinal 
#   dataset. You will also need to design classes to represent the concept of a “subject”, a “visit”, and a “room”.

#In addition you will need to implement the following functions
#     1. make_LD: a function that converts a data frame into a “LongitudinalData” object
#     2. subject: a generic function for extracting subject-specific information
#     3. visit: a generic function for extracting visit-specific information
#     4. room: a generic function for extracting room-specific information

#For each generic/class combination you will need to implement a method, although not all combinations are 
#   necessary (see below). You will also need to write print and summary methods for some classes (again, see below).

#To complete this Part, you can use either the S3 system, the S4 system, or the reference class system to implement 
#   the necessary functions. It is probably not wise to mix any of the systems together, but you should be able to
#   compete the assignment using any of the three systems. The amount of work required should be the same when using
#   any of the systems.

#For this assessment, you will need to implement the necessary functions to be able to execute the code in the 
#   following script file:

###########

## Read in the data
library(readr)
library(magrittr)
source("oop_code.R")
## Load any other packages that you may need to execute your code

data <- read_csv("data/MIE.csv")
x <- make_LD(data)
print(class(x))
print(x)

## Subject 10 doesn't exist
out <- subject(x, 10)
print(out)

out <- subject(x, 14)
print(out)

out <- subject(x, 54) %>% summary
print(out)

out <- subject(x, 14) %>% summary
print(out)

out <- subject(x, 44) %>% visit(0) %>% room("bedroom")
print(out)

## Show a summary of the pollutant values
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary
print(out)

out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary
print(out)

###########

#The output should appear similar to the output in the following file:

#https://d3c33hcgiwev3.cloudfront.net/_6fcb9d2497a51c26f4b0574b63866e21_oop_output.txt?Expires=1524960000&Signature=h8sW6YwIAS9SXbioJp-X0zvnhD1Ndd11le-ruYzTEXsGkqaoMrfvtouU1pX1Sd0J0KC31VON2J-IOWlK0~~Nt0OCMlc9uaI7LDn6crwVwdfRvKEBaau0Nm37QYVnudNVsO3iDzHEqQA~jbTFBtkKjp~-YIK9RxeNOHeW6nfxI7c_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A

#The output of your function does not need to match exactly, but it should convey the same information.

#In order to submit this assignment, please prepare two files:
#     1. oop_code.R: an R script file that contains the code implementing your classes, methods, and generics for 
#                     the longitudinal dataset.
#     2. oop_output.txt: a text file containing the output of running the above input code.
