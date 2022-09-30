

################################################################################
##
##                      Data visualisation in R
##
################################################################################

## Introduction

# This training will introduce you to data visualisation in R. 
# By the end, you should be able to produce a range of charts, including adding some interactivity. 
# Note that you can find more useful information on ggplot2 functions in the ggplot cheatsheet 
# (https://www.rstudio.com/resources/cheatsheets/). 
# 
# **Note that this tutorial only covers the very basics of data visualisation using ggplot and there is a lot more to learn.**
#   
# We will be using a dataset containing economic data for European countries from 1995 to 2014. 
#
# The following code loads the libraries and imports the data, which is originally extracted from the OECD website:

library(tidyverse)
library(RColorBrewer)
library(ggthemes)

economic_data <- read_csv("https://raw.githubusercontent.com/drros84/euro_cluster_app/master/macro_dataset.csv") %>% 
  select(country = region, year = Year, GDP, wages = average_annual_wage, inflation = cpi, 
         productivity, unemployment = unemployment_rate, research_investment = GERD, govt_debt) %>% 
  na.omit() 

# EXERCISE

# Run a few lines of code below to explore the data:



################################################################################
## ggplot2 
################################################################################

# The plotting package from the tidyverse that we're going to use is **ggplot2**. 
# It was developed by Hadley Wickham (https://hadley.nz), who also led development of the rest of the **tidyverse** 
# group of packages. This is useful because it makes the two very compatible. 

# Additionally, **ggplot2** was developed on some solid data visualisation theory - in particular, it seeks to 
# implement Wilkinson's Grammar of Graphics (https://vita.had.co.nz/papers/layered-grammar.html) approach to data visualisation. 
# This means that it will generally force you to approach sound data visualisation principles.

# There are 3 key parts to a ggplot chart:
#   * data
#   * aesthetics - which scales to map the data onto
#   * geometries - how the plot will look

# You build up a plot by adding elements/layers.

# For example, in the chart below, using data for the top 10 countries with the highest GDP in 2014, 
# and we only define the **data** and **aesthetics** - but not the **geometries**. 
# As a result, all we see is an empty chart, but you can see the scale, with the corresponding axes, are already defined here:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = country, y = GDP))



################################################################################
## Geometries 
################################################################################

# In this section, we experiment with several geometries (shapes).

### Bar chart

# You can create a bar chart of spending by agency in 2020 using geom_col(). Notice that for ggplot, 
# we use + between each line rather than %>%:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = country, y = GDP)) +
  geom_col()

# Notice that the order is not particularly useful. 
# We can easily reorder it by decreasing order of ``values`` using the ``reorder()`` function:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col()


# EXERCISE

# Now, create a bar chart of ``wages`` per country, for the countries with top 10 highest wages in 2014. 
# As in the chart above, order the bar chart in decreasing order of ``wages``:










### Scatter plot

# We can use the ``geom_point`` to create a scatterplot. Below, we plot ``inflation`` against ``unemployment``, 
# with the colour for each country, in 2014:

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation)) +
  geom_point()


# We can see there is definitely a negative correlation between inflation and unemployment - interesting!
  
# To make that clear, we can also add a trendline to the chart:

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Additionally, we can change the size of the points is linked to the ``wages``:

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation, size = wages)) +
  geom_point() 


# EXERCISE

# Now, create a scatterplot of ``productivity`` against ``research_investment``, where size is 
# linked to ``wages``, for 2014. You do not need a trendline:









### Line chart

# Next, we draw a line chart of GDP over time for France using the ``geom_line()`` function:

economic_data %>% 
  filter(country == "France") %>% 
  ggplot(aes(x = year, y = GDP)) +
  geom_line()


# EXERCISE

# Now, draw a line chart of ``wages`` over time for Italy:







### Text

# You can even replace points by text on a chart using ``geom_text``. This is the same chart 
# as the scatterplot of unemployment and inflation, except that we put the country names instead of points:

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation, label = country)) +
  geom_text()


# EXERCISE

# Draw a text chart of ``GDP`` against ``govt_debt`` in 2014, using ``geom_text()`` 
# to display country names instead of points:







### Combining geometries

# Note that you can of course combine several geometries in one chart. 
# For example, this chart combines a bar chart of ``productivity`` with a scatter plot of ``govt_debt`` :

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(productivity)) %>% 
  head(10) %>% 
  ggplot(aes(x = country)) +
  geom_col(aes(y = productivity)) +
  geom_point(aes(y = govt_debt))



################################################################################
## Colours 
################################################################################

