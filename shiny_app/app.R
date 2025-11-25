library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(readr)
library(shinythemes)
library(tidyr)
# install.packages("shinyjs")
library(shinyjs)
# install.packages("colourpicker") #just for fun... :)
library(colourpicker)

# Load the Dataset
KBO_stats <- read_csv("KBOstats2024.csv")
final.KBOstats <- KBO_stats %>%
  select(OPS, BA, OBP, HR, Player)

# UI
ui <- fluidPage(
  theme = shinytheme("cosmo"), # Change theme for a more modern look
  
  # Adding shinyjs to use features like hiding/showing elements
  useShinyjs(),
  
  titlePanel(
    h2("KBO Player Stats Exploration"),
    windowTitle = "KBO Stats"
  ),
  
  sidebarLayout(
    sidebarPanel(
      h4("Instructions", style = "font-weight: bold;"),
      p("Use the dropdowns and sliders to explore KBO player statistics."),
      p("Choose a color for the graph to make it visually appealing :D"),
      p("Hope you have fun playing with these data!"),
      p("*for the Player option, you can choose the specific player below.*", style = "font-style: italic;"),
      selectInput("variable", "Choose a Variable:",
                  choices = c("OPS", "BA", "OBP", "HR", "Player"),
                  selected = "OPS"),
      uiOutput("dynamic_slider"),
      
      # Adding color picker
      colourInput("color", "Choose Graph Color:",
                  value = "#EAD1FF"),
      
      # Action button with an icon
      actionButton("update", "Update Graph", icon = icon("refresh"), class = "btn-primary"),
      
      hr(),
      
      # Add xVariable and yVariable inputs
      h4("Bivariate Plot Settings", style = "font-style: italic;"),
      selectInput("xVariable", "Select X-axis Variable:", choices = c("OPS", "BA", "OBP", "HR")),
      selectInput("yVariable", "Select Y-axis Variable:", choices = c("OPS", "BA", "OBP", "HR")),
      
      actionButton("update", "Update Graph", icon = icon("refresh"), class = "btn-primary"),
      hr(),
      
      # Player dropdown
      selectInput("selected_player", "Choose a Player:",
                  choices = unique(final.KBOstats$Player),
                  selected = unique(final.KBOstats$Player)[1]),
      hr(),
      
      checkboxInput("show_trendline", "Show TrendLine", value=TRUE)
      
    ),
    
    mainPanel(
      # Conditional panel for player stats display
      conditionalPanel(
        condition = "input.variable == 'Player'",
        h4("Player Stats"),
        tableOutput("playerStats"),
        textOutput("playerHomeRuns"),
        plotOutput("playerStatsGraph"),
        hr(),
        textOutput("imageCitation")
      ),
      
      # Univariate Plot
      h4("Univariate Graph"),
      p("This plot shows the distribution of the selected variable using a histogram."),
      p("NOTE: ONLY SHOWS APPROPRIATE STATISTICS FOR NUMERIC VARIABLES ONLY.", style="font-weight:bold"),
      plotOutput("univariatePlot", height = "300px"),
      
      hr(),
      
      # Summary Stats
      h4("Summary Statistics"),
      p("NOTE: ONLY SHOWS APPROPRIATE STATISTICS FOR NUMERIC VARIABLES ONLY.", style="font-weight:bold"),
      verbatimTextOutput("summaryStats"),
      
      hr(),
      
      # Bivariate Plot
      h4("Bivariate Analysis", style = "font-style:italic;"),
      p("This plot shows the relationship between the two selected numeric variables. A trend line is added for visualizing correlations."),
      plotOutput("bivariatePlot", height = "300px")
    )
  ),
  
  # Footer to provide information
  div(
    style = "text-align: center; padding: 10px; font-size: 12px; color: gray;",
    "Created by Nancy Kwak for SDS Project #3."
  )
)

