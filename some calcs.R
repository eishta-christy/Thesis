setwd("C:/Users/kole021/git/Thesis/")
####reading the data####
ps_lab_data_58each <-read.table("df_nouns_and_all_words_counts_whole_corpus_58each.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
ps_lab_data_58each$NounsToWords <- ps_lab_data_58each$NounsN/ps_lab_data_58each$WordsN*1000
ps_lab_data_58each$CNCtoNouns <- ps_lab_data_58each$CNCsNounsN/ps_lab_data_58each$NounsN*1000
#ps_lab_data_58each$CNCtoWords
ps_lab_data_all <-read.table("df_nouns_and_all_words_counts_whole_corpus_all.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
ps_lab_data_all$NounsToWords <- ps_lab_data_all$NounsN/ps_lab_data_all$WordsN
ps_lab_data_all$CNCtoNouns <- ps_lab_data_all$CNCsNounsN/ps_lab_data_all$NounsN
ps_lab_data_equal_words <-read.table("df_nouns_and_all_words_counts_whole_corpus_equal_words.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
ps_lab_data_equal_words$NounsToWords <- ps_lab_data_equal_words$NounsN/ps_lab_data_equal_words$WordsN
ps_lab_data_equal_words$CNCtoNouns <- ps_lab_data_equal_words$CNCsNounsN/ps_lab_data_equal_words$NounsN


####smth####

hist(ps_lab_data$NounsToWords)
subE<-subset(ps_lab_data_58each, Subcorpus=="economics_intros")
subB<-subset(ps_lab_data_58each, Subcorpus=="biology_intros")
subL<-subset(ps_lab_data_58each, Subcorpus=="linguistics_intros")
hist(subI$NounsToWords)
hist(subM$NounsToWords)
hist(subC$NounsToWords)

plot(subM$NounsToWords)
####installing packages####
install.packages("psych")
library(psych)
describe(ps_lab_data_58each)

#install.packages("dplyr") 
library(dplyr)

#######pivots#####
p_58each <- summary(ps_lab_data_58each %>% 
  select(WordsN, NounsN, Subcorpus, Teil))
pivot_58each <- ps_lab_data_58each %>%
  select(Subcorpus, Teil, WordsN, NounsN, NounsToWords, CNCtoNouns, CNCsNounsN) %>%
  group_by (Subcorpus, Teil) %>%
  summarise(MeanWordsN = mean(WordsN),
            #SDWordsN = sd(WordsN),
            #seWordsN = SDWordsN/sqrt(length(WordsN)),
            MeanNounsN = mean(NounsN),
            MeanNounsToWords = mean(NounsToWords, na.rm = TRUE),
            MeanCNCtoNouns = mean(CNCtoNouns, na.rm = TRUE),
            CNCstoWords = mean(CNCsNounsN,na.rm = TRUE)/mean(WordsN,na.rm = TRUE))

pivot2_58each <- ps_lab_data_58each %>%
  select(Subcorpus, WordsN) %>%
  group_by (Subcorpus) %>%
  summarise(SumWordsN = sum(WordsN))


p_all <- summary(ps_lab_data_all %>% 
                      select(WordsN, NounsN, Subcorpus, Teil))
pivot_all <- ps_lab_data_all %>%
  select(Subcorpus, Teil, WordsN, NounsN, NounsToWords, CNCtoNouns, CNCsNounsN) %>%
  group_by (Subcorpus, Teil) %>%
  summarise(MeanWordsN = mean(WordsN),
            #SDWordsN = sd(WordsN),
            #seWordsN = SDWordsN/sqrt(length(WordsN)),
            MeanNounsN = mean(NounsN),
            MeanNounsToWords = mean(NounsToWords, na.rm = TRUE),
            MeanCNCtoNouns = mean(CNCtoNouns, na.rm = TRUE),
            CNCstoWords = mean(CNCsNounsN,na.rm = TRUE)/mean(WordsN,na.rm = TRUE))

pivot2_all <- ps_lab_data_all %>%
  select(Subcorpus, WordsN) %>%
  group_by (Subcorpus) %>%
  summarise(SumWordsN = sum(WordsN))


p_equal_words <- summary(ps_lab_data_equal_words %>% 
                   select(WordsN, NounsN, Subcorpus, Teil))
pivot_equal_words <- ps_lab_data_equal_words %>%
  select(Subcorpus, Teil, WordsN, NounsN, NounsToWords, CNCtoNouns, CNCsNounsN) %>%
  group_by (Subcorpus, Teil) %>%
  summarise(MeanWordsN = mean(WordsN),
            #SDWordsN = sd(WordsN),
            #seWordsN = SDWordsN/sqrt(length(WordsN)),
            MeanNounsN = mean(NounsN),
            MeanNounsToWords = mean(NounsToWords, na.rm = TRUE),
            MeanCNCtoNouns = mean(CNCtoNouns, na.rm = TRUE),
            CNCstoWords = mean(CNCsNounsN,na.rm = TRUE)/mean(WordsN,na.rm = TRUE))

pivot2_equal_words <- ps_lab_data_equal_words %>%
  select(Subcorpus, WordsN) %>%
  group_by (Subcorpus) %>%
  summarise(SumWordsN = sum(WordsN))
########For normally distributed data the standard deviation has some extra information, namely the 68-95-99.7 rule which tells us the percentage of data lying within 1, 2 or 3 standard deviation from the mean.#####
shapiro.test(ps_lab_data_58each$NounsN)
shapiro.test(ps_lab_data$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Intro>", ]$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Middle>", ]$WordsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Conclusion>", ]$WordsN)

shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Intro>", ]$NounsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Middle>", ]$NounsN)
shapiro.test(ps_lab_data[ps_lab_data$Teil == "<Conclusion>", ]$NounsN)

shapiro.test(ps_lab_data_58each$NounsToWords)
shapiro.test(ps_lab_data_58each[ps_lab_data_58each$Subcorpus == "biology_intros", ]$NounsToWords)
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

####normality test####
library("dplyr")
library("ggpubr")
set.seed(1234)
#look at 10 random lines from the data
dplyr::sample_n(ps_lab_data_58each, 10)
#Density plot: the density plot provides a visual judgment about whether the distribution is bell shaped.
ggdensity(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "economics_intros"], 
          main = "Density plot of noun proportion",
          xlab = "Noun proportionh")
ggdensity(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "biology_intros"], 
          main = "Density plot of noun proportion",
          xlab = "Noun proportionh")
ggdensity(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "linguistics_intros"], 
          main = "Density plot of noun proportion",
          xlab = "Noun proportionh")
##Q-Q plot: Q-Q plot (or quantile-quantile plot) draws the correlation between a given sample and the normal distribution. A 45-degree reference line is also plotted.
ggqqplot(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "economics_intros"])

#shapiro test
##The null hypothesis of these tests is that "sample distribution is normal". If the test is significant, the distribution is non-normal.
shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "economics_intros"])
shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "biology_intros"])
shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Subcorpus == "linguistics_intros"])
shapiro.test(ps_lab_data_58each$CNCtoNouns[ps_lab_data_58each$Subcorpus == "economics_intros"])
shapiro.test(ps_lab_data_58each$CNCtoNouns[ps_lab_data_58each$Subcorpus == "biology_intros"])
shapiro.test(ps_lab_data_58each$CNCtoNouns[ps_lab_data_58each$Subcorpus == "linguistics_intros"])

shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Teil == "<Intro>"])
shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Teil == "<Conclusion>"])
shapiro.test(ps_lab_data_58each$NounsToWords[ps_lab_data_58each$Teil == "<Middle>"])
#all three test show that distibition is not non-normal
shapiro.test(ps_lab_data_58each$NounsToWords)
###but them all together are non-normal distributed!!
#####ANOVA#####
ps_lab_data_58each$Subcorpus <- ordered(ps_lab_data_58each$Subcorpus,
                         levels = c("economics_intros", "biology_intros", "linguistics_intros"))
ps_lab_data_58each$Teil <- ordered(ps_lab_data_58each$Teil,
                                        levels = c("<Intro>", "<Middle>", "<Conclusion>"))
library(dplyr)
group_by(ps_lab_data_58each, Subcorpus) %>%
  summarise(
    count = n(),
    mean = mean(NounsToWords, na.rm = TRUE),
    sd = sd(NounsToWords, na.rm = TRUE)
  )