### Basics

# Now, we look at how to colour charts. The most basic way of adding colour to a chart 
# is very simple, like for this bar chart:

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation)) +
  geom_point(col = "red")

# Note that in the above chart, we used the ``col`` argument. For a bar chart, we will need to use ``fill``:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col(fill = "red")

# In the examples above, the colour is the same for all points/bars. If you want the colour 
# to represent a variable, you need to put it inside the ``aes()`` function, as follows:  

economic_data %>% 
  filter(year == 2014) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = country)) +
  geom_point()

# Notice that the chart above has too many colours to be useful. Instead, in the chart below, 
# we limit the number of colours by recoding the country names so that we only show the names 
# of the top 7 countries by unemployment, and the rest as "other":

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(unemployment)) %>% 
  mutate(country = ifelse(row_number() <= 7, country, "Other")) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = country)) +
  geom_point()


# Do you see how the legend shows "Other" in the middle of all the countries, because the legend 
# is alphabetical? That is not very helpful. To change that, I recode "country" as a factor, 
# which will be in decreasing order of ``unemployment``:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(unemployment)) %>% 
  mutate(country = ifelse(row_number() <= 7, country, "Other")) %>% 
  mutate(country = fct_reorder(country, -unemployment)) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = country)) +
  geom_point()


# EXERCISE

# Now, create a scatter plot of ``GDP`` against ``research_investment`` in 2014, 
# with a different colour for each point. Limit the number of countries with colours 
# to the **top 5 countries** by GDP:











### Colours for lines

# For line charts, colours are a little bit different, as you also have to add a ``group`` variable. 
# For example, this shows GDP over time for France, the UK and Germany:  

economic_data %>% 
  filter(country %in% c("France", "UK", "Germany")) %>% 
  ggplot(aes(x = year, y = GDP, group = country, col = country)) +
  geom_line()


# EXERCISE

# Now, create a line chart of ``wages`` over time for Italy, Greece and Spain, 
# with a different colour for each country. Additionally, add ``size = 2`` inside 
# the ``geom_line()`` function to make the lines a bit bigger:









### Colour palettes

# Until now, all the colours have been defined automatically by R. But we can 
# change that of course! There is a big range of functions in the family of ``scale_`` that allow you do that.

# The following manually create a colour palette of green, red and blue for the previous line chart:

economic_data %>% 
  filter(country %in% c("France", "UK", "Germany")) %>% 
  ggplot(aes(x = year, y = GDP, group = country, col = country)) +
  geom_line(size = 2) +
  scale_colour_manual(values = c("green", "red", "blue"))


# EXERCISE

# Copy the previous lines chart you made of Italy, Greece and Spain, and create a 
# manual colour palette of darkblue, lightblue, and red:








# You can also use some ready-made colour palettes which are very helpful, especially 
# from the ``RColorBrewer`` package. You can find a description of the palettes 
# here: http://www.sthda.com/english/wiki/colors-in-r.

# In the example below, we create a scatterplot by country (and "Other") by using the 
# ``Dark2`` palette. This is an appropriate colour palette for categorical data like 
# country names. Note that we also increase the point size to make it more visible:
  
economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(unemployment)) %>% 
  mutate(country = ifelse(row_number() <= 7, country, "Other")) %>% 
  mutate(country = fct_reorder(country, -unemployment)) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = country)) +
  geom_point(size = 4) +
  scale_color_brewer(palette = "Dark2")


# EXERCISE

# Now copy the scatterplot above and experiment with a few palettes such as ``Blues``, 
# ``Set3`` or ``Pastel1`` to see the difference:









# We can also create continuous palettes which are useful when the colour represents 
# a numeric variable. In the scatterplot below, for example, colour represents ``wages``:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(unemployment)) %>% 
  mutate(country = ifelse(row_number() <= 7, country, "Other")) %>% 
  mutate(country = fct_reorder(country, -unemployment)) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = wages)) +
  geom_point(size = 4) +
  scale_color_gradient(low="blue", high="red")


# EXERCISE

# Now, you create a similar scatterplot as above, but with the following changes: 
# * a color gradient from green to red
# * point size proportional to wages
# * add ``alpha = 0.5`` inside ``geom_point()`` to add some transparency










################################################################################
## Scale
################################################################################

# Sometimes you want to modify the scales for your chart. For example, in the chart below, 
# the y-axis doesn't start at zero. This can be an issue because the chart makes it seem 
# like there is very high growth, but that may not be so clear if the y-axis started at 0:


economic_data %>% 
  filter(country == "France") %>% 
  ggplot(aes(x = year, y = GDP)) +
  geom_line()


# EXERCISE

# Modify the chart to make the y-axis start at zero by adding ``+ expand_limits(y = 0)`` at the end:









# Notice how the chart is much less steep?
  
# You can also manually change the upper and lower limits of a chart by using ``ylim(min, max)`` and ``xlim(min, max)``:


economic_data %>% 
  filter(country == "France") %>% 
  ggplot(aes(x = year, y = GDP)) +
  geom_line() +
  xlim(1996, 2010) +
  ylim(0, 3000000)


# EXERCISE

# Now, create the following scatterplot:
# * a scatterplot of ``wages`` on the y-axis again ``unemployment`` on the x-axis for 2014
# * the colour and the transparency (``alpha``) should be proportional to GDP
# * the size of all points should be 3
# * the x scale should go from 0 to 30
# * the y scale should go from 0 to 70000










################################################################################
## Coord_flip
################################################################################

# Notice in the chart below, it is difficult to read the labels on the x-axis 
# because of the length of some country names:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col()


# EXERCISE

# Make it easier to read in that case by flipping the axis and putting the country 
# names on the y-axis instead, by using ``+ coord_flip()`` at the end of the code above:









################################################################################
## Labels and title
################################################################################

# It is always important to label your chart correctly. Notice in the chart below, 
# the x-axis looks particularly bad because we used the ``reorder()`` function:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col() +
  coord_flip()


# You can add appropriate axis titles, as well as a title for the whole chart using the 
# ``xlab()``, ``ylabl()`` and ``ggtitle()`` functions:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col() +
  coord_flip() +
  xlab("Country") +
  ylab("GDP ($millions)") +
  ggtitle("GDP for top 10 largest European economies in 2014")


# EXERCISE

# Now your turn. Construct the following chart:
# * A line chart of govt_debt over time for France, the UK, Germany, Spain, Italy, Greece
# * The line size should be 2 for all countries
# * There should be a different colour for each country
# * The colour scale should use the ``Paired`` palette
# * The x-axis title should be "Date (year)"
# * The y-axis title should be "Government debt (%)"
# * The chart title should be "Government debt over time for selected European countries"










################################################################################
## Themes
################################################################################

# There are lots of changes you can make to a chart's look - for example:
# * the background colour
# * the number of grids in the background
# * the axis text size
# * The title size

# These can all be controlled using the **theme()** function in ggplot.

### Text 

# Start with this chart:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col() +
  xlab("Country") +
  ylab("GDP ($millions)") +
  ggtitle("GDP for top 10 largest European economies in 2014")


# An alternative to flipping the chart could be to make the axis text rotate 45 degrees. 
# We can also try to center the title. Note that with all modifications to text themes, 
# we need to use ``element_text``:
  
economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col() +
  xlab("Country") +
  ylab("GDP ($millions)") +
  ggtitle("GDP for top 10 largest European economies in 2014") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))


# EXERCISE

# Now take the chart above and add the following modifications:
# * All axis text (``axis.text``) should have size 12, be in bold (``face = "bold"``) and be red (``colour = "red"``)
# * The title should have size 20  















### Background

# You can also modify the background colour and the colour of the background grids as follows:

economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(GDP)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(country, -GDP), y = GDP)) +
  geom_col() +
  xlab("Country") +
  ylab("GDP ($millions)") +
  ggtitle("GDP for top 10 largest European economies in 2014") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text = element_text(size = 12, face = "bold"),
        plot.title = element_text(hjust = 0.5),
        panel.background = element_rect(fill = "red"),
        panel.grid.major = element_line(colour = "grey"))


### Ready-made themes

# In reality, you are moer likely to use ready-made themes which change a number of elements of the chart at a time.

# For example, ``theme_bw()`` is one I use a lot, which creates a nice white background with grey grids:


economic_data %>% 
  filter(year == 2014) %>% 
  arrange(desc(unemployment)) %>% 
  mutate(country = ifelse(row_number() <= 7, country, "Other")) %>% 
  mutate(country = fct_reorder(country, -unemployment)) %>% 
  ggplot(aes(x = unemployment, y = inflation, col = country)) +
  geom_point(size = 4) +
  scale_color_brewer(palette = "Dark2") +
  theme_bw()


# EXERCISE

# Now, experiment with the chart above and replace ``theme_bw()``with the following themes to see what they do:
# * ``theme_classic()``
# * ``theme_dark()``
# * ``theme_void()``
# * ``theme_economist()``
# * ``theme_tufte()``







