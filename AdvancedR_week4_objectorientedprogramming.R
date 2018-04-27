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
###             OOP
######################################################################################################################

#Object oriented programming is one of the most successful and widespread philosophies of programming and is a 
#   cornerstone of many programming languages including Java, Ruby, Python, and C++. R has three object oriented 
#   systems because the roots of R date back to 1976, when the idea of object oriented programming was barely four 
#   years old. New object oriented paradigms were added to R as they were invented, so some of the ideas in R about 
#   object oriented programming have gone stale in the years since. It’s still important to understand these older 
#   systems since a huge amount of R code is written with them, and they’re still useful and interesting! Long time
#   object oriented programmers reading this book may find these old ideas refreshing.

#The two older object oriented systems in R are called S3 and S4, and the modern system is called RC which stands for
#   “reference classes.” Programmers who are already familiar with object oriented programming will feel at home 
#   using RC.

######################################################################################################################
### OBJECT ORIENTED PRINCIPLES
######################################################################################################################

#There a several key principles in object oriented programming which span across R’s object systems and other 
#   programming languages. The first are the ideas of a class and an object. The world is made up of physical objects
#   - the chair you’re sitting in, the clock next to your bed, the bus you ride every day, etc. Just like the world is
#   full of physical objects, your programs can be made of objects as well. A class is a blueprint for an object: it 
#   describes the parts of an object, how to make an object, and what the object is able to do. If you were to think
#   about a class for a bus (as in the public buses that roam the roads) this class would describe attributes for the
#   bus like the number of seats on the bus, the number of windows, the top speed of the bus, and the maximum 
#   distance the bus can drive on one tank of gas.

#Buses in general can perform the same actions, and these actions are also described in the class: a bus can open and
#   close its doors, the bus can steer, and the accelerator or the brake can be used to slow down or speed up the bus.
#   Each of these actions can be described as a method which is a function that is associated with a particular class.
#   We’ll be using this class in order to create individual bus objects, so we should provide a constructor which is 
#   a method where we can specify attributes of the bus as arguments. This constructor method will then return an
#   individual bus object with the attributes that we specified.

#You could also imagine that after making the bus class you might want to make a special kind of class for a party 
#   bus. Party buses have all of the same attributes and methods as our bus class, but they also have additional 
#   attributes and methods like the number of refrigerators, window blinds that can be opened and closed, and smoke
#   machines that can be turned on and off. Instead of rewriting the entire bus class and then adding new attributes
#   and methods, it is possible for the party bus class to inherit all of the attributes and methods from the bus
#   class. In this framework of inheritance, we talk about the bus class as the super-class of the party bus, and the
#   party bus is the sub-class of the bus. What this relationship means is that the party bus has all of the same 
#   attributes and methods as the bus class plus additional attributes and methods.

######################################################################################################################
### S3
######################################################################################################################

#Conveniently everything in R is an object. By “everything” I mean every single “thing” in R including numbers, functions, strings, data frames, lists, etc. If you want to know the class of an object in R you can simply use the class() function:


1
2
3
4
5
6
class(2)
[1] "numeric"
class("is in session.")
[1] "character"
class(class)
[1] "function"
Now it’s time to wade into some of the quirks of R’s object oriented systems. In the S3 system you can arbitrarily assign a class to any object, which goes against most of what we discussed in the Object Oriented Principles section. Class assignments can be made using thestructure() function, or you can assign the class using class()and <-:
  
  
  1
2
3
4
5
6
7
8
9
10
special_num_1 <- structure(1, class = "special_number")
class(special_num_1)
[1] "special_number"
special_num_2 <- 2
class(special_num_2)
[1] "numeric"
class(special_num_2) <- "special_number"
class(special_num_2)
[1] "special_number"
This is completely legal R code, but if you want to have a better behaved S3 class you should create a constructor which returns an S3 object. The shape_S3() function below is a constructor that returns a shape_S3 object:
  
  
  1
