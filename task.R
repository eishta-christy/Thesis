setwd("E:/lab rotation linguistics/last 29")
task_data <-read.table("self_paced.csv", quote = "", fill = TRUE, header = TRUE, sep = ",")
task_data$condition<-ifelse((task_data$X.Object_Gender.=="\"match\"")&(task_data$X.Subject_Gender.=="\"match\""), 1, 
                            ifelse((task_data$X.Subject_Gender.=="\"match\"")&(task_data$X.Object_Gender.=="\"mis\""),2,
                                   ifelse((task_data$X.Subject_Gender.=="\"mis\"")&(task_data$X.Object_Gender.=="\"match\""),3,4)))
#task_data$condition<-ifelse((task_data$X.Object_Gender.=="\"mismatch\"")&(task_data$X.Subject_Gender.=="\"mismatch\""), 4, 0)
require(plyr)
SDs_original <- ddply(task_data, c("X.Subject_Gender.", "X.Object_Gender."), summarise,
             mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
             sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))
SDs_original_with_gender <- ddply(task_data, c("X.Subject_Gender.", "X.Object_Gender.", "X.Gender."), summarise,
                      mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
                      sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))

SDs_only_condition <- ddply(task_data, "condition", summarise,
             mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
             sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))
SDs <- ddply(task_data, c("X.Gender.", "condition"), summarise,
             mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
             sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))
SDs_ohne_gender <- ddply(task_data, "condition", summarise,
             mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
             sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))

#####use this if wanna rid out of outliers#####
data_critical <- data.frame()

for (i in 1:8) {
  temp_data <- task_data[(task_data$X.ReadTimes.< SDs[i,3]+2.5*SDs[i,4])
                                         &(task_data$X.Gender.==SDs[i,1])
                                         &(task_data$condition==SDs[i,2]),]
  data_critical <- rbind(data_critical,temp_data)
}

#####weiter#####
SDs_crit <- ddply(data_critical, c("X.Gender.", "condition"), summarise,
                  mean = mean(X.ReadTimes.), sd = sd(X.ReadTimes.),
                  sem = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)))
hist(data_critical$X.ReadTimes.)
plot(data_critical$X.ReadTimes.)
SDs[1,3]
library(dplyr) #https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html


######summaries for genders anf hists######
F1 <- summary(data_critical %>% 
               filter(condition==4) %>%
               filter(X.Gender.=="\"F\"")%>%
               select(X.ReadTimes.))
F1
M1 <- summary(data_critical %>% 
               filter(condition==4) %>%
               filter(X.Gender.=="\"M\"")%>%
               select(X.ReadTimes.))
M1
require(ggplot2)

set.seed(42)
hF <- hist(data_critical[data_critical$X.Gender. == "\"F\"",]$X.ReadTimes.)
hM <- hist(data_critical[data_critical$X.Gender. == "\"M\"",]$X.ReadTimes.)
plot( hF, col=rgb(0,0,1,1/4), xlim=c(0,max(data_critical[data_critical$X.Gender. == "\"F\"",]$X.ReadTimes.)), main = "Reading rates", xlab = "Words per minute")  # first histogram
plot( hM, col=rgb(1,0,0,1/4), xlim=c(0,max(data_critical[data_critical$X.Gender. == "\"M\"",]$X.ReadTimes.)), add=T)  # second
legend('topright',c('Female','Male'),
       fill = rgb(1:0,0,0:1,0.4), bty = 'n',
       border = NA)

set.seed(42)
h1 <- hist(data_critical[data_critical$condition == 1,]$X.ReadTimes.)
h2 <- hist(data_critical[data_critical$condition == 2,]$X.ReadTimes.)
h3 <- hist(data_critical[data_critical$condition == 3,]$X.ReadTimes.)
h4 <- hist(data_critical[data_critical$condition == 4,]$X.ReadTimes.)
plot( h1, col=rgb(0,0,1,1/4), xlim=c(0,max(data_critical[data_critical$condition == 1,]$X.ReadTimes.)), main = "Reading rates", xlab = "Words per minute", panel.first = grid())  # first histogram
plot( h2, col=rgb(1,0,0,1/4), xlim=c(0,max(data_critical[data_critical$condition == 2,]$X.ReadTimes.)), add=T)  # first histogram
plot( h3, col=rgb(0,1,0,1/4), xlim=c(0,max(data_critical[data_critical$condition == 3,]$X.ReadTimes.)), add=T)  # first histogram
plot( h4, col=rgb(0,1,1,1/4), xlim=c(0,max(data_critical[data_critical$condition == 4,]$X.ReadTimes.)), add=T)  # first histogram
legend('topright',c('c1','c2', 'c3', 'c4'),
       fill = rgb(1:0,0,0:1,0.4), bty = 'n',
       border = NA)