# Server
server <- function(input, output) {
  
  # Dynamic slider based on selected variable
  output$dynamic_slider <- renderUI({
    if (input$variable == "OPS") {
      sliderInput("filter_range_ops", "Filter Data (OPS Range):",
                  min = 0, max = 1.2, value = c(0, 1))
    } else if (input$variable == "BA") {
      sliderInput("filter_range_ba", "Filter Data (BA Range):",
                  min = 0, max = 0.5, value = c(0, 0.5))
    } else if (input$variable == "OBP") {
      sliderInput("filter_range_obp", "Filter Data (OBP Range):",
                  min = 0.2, max = 0.5, value = c(0, 0.5))
    } else if (input$variable == "HR") {
      sliderInput("filter_range_hr", "Filter Data (HR Range):",
                  min = 0, max = 50, value = c(0, 50))
    } 
  })
  
  # Reactive data filter based on both slider values
  filteredData <- reactive({
    data <- final.KBOstats
    
    # Apply filter based on the selected variable and its corresponding slider range
    if (input$variable == "OPS") {
      data <- data %>%
        filter(OPS >= input$filter_range_ops[1], OPS <= input$filter_range_ops[2])
    } else if (input$variable == "BA") {
      data <- data %>%
        filter(BA >= input$filter_range_ba[1], BA <= input$filter_range_ba[2])
    } else if (input$variable == "OBP") {
      data <- data %>%
        filter(OBP >= input$filter_range_obp[1], OBP <= input$filter_range_obp[2])
    } else if (input$variable == "HR") {
      data <- data %>%
        filter(HR >= input$filter_range_hr[1], HR <= input$filter_range_hr[2])
    }
    
    return(data)
  })
  
  # Player statistics table
  output$playerStats <- renderTable({
    final.KBOstats %>%
      filter(Player == input$selected_player)
  })
  
  output$playerHomeRuns <- renderText({
    if (input$variable == "Player" && input$selected_player != "") {
      player_data <- final.KBOstats %>%
        filter(Player == input$selected_player)
      paste("Home Runs:", player_data$HR)
    } else {
      ""
    }
  })
  
  # Show bar chart for selected player stats
  output$playerStatsGraph <- renderPlot({
    if (input$variable == "Player" && input$selected_player != "") {
      player_data <- final.KBOstats %>%
        filter(Player == input$selected_player) %>%
        pivot_longer(cols = c(OPS, BA, OBP), names_to = "Stat", values_to = "Value")
      
      ggplot(player_data, aes(x = Stat, y = Value, fill = Stat)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        ggtitle(paste("Statistics for", input$selected_player)) +
        ylab("Value") +
        xlab("Statistic") +
        scale_fill_manual(values = c("red", "blue", "purple"))
    }
  })
  
  # Univariate graph
  output$univariatePlot <- renderPlot({
    data <- filteredData()  # Get the filtered data
    
    ggplot(data, aes_string(x = input$variable)) +
      geom_histogram(fill = input$color, bins = 10, color = "black") +
      theme_minimal() +
      ggtitle(paste("Distribution of", input$variable)) +
      xlab(input$variable) +
      ylab("Frequency")
  })
  
  # Descriptive statistics
  output$summaryStats <- renderText({
    data <- filteredData()
    # Validate input variable
    if (!(input$variable %in% names(data))) {
      return("Selected variable is not available in the dataset.")
    }
    stats <- data %>%
      summarise(
        mean = mean(get(input$variable), na.rm = TRUE),
        median = median(get(input$variable), na.rm = TRUE),
        sd = sd(get(input$variable), na.rm = TRUE),
        min = min(get(input$variable), na.rm = TRUE),
        max = max(get(input$variable), na.rm = TRUE)
      )
    paste(
      "Mean:", round(stats$mean, 2), "Median:", round(stats$median, 2), "SD:", round(stats$sd, 2),
      "Minimum:", round(stats$min, 2), "Maximum:", round(stats$max, 2)
    )
  })
  
  # Bivariate graph
  output$bivariatePlot <- renderPlot({
    ggplot(filteredData(), aes_string(x = input$xVariable, y = input$yVariable)) +
      geom_point(color = input$color) +
      {if (input$show_trendline) geom_smooth(method = "lm", se = FALSE)} +
      ggtitle(paste(input$xVariable, "vs", input$yVariable)) +
      xlab(input$xVariable) +
      ylab(input$yVariable) +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