2
3
4
5
6
7
8
9
10
11
shape_s3 <- function(side_lengths){
  structure(list(side_lengths = side_lengths), class = "shape_S3")
}
square_4 <- shape_s3(c(4, 4, 4, 4))
class(square_4)
[1] "shape_S3"
triangle_3 <- shape_s3(c(3, 3, 3))
class(triangle_3)
[1] "shape_S3"
We’ve now made two shape_S3 objects: square_4 and triangle_3, which are both instantiations of the shape_S3 class. Imagine that you wanted to create a method that would return TRUE if a shape_S3 object was a square, FALSE if a shape_S3 object was not a square, and NA if the object provided as an argument to the method was not a shape_s3 object. This can be achieved using R’s generic methods system. A generic method can return different values based depending on the class of its input. For examplemean() is a generic method that can find the average of a vector of number or it can find the “average day” from a vector of dates. The following snippet demonstrates this behavior:
  
  
  1
2
3
4
mean(c(2, 3, 7))
[1] 4
mean(c(as.Date("2016-09-01"), as.Date("2016-09-03")))
[1] "2016-09-02"
Now let’s create a generic method for identifying shape_S3 objects that are squares. The creation of every generic method uses theUseMethod() function in the following way with only slight variations:
  
  
  1
[name of method] <- function(x) UseMethod("[name of method]")
Let’s call this method is_square:
  
  
  1
is_square <- function(x) UseMethod("is_square")
Now we can add the actual function definition for detecting whether or not a shape is a square by specifying is_square.shape_S3. By putting a dot (.) and then the name of the class after is_squre, we can create a method that associates is_squre with the shape_S3class:
  
  
  1
2
3
4
5
6
7
8
9
10
11
is_square.shape_S3 <- function(x){
  length(x$side_lengths) == 4 &&
    x$side_lengths[1] == x$side_lengths[2] &&
    x$side_lengths[2] == x$side_lengths[3] &&
    x$side_lengths[3] == x$side_lengths[4]
}
is_square(square_4)
[1] TRUE
is_square(triangle_3)
[1] FALSE
Seems to be working well! We also want is_square() to return NAwhen its argument is not a shape_S3. We can specifyis_square.default as a last resort if there is not method associated with the object passed to is_square().


1
2
3
4
5
6
7
8
is_square.default <- function(x){
  NA
}
is_square("square")
[1] NA
is_square(c(1, 1, 1, 1))
[1] NA
Let’s try printing square_4:
  
  
  1
2
3
4
5
6
print(square_4)
$side_lengths
[1] 4 4 4 4
attr(,"class")
[1] "shape_S3"
Doesn’t that look ugly? Lucky for us print() is a generic method, so we can specify a print method for the shape_S3 class:
  
  
  1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
print.shape_S3 <- function(x){
  if(length(x$side_lengths) == 3){
    paste("A triangle with side lengths of", x$side_lengths[1], 
          x$side_lengths[2], "and", x$side_lengths[3])
  } else if(length(x$side_lengths) == 4) {
    if(is_square(x)){
      paste("A square with four sides of length", x$side_lengths[1])
    } else {
      paste("A quadrilateral with side lengths of", x$side_lengths[1],
            x$side_lengths[2], x$side_lengths[3], "and", x$side_lengths[4])
    }
  } else {
    paste("A shape with", length(x$side_lengths), "slides.")
  }
}
print(square_4)
[1] "A square with four sides of length 4"
print(triangle_3)
[1] "A triangle with side lengths of 3 3 and 3"
print(shape_s3(c(10, 10, 20, 20, 15)))
[1] "A shape with 5 slides."
print(shape_s3(c(2, 3, 4, 5)))
[1] "A quadrilateral with side lengths of 2 3 4 and 5"
Since printing an object to the console is one of the most common things to do in R, nearly every class has an assocaited print method! To see all of the methods associated with a generic like print() use the methods() function:
  
  
  1
2
3
4
5
6
head(methods(print), 10)
[1] "print,ANY-method"            "print,diagonalMatrix-method"
[3] "print,sparseMatrix-method"   "print.acf"                  
[5] "print.AES"                   "print.anova"                
[7] "print.anova.gam"             "print.anova.lme"            
[9] "print.aov"                   "print.aovlist"              
One last note on S3 with regard to inheritance. In the previous section we discussed how a sub-class can inherit attributes and methods from a super-class. Since you can assign any class to an object in S3, you can specify a super class for an object the same way you would specify a class for an object:
  
  
  1
2
3
4
5
class(square_4)
[1] "shape_S3"
class(square_4) <- c("shape_S3", "square")
class(square_4)
[1] "shape_S3" "square"  
To check if an object is a sub-class of a specified class you can use the inherits() function:

