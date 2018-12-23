setwd("C:/Users/kole021/git/CNC/")
ps_lab_data <-read.table("df_nouns_and_all_words_counts_whole_corpus.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
#head(ps_lab_data)
ps_lab_data$NounsToWords <- ps_lab_data$NounsN/ps_lab_data$WordsN
ps_lab_data$CNCtoNouns <- ps_lab_data$CNCsNounsN/ps_lab_data$NounsN
#ps_lab_data_critical <- ps_lab_data[ps_lab_data$block_no!=1, ] #remove practice (block 1)
#ps_lab_data_critical$window_size<-factor(ps_lab_data_critical$window_size, levels=c("5", "7", "9", "11","13", "NW")) #to set the levels
#ps_lab_data_critical$L1 <- ifelse(grepl("^u",ps_lab_data_critical$RECORDING_SESSION_LABEL), "U", "H")

##install.packages("multcomp")
##library(multcomp)
##install.packages("lme4")
##require(lme4)

hist(ps_lab_data$NounsToWords)
subI<-subset(ps_lab_data, Teil=="<Intro>")
subM<-subset(ps_lab_data, Teil=="<Middle>")
subC<-subset(ps_lab_data, Teil=="<Conclusion>")
hist(subI$NounsToWords)
hist(subM$NounsToWords)
hist(subC$NounsToWords)

plot(subM$NounsToWords)

topn = function(vector, n){
  maxs=c()
  ind=c()
  for (i in 1:n){
    biggest=match(max(vector), vector)
    ind[i]=biggest
    maxs[i]=max(vector)
    vector=vector[-biggest]
  }
  mat=cbind(maxs, ind)
  return(mat)
}
bottomn = function(vector, n){
  mins=c()
  ind=c()
  for (i in 1:n){
    smallest=match(min(vector), vector)
    ind[i]=smallest
    mins[i]=min(vector)
    vector=vector[-smallest]
  }
  mat=cbind(mins, ind)
  return(mat)
}


acc <- ps_lab_data_critical[ps_lab_data_critical$accuracy == c("0","1"),]
xx<-table(ps_lab_data$WordsN)
prop.table(xx)


install.packages("psych")
library(psych)
describe(ps_lab_data)

#install.packages("dplyr") 
library(dplyr)

#######not useful..#####
p <- summary(ps_lab_data %>% 
  select(WordsN, NounsN, Subcorpus, Teil))
pivot <- ps_lab_data %>%
  select(Subcorpus, Teil, WordsN, NounsN, NounsToWords, CNCtoNouns, CNCsNounsN) %>%
  group_by (Subcorpus, Teil) %>%
  summarise(MeanWordsN = mean(WordsN),
            #SDWordsN = sd(WordsN),
            #seWordsN = SDWordsN/sqrt(length(WordsN)),
            MeanNounsN = mean(NounsN),
            MeanNounsToWords = mean(NounsToWords, na.rm = TRUE),
            MeanCNCtoNouns = mean(CNCtoNouns, na.rm = TRUE),
            CNCstoWords = mean(WordsN,na.rm = TRUE)/mean(CNCsNounsN,na.rm = TRUE))

#For normally distributed data the standard deviation has some extra information, namely the 68-95-99.7 rule which tells us the percentage of data lying within 1, 2 or 3 standard deviation from the mean.
shapiro.test(ps_lab_data$NounsN)
shapiro.test(ps_lab_data$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Intro>", ]$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Middle>", ]$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Conclusion>", ]$WordsN)

shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Intro>", ]$NounsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Middle>", ]$NounsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Conclusion>", ]$NounsN)

shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Intro>", ]$NounsToWords)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Middle>", ]$NounsToWords)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Conclusion>", ]$NounsToWords)


######useful again#####
#install.packages("ggplot2")
require(ggplot2)
qplot(REACTION_TIME, window_size, data = ps_lab_data) + facet_grid(.~Teil)

qplot(REACTION_TIME, window_size, data = ps_lab_data_critical) + facet_grid(.~L1)
qplot(REACTION_TIME, window_size, data = ps_lab_data_critical) + facet_grid(L1~.)
qplot(reading_rate, L1, data = ps_lab_data_critical) + xlim (0, 500) + facet_grid(window_size~.)
qplot(reading_rate, L1, color = factor(L1), data = ps_lab_data_critical, geom = c("boxplot", "jitter")) + xlim (0, 500) + facet_grid(window_size~.) + scale_colour_manual(values = c("#E69F00", "#56B4E9")) 

########show two distributions on one plot#########
set.seed(42)
hH <- hist(ps_lab_data_critical[ps_lab_data_critical$L1 == "H",]$reading_rate)
hU <- hist(ps_lab_data_critical[ps_lab_data_critical$L1 == "U",]$reading_rate)
plot( hH, col=rgb(0,0,1,1/4), xlim=c(0,max(ps_lab_data_critical[ps_lab_data_critical$L1 == "H",]$reading_rate)), main = "Reading rates", xlab = "Words per minute")  # first histogram
plot( hU, col=rgb(1,0,0,1/4), xlim=c(0,max(ps_lab_data_critical[ps_lab_data_critical$L1 == "U",]$reading_rate)), add=T)  # second
