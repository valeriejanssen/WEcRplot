
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

setwd("C:/Users/janss208/OneDrive - WageningenUR/janss208/WEcRplot/WEcRplot")

# Git libary
library(usethis)
#usethis::git_sitrep()
#usethis::create_github_token()
#install.packages("gitcreds")
#library(gitcreds)
#gitcreds::gitcreds_set()
#gitcreds::gitcreds_get()
usethis::use_git()
usethis::use_github()

#package dependecy libraries

pacman::p_load(
  devtools,
  usethis,
  roxygen2,
  testthat,
  knitr,
  rmarkdown
)


if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png',
               'grid', 'ggpubr', 'scales',
               'bbplot')


pacman::p_load(extrafont)

windowsFonts()

source("R/WEcR_style.R")
source("R/scale_fill_WEcR.R")
source("R/finalise_plot.R")
source("R/zzz.R")


line_df <- gapminder %>%
  dplyr::filter(country == "Malawi")


ggplot(line_df, aes(x = year, y = lifeExp)) +
  geom_line(colour = "#1380A1", size = 1) +
  geom_hline(yintercept = 0, size = 1, colour="#333333") +
  WEcR_style() +
  scale_fill_WEcR() +
  labs(title="Living longer",
       subtitle = "Life expectancy in Malawi 1952-2007")

#look at manually entered colours



stacked_df <- gapminder %>%
  dplyr::filter(year == 2007) %>%
  mutate(lifeExpGrouped = cut(lifeExp,
                              breaks = c(0, 50, 65, 80, 90),
                              labels = c("Under 50", "50-65", "65-80", "80+"))) %>%
  dplyr::group_by(continent, lifeExpGrouped) %>%
  dplyr::summarise(continentPop = sum(as.numeric(pop)))

#set order of stacks by changing factor levels
stacked_df$lifeExpGrouped = factor(stacked_df$lifeExpGrouped, levels = rev(levels(stacked_df$lifeExpGrouped)))


testgraph1 <- ggplot(data = stacked_df,
       aes(x = continent,
           y = continentPop,
           fill = lifeExpGrouped)) +
  geom_bar(stat = "identity",
           position = "fill") +
  WEcR_style() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_WEcR() +
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +
  labs(title = "How life expectancy varies",
       subtitle = "% of population by life expectancy band, 2007") +
  theme(legend.position = "top",
        legend.justification = "left") +
  guides(fill = guide_legend(reverse = TRUE))

testgraph1

finalise_plot(testgraph1, 'Source: Gapminder & BBCplot adapted for WEcR presentation use', 'WEcR_test_graph_1.png', 'WUR_FC_standard.png')



library("ggalt")
library("tidyr")

#Prepare data
dumbbell_df <- gapminder %>%
  filter(year == 1967 | year == 2007) %>%
  select(country, year, lifeExp) %>%
  spread(year, lifeExp) %>%
  mutate(gap = `2007` - `1967`) %>%
  arrange(desc(gap)) %>%
  head(10)

#Make plot
testgraph2 <-  ggplot(dumbbell_df, aes(x = `1967`, xend = `2007`, y = reorder(country, gap), group = country)) +
   geom_dumbbell(colour = "#dddddd",
                size = 3,
                colour_x = "#6AADE4",
                colour_xend = "#69BE28") +
  WEcR_style() +
  scale_fill_WEcR() +
  labs(title="We're living longer",
       subtitle="Biggest life expectancy rise, 1967-2007")

testgraph2

finalise_plot(testgraph2, 'Source: Gapminder & BBCplot adapted for WEcR presentation use', 'WEcR_test_graph_2.png')

facet <- gapminder %>%
  filter(continent != "Americas") %>%
  group_by(continent, year) %>%
  summarise(pop = sum(as.numeric(pop)))

facet_plot_free <-  ggplot() +
  geom_area(data = facet, aes(x = year, y = pop, fill = continent)) +
  facet_wrap(~ continent, scales = "free") +
  WEcR_style() +
  scale_fill_WEcR() +
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +
  theme(legend.position = "none",
        axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  labs(title = "It's all relative",
       subtitle = "Relative population growth by continent,1952-2007")

finalise_plot(facet_plot_free, 'Source: Gapminder & BBCplot adapted for WEcR presentation use', 'WEcR_test_graph_3.png')



#
# fonts()#
# .onLoad <- function(libname, pkgname) {
#   if (Sys.info()[1] == "Linux") {
#     dir.create('~/.fonts')
#     file.copy("inst/extdata/fonts/Verdana.ttf", "~/.fonts")
#     system('fc-cache -f ~/.fonts')
#   }
#   if (Sys.info()[1] == "Windows") {
#     windowsFonts()
#     extrafont::font_import(pattern = "Verdana", prompt = FALSE)
#     extrafont::loadfonts(device = "win")
#     windowsFonts()
#   }
#   print(extrafont::fonts())
# }
#

windowsFonts()
    extrafont::font_import(pattern = "Verdana", prompt = FALSE)
    extrafont::loadfonts(device = "win")
    windowsFonts()