lexfreqbylang <- ddply(data_critical, .(condition, X.Gender.), summarise,
                       M = mean(X.ReadTimes.),
                       SD = sd(X.ReadTimes.),
                       SE = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)),
                       N = length(X.ReadTimes.))
two_lines<- qplot(data = lexfreqbylang, x = condition, y = M, group = X.Gender., colour = X.Gender., geom=c("line")) + 
  #geom_errorbar(aes(ymax = M + CI, ymin = M - CI), width=.1)+
  xlab("Condition") +
  ylab("reading rate") +
  ggtitle("Reading rates at diff cond-s")
#facet_wrap(~agegroup)
two_lines

lexfreqbylang <- ddply(data_critical, .(condition, X.Gender.), summarise,
                       M = mean(X.ReadTimes.),
                       SD = sd(X.ReadTimes.),
                       SE = sd(X.ReadTimes.)/sqrt(length(X.ReadTimes.)),
                       N = length(X.ReadTimes.))
two_lines<- qplot(data = lexfreqbylang, x = condition, y = M, group = X.Gender., colour = X.Gender., geom=c("point")) + 
  #geom_errorbar(aes(ymax = M + CI, ymin = M - CI), width=.1)+
  xlab("Condition") +
  ylab("reading rate") +
  ggtitle("Reading rates at diff cond-s")
#facet_wrap(~agegroup)
two_lines

#####graph preps#####
df = aggregate(list(y = data_critical$X.ReadTimes.),list(x = data_critical$condition),mean)
df1 = aggregate(list(se = data_critical$X.ReadTimes.),list(x = data_critical$condition),
                FUN = function(x){1.96*(sd(x)/sqrt(length(x)))})
df$se = df1$se
df$x <- factor(df$x, levels=c("1","2","3","4"))
df[] <- lapply(df, as.numeric)

df_out = aggregate(list(y = task_data$X.ReadTimes.),list(x = task_data$condition),mean)
df1_out = aggregate(list(se = task_data$X.ReadTimes.),list(x = task_data$condition),
                FUN = function(x){1.96*(sd(x)/sqrt(length(x)))})
df_out$se = df1_out$se
df_out$x <- factor(df_out$x, levels=c("1","2","3","4"))
df_out[] <- lapply(df_out, as.numeric)


df_m = aggregate(list(y = task_data$X.ReadTimes.),list(x = task_data$X.Subject_Gender),mean)
df1_m = aggregate(list(se = task_data$X.ReadTimes.),list(x = task_data$X.Subject_Gender),
                FUN = function(x){1.96*(sd(x)/sqrt(length(x)))})
#####graphs not dividing the genders######
require(ggthemes)
kh_m <- ggplot(data = SDs_original,aes(x=X.Subject_Gender.,y=mean, fill=X.Object_Gender.))+ #geom_path(colour = "#9999CC")+
  geom_bar(stat = "identity", width=0.7, position=position_dodge()) +
  geom_text(aes(label=signif(mean, digits = 3)), vjust=0, hjust = 0.5, size=3.5)+
  scale_fill_hue(name="Inaccessible") +
  ylab("Reading time at the critical word (ms)") +
  xlab("Accessible") +
  geom_errorbar(aes(ymax = mean+sem, ymin = mean-sem,x=X.Subject_Gender.), width = .25, color = "#9999CC",  position=position_dodge(.9))+
  #theme_few()
  theme_gdocs()
  #theme_pander()
  #theme_economist_white(gray_bg=TRUE) + scale_colour_economist()
#theme_wsj()

kh_m

theme_set(theme_classic())
kh <- ggplot(df,aes(x=x, y=y), group=1)+ geom_path(colour = "#9999CC")+
  geom_point() +
  geom_errorbar(aes(ymax = y+se, ymin = y-se,x=x), width = .25, color = "#9999CC") +
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +  
  theme_linedraw() +
  theme_light() +
  theme_solarized_2() +
  geom_text(aes(label=y),hjust=0, vjust=0)+
  scale_x_continuous(
    breaks = c(1, 2, 3,4),
    label = c("Match-Match","Match-Mismatch","Mismatch-Match","Mismatch-Mismatch")
  )

kh #graph with outliers deleted
kh_out <- ggplot(df_out,aes(x=x, y=y), group=1)+ geom_path(colour = "#9999CC")+
  geom_point() +
  geom_errorbar(aes(ymax = y+se, ymin = y-se,x=x), width = .25, color = "#9999CC") +
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +  
  theme_linedraw() +
  theme_light() +
  theme_solarized_2() +
  geom_text(aes(label=y),hjust=0, vjust=0)+
  scale_x_continuous(
    breaks = c(1, 2, 3,4),
    label = c("Match-Match","Match-Mismatch","Mismatch-Match","Mismatch-Mismatch")
  )

