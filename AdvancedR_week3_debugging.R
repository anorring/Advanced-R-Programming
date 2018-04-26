######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: April 2018 						                                                                                   ###
### Content: This script contains the R code for the 3rd week of Advanced R programming course                     ###
######################################################################################################################

# Access all the needed libraries:

######################################################################################################################
###             DEBUGGING
######################################################################################################################

#Debugging is the process of getting your expectations to converge with reality. When writing software in any 
#   language, we develop a certain set of expectations about how the software should behave and what it should do. 
#   But inevitably, when we run the software, it does something different from what we expected. In these situations, 
#   we need to engage in a process to determine if
#   1. Our expectations were incorrect, based on the documented behavior of the software; or
#   2. There is a problem with the code, such that the programming is not done in a way that will match expectations.

#In the previous section, we discussed what to do when software generates conditions (errors, warnings, messages) in 
#   a manner that is completely expected. In those cases, we know that certain functions will generate errors and we 
#   want to handle them in a manner that is not the usual way.

#This section describes the tools for debugging your software in R. R comes with a set of built-in tools for 
#   interactive debugging that can be useful for tracking down the source of problems. These functions are
#       browser(): an interactive debugging environment that allows you to step through code one expression at a time
#       debug() / debugonce(): a function that initiates the browser within a function
#       trace(): this function allows you to temporarily insert pieces of code into other functions to modify their 
#          behavior
#       recover(): a function for navigating the function call stack after a function has thrown an error
#       traceback(): prints out the function call stack after an error occurs; does nothing if there’s no error

######################################################################################################################
## traceback()
######################################################################################################################

#If an error occurs, the easiest thing to do is to immediately call the traceback() function. This function returns 
#   the function call stack just before the error occurred so that you can see what level of function calls the error
#   occurred. If you have many functions calling each other in succeeding, the traceback() output can be useful for 
#   identifying where to go digging first.

#For example, the following code gives an error.

check_n_value <- function(n) {
  if(n > 0) {
    stop("n should be <= 0")
  }
}
error_if_n_is_greater_than_zero <- function(n){
  check_n_value(n)
  n
}
error_if_n_is_greater_than_zero(5)

#Running the traceback() function immediately after getting this error would give us

traceback()

#From the traceback, we can see that the error occurred in the check_n_value() function. Put another way, the stop() 
#   function was called from within the check_n_value() function.

######################################################################################################################
## BROWSING A FUNCTION ENVIRONMENT
######################################################################################################################

#From the traceback output, it is often possible to determine in which function and on which line of code an error 
#   occurs. If you are the author of the code in question, one easy thing to do is to insert a call to the browser()
#   function in the vicinity of the error (ideally, before the error occurs). The browser()function takes now 
#   arguments and is just placed wherever you want in the function. Once it is called, you will be in the browser 
#   environment, which is much like the regular R workspace environment except that you are inside a function.

check_n_value <- function(n) {
  if(n > 0) {
    browser()  ## Error occurs around here
    stop("n should be <= 0")
  }
}

#Now, when we call error_if_n_is_greater_than_zero(5), we will see the following:

error_if_n_is_greater_than_zero(5)

######################################################################################################################
## TRACING FUNCTIONS
######################################################################################################################

#If you have easy access to the source code of a function (and can modify the code), then it’s usually easiest to 
#   insert browser() calls directly into the code as you track down various bugs. However, if you do not have easy 
#   access to a function’s code, or perhaps a function is inside a package that would require rebuilding after each 
#   edit, it is sometimes easier to make use of the trace() function to make temporary code modifications.

#The simplest use of trace() is to just call trace() on a function without any other arguments.

trace("check_n_value")

#Now, whenever check_n_value() is called by any other functions, you will see a message printed to the console 
#   indicating that the function was called.

error_if_n_is_greater_than_zero(5)
trace: check_n_value(n)

#Here we can see that check_n_value() was called once before the error occurred. But we can do more with trace(), 
#   such as inserting a call to browser() in a specific place, such as right before the call to stop().

