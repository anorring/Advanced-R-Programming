######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 3rd week of Advanced R programming course                     ###
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
###             NON-STANDARD EVALUATION
######################################################################################################################

#Functions that use non-standard evaluation can cause problems within functions written for a package.
#The NSE functions in tidyverse packages all have standard evaluation analogues that should be used when writing 
#   functions that will be used by others.

#Functions from packages like dplyr, tidyr, and ggplot2 are excellent for creating efficient and easy-to-read code 
#   that cleans and displays data. However, they allow shortcuts in calling columns in data frames that allow some 
#   room for ambiguity when you move from evaluating code interactively to writing functions for others to use. The
#   non-standard evaluation used within these functions mean that, if you use them as you would in an interactive 
#   session, you’ll get a lot of “no visible bindings” warnings when you run CRAN checks on your package. These
#   warnings will look something like this:

#map_counties: no visible binding for global variable ‘fips’
#map_counties: no visible binding for global variable ‘storm_dist’
#map_counties: no visible binding for global variable ‘tot_precip’
#Undefined global functions or variables:
#  fips storm_dist tot_precip

#When you write a function for others to use, you need to avoid non-standard evaluation and so avoid all of these
#   functions (culprits include many dplyr and tidyr functions– including mutate, select, filter, group_by, summarize,
#   gather, spread– but also some functions in ggplot2, including aes). Fortunately, these functions all have 
#   standard evaluation alternatives, which typically have the same function name followed by an underscore 
#   (for example, the standard evaluation version of mutate is mutate_).

#The input to the function call will need to be a bit different for standard evaluation versions of these functions.
#   In many cases, this change is as easy as using formula notation (~) within the call, but in some cases it 
#   requires something more complex, including using the .dots argument.

#Here is a table with examples of non-standard evaluation calls and their standard evaluation alternatives (these are
#   all written assuming that the function is being used as a step in a piping flow, where the input data frame has 
#   already been defined earlier in the piping sequence):
  
#Non-standard evaluation version	        Standard evaluation version
#filter(fips %in% counties)	              filter_(~ fips %in% counties)
#mutate(max_rain = max(tot_precip)	      mutate_(max_rain = ~ max(tot_precip)
#summarize(tot_precip = sum(precip))	    summarize_(tot_precip = ~ sum(precip))
#group_by(storm_id, fips)	                group_by_(~ storm_id, ~ fips)
#aes(x = long, y = lat)	                  aes_(x = ~ long, y = ~ lat)
#select(-start_date, -end_date)	          select_(.dots = c('start_date', 'end_date'))
#select(-start_date, -end_date)	          select_(.dots = c('-start_date', '-end_date'))
#spread(key, mean)	                      spread_(key_col = 'key', value_col = 'mean')
#gather(key, mean)	                      gather_(key_col = 'key', value_col = 'mean')

#If you have any non-standard evaluation in your package code (which you’ll notice because of the “no visible 
#   bindings” warnings you’ll get when you check the package), go through and change any instances to use standard 
#   evaluation alternatives. This change prevents these warnings when you check your package and will also ensure 
#   that the functions behave like you expect them to when they are run by other users in their own R sessions.
                                          
#In this section, we’ve explained only how to convert from functions that use non-standard evaluation to those that
#   use standard evaluation, to help in passing CRAN checks as you go from coding scripts to writing functions for 
#   packages. If you would like to learn more about non-standard evaluation in R, you should check out the chapter on
#   non-standard evaluation in Hadley Wickham’s Advanced Rbook.




