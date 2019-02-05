setwd("E:/masterarbeit")
task_data <-read.table("df.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
require(plyr)
info <- ddply(task_data, c("Teil"), summarise,
                      sum = sum(CNC.Length))
table(task_data$Teil,task_data$CNC.Length,exclude = NULL,task_data$Article)
table(task_data$Teil,task_data$CNC.Length,exclude = NULL)