#We can obtain the expression numbers of each part of a function by calling as.list() on the body() of a function.

as.list(body(check_n_value))

#Here, the if statement is the second expression in the function (the first “expression” being the very beginning of
#   the function). We can further break down the second expression as follows.

as.list(body(check_n_value)[[2]])

#Now we can see the call to stop() is the third sub-expression within the second expression of the overall function. 
#   We can specify this to trace() by passing an integer vector wrapped in a list to the at argument.

trace("check_n_value", browser, at = list(c(2, 3)))

#The trace() function has a side effect of modifying the function and converting into a new object of class 
#   “functionWithTrace”.

check_n_value

#You can see the internally modified code by calling

body(check_n_value)

#Here we can see that the code has been altered to add a call to browser() just before the call to stop().

#We can add more complex expressions to a function by wrapping them in a call to quote() within the the trace() 
#   function. For example, we may only want to invoke certain behaviors depending on the local conditions of the 
#   function.

trace("check_n_value", quote({
  if(n == 5) {
    message("invoking the browser")
    browser()
  }
}), at = 2)

#Here, we only invoke the browser() if n is specifically 5.

body(check_n_value)

#Debugging functions within a package is another key use case for trace(). For example, if we wanted to insert 
#   tracing code into the glm() function within the stats package, the only addition to the trace() call we would 
#   need is to provide the namespace information via the where argument.

trace("glm", browser, at = 4, where = asNamespace("stats"))

#Here we show the first few expressions of the modified glm() function.

body(stats::glm)[1:5]

######################################################################################################################
## USING debug() AND debugonce()
######################################################################################################################

#The debug() and debugonce() functions can be called on other functions to turn on the “debugging state” of a 
#   function. Calling debug() on a function makes it such that when that function is called, you immediately enter a 
#   browser and can step through the code one expression at a time.

## Turn on debugging state for 'lm' function

debug(lm)

#A call to debug(f) where f is a function is basically equivalent to trace(f, browser) which will call the browser() 
#   function upon entering the function.

#The debugging state is persistent, so once a function is flagged for debugging, it will remain flagged. Because it
#   is easy to forget about the debugging state of a function, the debugonce() function turns on the debugging state
#   the next time the function is called, but then turns it off after the browser is exited.

######################################################################################################################
## recover()
######################################################################################################################

#The recover() function is not often used but can be an essential tool when debugging complex code. Typically, you
#   do not call recover() directly, but rather set it as the function to invoke anytime an error occurs in code. 
#   This can be done via the options() function.

options(error = recover)

#Usually, when an error occurs in code, the code stops execution and you are brought back to the usual R console 
#   prompt. However, when recover() is in use and an error occurs, you are given the function call stack and a menu.

error_if_n_is_greater_than_zero(5)

#Selecting a number from this menu will bring you into that function on the call stack and you will be placed in a 
#   browser environment. You can exit the browser and then return to this menu to jump to another function in the 
#   call stack.

#The recover() function is very useful if an error is deep inside a nested series of function calls and it is 
#   difficult to pinpoint exactly where an error is occurring (so that you might use browser() or trace()). In such
#   cases, the debug() function is often of little practical use because you may need to step through many many 
#   expressions before the error actually occurs. Another scenario is when there is a stochastic element to your 
#   code so that errors occur in an unpredictable way. Using recover() will allow you to browse the function 
#   environment only when the error eventually does occur.

# The debugging tools in any programming language can be essential for tracking down problems in code, especially 
#   when the code becomes complex and spans many lines. However, one should not lean on them too heavily so that 
#   they become a regular part of the programming process. It is easy to get into a situation where you “throw some 
#   code out there” and then let the debugger catch it before something bad happens. If you find yourself coding up
#   a function and then immediately calling debug() on it, you are in this situation.

#A better approach is to think carefully about what a function should do and then consider how to code it up. A few
#   minutes of careful forethought can often save the hapless programmer hours of debugging.

