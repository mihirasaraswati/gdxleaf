hist(as.numeric(us.map$TotX),
     breaks = 10,
     col = "red",
     border = NA,
     main = NA, 
     xlab = "mnky",
     lty=1,
     lwd=NA)


library(ggplot2)

hg.theme <- theme(text=element_text(color="grey25"),
                  axis.ticks.y=element_blank(),
                  axis.ticks.x=element_line(color="grey25"),
                  axis.text.y=element_text(size=12, vjust=0.25),
                  axis.text.x=element_text(size=12, hjust=0.5),
                  axis.title.y=element_text(size=12, vjust=2.5),
                  axis.title.x=element_text(size=12, vjust=-1.5), 
                  panel.grid.major.y=element_line(size=0.5, linetype=3, color="grey25"),
                  panel.grid.major.x=element_blank(),
                  panel.grid.minor=element_blank(),
                  panel.border=element_rect(linetype=0),
                  panel.background=element_rect(fill="#FFFFF0"),
                  plot.margin=unit(c(0.1, 0.15, 0.1, 0.1), "inches"),
                  plot.title=element_text(color="black", face="bold", size=20, hjust=0, vjust=3)
)

ggplot2::qplot(x = us.map$MedCare[!is.na(us.map$MedCare)],
      geom = "histogram",
      bins=15, 
      main = NULL,
      xlab = "mnky"
      ) +
  #custom y-axis
  scale_y_continuous(name = "No. of Counties (in 00s)",
                     breaks = seq(0, 3200, 200),
                     labels = seq(0, 32, 2),
                     limits = c(0,3220)) +
  #apply blank theme
  theme_bw() +
  #apply custom theme
  hg.theme