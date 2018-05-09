######################################################################################################################
### Author: Anni Norring                                                                                           ###
### Date: May 2018 						                                                                                     ###
### Content: This script contains the R code for the final assignment of Advanced R programming course             ###
######################################################################################################################

# Access all the needed libraries:



######################################################################################################################
### PART 2: LONGITUDINAL DATA CLASS AND METHODS
#####################################################################################################################

library(dplyr)
library(tidyr)

LongitudinalData <- function(df) {
  structure(list(df = df), class = "LongitudinalData")
}

make_LD <- function(df) UseMethod("make_LD")

make_LD <- function(df) {
  LongitudinalData(df)
}

subject <- function(x, subj_index) {
  subj_df <- filter(x$df, id == subj_index)
  structure(list(id = subj_df$id[1], subj_df = subj_df), class = "subject")
}

print.subject <- function(s) {
  cat("Subject ID:", s$id)
}

summary.subject <- function(s) {
  structure(list(s = s), class="subjectSummary")
}

print.subjectSummary <- function(ss) {
  summary_df <- ss$s$subj_df %>% group_by(visit, room) %>% select(visit, room, value) %>% summarize(value=mean(value)) %>% spread(room, value)
  print(paste("ID:", ss$s$id))
  print(summary_df)
}

visit <- function(s, visit_index) {
  structure(list(subj = s, visit_df = filter(s$subj_df, visit == visit_index), visit_index = visit_index), class = "visit")
}

room <- function(v, room_type) {
  structure(list(visit = v, room_df = filter(v$visit_df, room == room_type), room_type = room_type), class = "room")
}

print.room <- function(r) {
  print(paste("ID:", r$v$subj$id))
  print(paste("Visit:", r$v$visit_index))
  print(paste("Room:", r$room_type))
}

summary.room <- function(r) {
  structure(list(r = r), class="roomSummary")
}

print.roomSummary <- function(rs) {
  print(paste("ID:", rs$r$v$subj$id))
  print(paste("Visit:", rs$r$v$visit_index))
  print(paste("Room:", rs$r$room_type))
  print(summary(rs$r$room_df$value))
}




#create a new class for representing longitudinal data

#design a class called “LongitudinalData” that characterizes the structure of this longitudinal dataset 

#design classes to represent the concept of a “subject”, a “visit”, and a “room”

#implement the following functions
#     1. make_LD: a function that converts a data frame into a “LongitudinalData” object
#     2. subject: a generic function for extracting subject-specific information
#     3. visit: a generic function for extracting visit-specific information
#     4. room: a generic function for extracting room-specific information

#For each generic/class combination you will need to implement a method, although not all combinations are 
#   necessary (see below). You will also need to write print and summary methods for some classes (again, see below).
