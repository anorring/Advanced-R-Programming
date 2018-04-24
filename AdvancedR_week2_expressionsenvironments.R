######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 2nd week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:

######################################################################################################################
###             EXPRESSIONS AND ENVIRONMENTS
######################################################################################################################

######################################################################################################################
## EXPRESSIONS
######################################################################################################################

# Expressions are encapsulated operations that can be executed by R. This may sound complicated, but using 
#   expressions allows you manipulate code with code! You can create an expression using thequote() function. For 
#   that function’s argument, just type whatever you would normally type into the R console. For example:

two_plus_two <- quote(2 + 2)
two_plus_two

# You can execute this expressions using the eval() function:

eval(two_plus_two)

# You might encounter R code that is stored as a string that you want to evaluate with eval(). You can use parse() to 
#   transform a string into an expression:

tpt_string <- "2 + 2"
tpt_expression <- parse(text = tpt_string)
eval(tpt_expression)

#You can reverse this process and transform an expression into a string using deparse():

deparse(two_plus_two) 

#One interesting feature about expressions is that you can access and modify their contents like you a list(). This 
#   means that you can change the values in an expression, or even the function being executed in the expression 
#   before it is evaluated:  

sum_expr <- quote(sum(1, 5))
eval(sum_expr)
sum_expr[[1]]
sum
sum_expr[[2]]
sum_expr[[3]]
sum_expr[[1]] <- quote(paste0)
sum_expr[[2]] <- quote(4)
sum_expr[[3]] <- quote(6)
eval(sum_expr)

#You can compose expressions using the call() function. The first argument is a string containing the name of a 
#   function, followed by the arguments that will be provided to that function.

sum_40_50_expr <- call("sum", 40, 50)
sum_40_50_expr
sum(40, 50)
eval(sum_40_50_expr)

#You can capture the expression an R user typed into the R console when they executed a function by including 
#   match.call() in the function the user executed:

return_expression <- function(...){
  match.call()
}

return_expression(2, col = "blue", FALSE)
return_expression(2, col = "blue", FALSE)

#You could of course then manipulate this expression inside of the function you’re writing. The example below first 
#   uses match.call()to capture the expression that the user entered. The first argument of the function is then 
#   extracted and evaluated. If the first expression is a number, then a string is returned describing the first 
#   argument, otherwise the string "The first argument is not numeric." is returned.

first_arg <- function(...){
  expr <- match.call()
  first_arg_expr <- expr[[2]]
  first_arg <- eval(first_arg_expr)
  if(is.numeric(first_arg)){
    paste("The first argument is", first_arg)
  } else {
    "The first argument is not numeric."
  }
}

first_arg(2, 4, "seven", FALSE)

first_arg("two", 4, "seven", FALSE)

#Expressions are a powerful tool for writing R programs that can manipulate other R programs.


######################################################################################################################
## ENVIRONMENTS
######################################################################################################################

#Environments are data structures in R that have special properties with regard to their role in how R code is 
#   executed and how memory in R is organized. You may not realize it but you’re probably already familiar with one 
#   environment called the global environment. Environments formalize relationships between variable names and 
#   values. When you enter x <- 55 into the R console what you’re saying is: assign the value of 55 to a variable 
#   called x, and store this assignment in the global environment. The global environment is therefore where most R 
#   users do most of their programming and analysis.

#You can create a new environment using new.env(). You can assign variables in that environment in a similar way to 
#   assigning a named element of a list, or you can use assign(). You can retrieve the value of a variable just like 
#   you would retrieve the named element of a list, or you can use get(). Notice that assign() and get() are 
#   opposites:
  
my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x
assign("y", 9, envir = my_new_env)
get("y", envir = my_new_env)
my_new_env$y

#You can get all of the variable names that have been assigned in an environment using ls(), you can remove an 
#   association between a variable name and a value using rm(), and you can check if a variable name has been 
#   assigned in an environment using exists():
  
ls(my_new_env)
rm(y, envir = my_new_env)
exists("y", envir = my_new_env)
exists("x", envir = my_new_env)
my_new_env$x
my_new_env$y

#Environments are organized in parent/child relationships such that every environment keeps track of its parent, but
#   parents are unaware of which environments are their children. Usually the relationships between environments is 
#   not something you should try to directly control. You can see the parents of the global environment using 
#   the search() function:
  
search()

#As you can see package:magrittr is the parent of .GlobalEnv, and package:tidyr is parent of package:magrittr, and 
#   so on. In general the parent of .GlobalEnv is always the last package that was loaded usinglibrary(). Notice 
#   that after I load the ggplot2 package, that package becomes the parent of .GlobalEnv:

library(ggplot2)
search()

######################################################################################################################
## EXECUTION ENVIRONMENTS
######################################################################################################################

#Although there may be several cases where you need to create a new environment using new.env(), you will more often
#   create new environments whenever you execute functions. An execution environment is an environment that exists 
#   temporarily within the scope of a function that is being executed. For example if we have the following code:
  
x <- 10
my_func <- function(){
  x <- 5
  return(x)
}
my_func()

#So what exactly is happening above? First the name x is being assigned the value 10 in the global environment. Then
#   the namemy_func is being assigned the value of the function function(){x <- 5};return(x)} in the global 
#   environment. When my_func() is executed, a new environment is created called the execution environment which 
#   only exists while my_func() is running. Inside of the execution environment the name x is assigned the value 5. 
#   When return() is executed it looks first in the execution environment for a value that is assigned to x. Then 
#   the value 5 is returned. In contrast to the situation above, take a look at this variation:
  
x <- 10
another_func <- function(){
  return(x)
}
another_func()

#In this situation the execution environment inside of another_func() does not contain an assignment for the name x, 
#   so R looks for an assignment in the parent environment of the execution environment which is the global 
#   environment. Since x is assigned the value 10 in the global environment 10 is returned.

#After seeing the cases above you may be curious if it’s possible for an execution environment to manipulate the 
#   global environment. You’re already familiar with the assignment operator <-, however you should also be aware 
#   that there’s another assignment operator called the complex assignment operator which looks like <<-. You can 
#   use the complex assignment operator to re-assign or even create name-value bindings in the global environment 
#   from within an execution environment. In this first example, the function assign1() will change the value 
#   associated with the name x:
  
x <- 10
x
assign1 <- function(){
  x <<- "Wow!"
}
assign1()
x

#You can see that the value associated with x has been changed from 10 to "Wow!" in the global environment. You can
#   also use <<- to assign names to values that have not been yet been defined in the global environment from inside
#   a function:
  
a_variable_name
exists("a_variable_name")
assign2 <- function(){
  a_variable_name <<- "Magic!"
}
assign2()
exists("a_variable_name")
a_variable_name

#If you want to see a case for using <<- in action, see the section of this book about functional programming and 
#   the discussion there about memoization.