# Compute the analysis of variance
res.aovNounsToWords <- aov(NounsToWords ~ Subcorpus, data = ps_lab_data_58each)
# Summary of the analysis
summary(res.aovNounsToWords)
TukeyHSD(res.aovNounsToWords)
res.aovCNCtoNouns <- aov(CNCtoNouns ~ Subcorpus, data = ps_lab_data_58each)
summary(res.aovCNCtoNouns)
TukeyHSD(res.aovCNCtoNouns)

res.aovPerTeil <- aov(NounsToWords ~ Subcorpus, data = ps_lab_data_58each)
summary(res.aovPerTeil)
TukeyHSD(res.aovPerTeil)

res.aovEFull <- aov(NounsToWords ~ Subcorpus*Teil, data = ps_lab_data_58each)
summary(res.aovEFull)
TukeyHSD((res.aovEFull))



#####ANOVAs for each sub-corpus####
res.aivEconomicsW <- aov(NounsToWords ~ Teil, data = subE)
summary(res.aivEconomicsW)
TukeyHSD((res.aivEconomicsW))

res.aivBW <- aov(NounsToWords ~ Teil, data = subB)
summary(res.aivBW)
TukeyHSD((res.aivBW))

res.aivLW <- aov(NounsToWords ~ Teil, data = subL)
summary(res.aivLW)
TukeyHSD((res.aivLW))

res.aivEconomics <- aov(CNCtoNouns ~ Teil, data = subE)
summary(res.aivEconomics)
TukeyHSD((res.aivEconomics))

res.aivB <- aov(CNCtoNouns ~ Teil, data = subB)
summary(res.aivB)
TukeyHSD((res.aivB))

res.aivL <- aov(CNCtoNouns ~ Teil, data = subL)
summary(res.aivL)
TukeyHSD((res.aivL))


#In one-way ANOVA test, a significant p-value indicates that some of the group means are different, but we don't know which pairs of groups are different.
#It's possible to perform multiple pairwise-comparison, to determine if the mean difference between specific pairs of group are statistically significant.
TukeyHSD(res.aovNounsToWords)
TukeyHSD(res.aovCNCtoNouns)
#diff: difference between means of the two groups
#lwr, upr: the lower and the upper end point of the confidence interval at 95% (default)
#p adj: p-value after adjustment for the multiple comparisons.


####graphs####
library(ggplot2)
ggboxplot(ps_lab_data_58each, x = "Subcorpus", y = "NounsToWords", 
          color = "Subcorpus", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("economics_intros", "biology_intros", "linguistics_intros"),
          ylab = "NounsToWords", xlab = "Subcorpus")
ggline(ps_lab_data_58each, x = "Subcorpus", y = "NounsToWords", 
       add = c("mean_se", "jitter"), 
       order = c("economics_intros", "biology_intros", "linguistics_intros"),
       ylab = "NounsToWords", xlab = "Subcorpus")
#####the best graphs so far####
boxplot(CNCtoNouns ~ Subcorpus*Teil, data = ps_lab_data_58each, notch=TRUE,
        xlab = "Subcorpus", ylab = "NounsToWords",
        #names=c("Economics", "Biology", "Linguistics"),
        frame = FALSE, col = c(rgb(0.8, 0.255, 0.255, 0.2), rgb(0.3, 0.8, 0.2, 0.2), rgb(0.2, 0.2, 0.7, 0.2)))
##this!!
boxplot(NounsToWords ~ Subcorpus*Teil, data = ps_lab_data_58each, notch=TRUE,
        xlab = "Part of article", ylab = "Nouns per 1000 words",
        names=c("", "Intro", "", "", "Middle", "", "", "Conclusion", ""),
        at =c(1,2,3, 6,7,8, 11,12,13), range = 1.5, ylim = c(0.2,0.4),
        order = c("economics_intros", "biology_intros", "linguistics_intros"),
        frame = FALSE, col = c(rgb(0.8, 0.255, 0.255, 0.2), rgb(0.3, 0.8, 0.2, 0.2), rgb(0.2, 0.2, 0.7, 0.2)))


legend("topright", title=" ", inset=-0.025,bg ="transparent", box.lty=0, cex = 0.6,
       c("Economics","Biology","Linguistics"), fill=c(rgb(0.8, 0.255, 0.255, 0.2), rgb(0.3, 0.8, 0.2, 0.2), rgb(0.2, 0.2, 0.7, 0.2)), horiz=TRUE)