kh_out#graph with outliers not excluded

######graphs without no extra condition column######


data_critical_F <- data_critical[data_critical$X.Gender.=="\"F\"", ] 
data_critical_M <- data_critical[data_critical$X.Gender.=="\"M\"", ] 
#####statistical model######

model_RR<-lmer(X.ReadTimes. ~condition*X.Gender. + (1|X.Subj.) + (1|X.Item.), data=data_critical, REML=FALSE)
summary(model_RR)
anova(model_RR)
oranges.rg1 <- ref_grid(model_RR)
lsmeans(model_RR, "condition", by = "X.Gender.")
lsm <- ls_means(model_RR)
show_tests(lsm)
require(lsmeans)
library(emmeans)
require(lmerTest)
lsmeans(model_RR, ~condition*X.Gender., adjust = "tukey")

l = pairs(lsmeans(model_RR, ~X.Gender.*condition, adjust = "tukey"))
l
######graphs dividing into genders######
dFemale = aggregate(list(y = data_critical_F$X.ReadTimes.),list(x = data_critical_F$condition),mean)
dMale = aggregate(list(y = data_critical_M$X.ReadTimes.),list(x = data_critical_M$condition),mean)
plot_wg <- ggplot(data=dFemale, aes(x=x, y=y, label=y), group=1)+ geom_point(color="red")+geom_line(data =dFemale, color = "red")+geom_label(aes(label=y),hjust=0, vjust=0)#+geom_text(aes(label=y),hjust=0, vjust=0) 
plot_wg <- plot_wg + geom_point(data =dMale,aes(x=x, y=y, label=y), color="blue", group=1)+ geom_path(data =dMale, color = "blue")+
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +  
  theme_linedraw() +
  theme_light() +
  theme_solarized_2() +
  #geom_text(data =dMale,aes(label=y),hjust=0, vjust=0)+
  geom_label(data =dMale,aes(label=y),hjust=0, vjust=0)+
  scale_x_continuous(
    breaks = c(1, 2, 3,4),
    label = c("Match-Match","Match-Mismatch","Mismatch-Match","Mismatch-Mismatch")
  )
plot_wg #graph with outliers deleted

aggdata <-aggregate(data=task_data, X.ReadTimes. ~ condition*X.Gender.,FUN=mean, na.rm=TRUE)
aggdata1 = aggregate(list(se = task_data$X.ReadTimes.),list(x = data_critical$condition),
                FUN = function(x){1.96*(sd(x)/sqrt(length(x)))})
df$se = df1$se
df$x <- factor(df$x, levels=c("1","2","3","4"))
df[] <- lapply(df, as.numeric)


plot_wg_allinone <- ggplot(data=aggdata, aes(x=condition, y=X.ReadTimes.,colour = factor(X.Gender.,labels =c("Female participants", "Male participants"))), label="X.ReadTimes.", group=1)+
  geom_point()+
  #geom_point(aes(colour = factor(X.Gender.)), labels =c("Female participants", "Male participants"))+
  geom_line()+
  labs(colour = "Gender")+
  geom_label(aes(label=signif(X.ReadTimes., digits = 3)),hjust=0, vjust=0)+
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +
  theme_light() +
  theme_solarized_2() +
  scale_x_continuous(
    breaks = c(1, 2, 3,4),
    label = c("Match-Match","Match-Mismatch","Mismatch-Match","Mismatch-Mismatch")
  )
plot_wg_allinone #graph with outliers not excluded

plot_all_data <- ggplot(data=SDs, aes(x=condition, y=mean,colour = factor(X.Gender.,labels =c("Female participants", "Male participants"))), label="X.ReadTimes.", group=1)+
  geom_point()+
  #geom_point(aes(colour = factor(X.Gender.)), labels =c("Female participants", "Male participants"))+
  geom_line()+
  labs(colour = "Gender")+
  geom_label(aes(label=signif(mean, digits = 3)),hjust=0, vjust=0)+
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +
  #theme_economist() + scale_colour_economist()+
  theme_wsj() +
  xlab("Condition") +
  ylab("Reading time at the critical word (ms)") +
  geom_errorbar(aes(ymax = mean+sem, ymin = mean-sem,x=condition), width = .25, color = "#9999CC") +
  scale_x_continuous(
    breaks = c(1, 2, 3,4),
    label = c("Match-Match","Match-Mismatch","Mismatch-Match","Mismatch-Mismatch")
  )
plot_all_data #graph with outliers not excluded