boxplot(CNCtoNouns ~ Subcorpus, data = ps_lab_data_58each, notch=TRUE,
        xlab = "Subcorpus", ylab = "CNCtoNouns",
        names=c("Economics", "Biology", "Linguistics"),
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))
library("beanplot")
beanplot(CNCtoNouns ~ Subcorpus, data = ps_lab_data_58each, ll = 0.04, main = "beanplot",ylim = ylim, ylab = "body height (inch)")

beanplot(CNCtoNouns ~ Subcorpus*Teil, data = ps_lab_data_58each, col = c(rgb(0.8, 0.255, 0.255, 0.2), rgb(0.3, 0.8, 0.2, 0.2), rgb(0.2, 0.2, 0.7, 0.2)), ll = 0.04, main = "beanplot",ylim = ylim, ylab = "body height (inch)")

ps_lab_data_58each$Subcorpus <- factor(ps_lab_data_58each$Subcorpus, c("economics_intros", "biology_intros", "linguistics_intros"), labels = c("Economics", "Biology", "Linguistics"))
ps_lab_data_58each$Teil <- factor(ps_lab_data_58each$Teil, c("<Intro>", "<Middle>", "<Conclusion>"), labels = c("Introduction", "Middle part", "Conclusion"))
#####ggplot2 plotting#####
library(ggplot2)
p <- ggplot(ps_lab_data_58each, aes(x = Teil, y= NounsToWords, fill=Subcorpus))
p + geom_boxplot(notch = TRUE, outlier.colour = "black", outlier.shape = 1, outlier.alpha = 0.3) +
  scale_fill_manual(values= c(rgb(0.8, 0.255, 0.255, 0.3), rgb(0.3, 0.8, 0.2, 0.3), rgb(0.2, 0.2, 0.7, 0.3))) +
  scale_y_continuous(name = "Nouns per 1000 words",
                     breaks = seq(225, 375, 25),
                     limits=c(210, 380)) +
  #ggtitle("Do we need it here?")+
  theme_bw()+
  theme(text = element_text(size = 12, family = "Times"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11)) +
  scale_x_discrete(name = "Part of the article")
######TODO GRAPH#####
p2 <- ggplot(ps_lab_data_58each, aes(x = Teil, y= CNCtoNouns, fill=Subcorpus))
p2 + geom_boxplot(notch = FALSE, outlier.colour = "black", outlier.shape = 1, outlier.alpha = 0.3) +
  scale_fill_manual(values= c(rgb(0.8, 0.255, 0.255, 0.3), rgb(0.3, 0.8, 0.2, 0.3), rgb(0.2, 0.2, 0.7, 0.3))) +
  scale_y_continuous(name = "Nouns per 1000 words",
                     breaks = seq(5, 30, 2),
                     limits=c(5, 30)) +
  #ggtitle("Do we need it here?")+
  theme_bw()+
  theme(text = element_text(size = 12, family = "Times"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11)) +
  scale_x_discrete(name = "Part of the article")

######citationsss######
citations <- function(includeURL = TRUE, includeRStudio = TRUE) {
  if(includeRStudio == TRUE) {
    ref.rstudio <- RStudio.Version()$citation
    if(includeURL == FALSE) {
      ref.rstudio$url = NULL;
    }
    print(ref.rstudio, style = 'text')
    cat('\n')
  }
  
  cit.list <- c('base', names(sessionInfo()$otherPkgs))
  for(i in 1:length(cit.list)) {
    ref <- citation(cit.list[i])
    if(includeURL == FALSE) {
      ref$url = NULL;
    }
    print(ref, style = 'text')
    cat('\n')
  }
}



CNCs_E <-read.table("C:/Users/kole021/git/Thesis/economics_parts/economics_df1_58.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
table(CNCs_E$CNC.Length)
CNCs_B <-read.table("C:/Users/kole021/git/Thesis/biology_parts/df_biology.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
table(CNCs_B$CNC.Length)
CNCs_L <-read.table("C:/Users/kole021/git/Thesis/linguistics_parts/linguistics_df1.csv", quote = "", fill = TRUE, header = TRUE, sep = "\t")
table(CNCs_L$CNC.Length)
