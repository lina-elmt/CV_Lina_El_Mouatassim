library(shiny)
library(dplyr)
library(highcharter)
library(shinydashboard)
library(shinyWidgets)
library(bs4Dash)
library(shinydashboardPlus)

dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(
    tags$head(
      tags$style(HTML(".main-sidebar.shiny-bound-input {background-color:  #1b355a;}")),
      tags$style(HTML(".irs--round .irs-bar--single {background-color:  #1b355a;}")),
      tags$style(HTML(".irs--round .irs-handle  {border-top-color:#b300b6;border-right-color:#b300b6 ; border-left-color:#b300b6 ; border-bottom-color:#b300b6}")),
      tags$style(HTML(".irs--round .irs-from, .irs--round .irs-to, .irs--round .irs-single {background-color:  #b300b6;}")),
      tags$style(HTML("a.slider-animate-button {color:  #b300b6;}"))
      
    ),
    tags$div(
      align="center",
    img(src='photo.jpg', width="80%"),
    HTML(
      "<br><h3 style='color:white;font-weight:bold'>Lina <br>EL MOUATASSIM</h2><br>
      <h4 style='color:white;'>Data scientist</h4>
      <h4 style='color:white;'>Développeur R Shiny</h4>
      <h4 style='color:white;'>Responsable innovation</h4><br>
      Ma mission est de transformer les données en solutions exploitables pour orienter la prise de décision stratégique et permettre un avantage compétitif.
      <br><br>
      <i>
      lina.el-mouatassim@hotmail.fr<br>
      07 80 84 48 23<br>
      69100 Villeurbanne
      </i>
      <br><br>
      "
    ),
    socialButton(
      href = "https://www.linkedin.com/in/lina-el-mouatassim/",
      icon = icon("linkedin")      
    ),
    socialButton(
      href = "https://github.com/lina-elmt",
      icon = icon("github")      
    ),
    downloadBttn("cv_pdf", "Télécharger le CV pdf", style = "stretch", size="xs")|>tagAppendAttributes(style = 'color:#bcaaff')
    
    )),
  dashboardBody(
    chooseSliderSkin("Round"),
    
    tags$div(
      align="center",
      tags$h4("Déplacez le curseur ou cliquez sur play pour vous déplacer dans le temps", align="center", style = "color:#b300b6;"),
      div(style = "text-align: center;",
          tags$a(href = "#", class = "slider-animate-button", 
                 `data-target-id` = "slider", `data-interval` = "800", `data-loop` = "TRUE", title = "Play",
                 tags$span(class = "play", 
                           tags$i(aria_label = "play icon", class = "glyphicon glyphicon-play", role = "presentation")),
                 tags$span(class = "pause", 
                           tags$i(aria_label = "pause icon", class = "glyphicon glyphicon-pause", role = "presentation"))
          )
      ),
      uiOutput("slider_ui")
    ),
  fluidRow(
    column(width=8,
           box(title = "Description de l'expérience",collapsible = FALSE, width = 12, uiOutput('text')),
           box(title = "Expérience professionnelle",collapsible = FALSE, width=12, uiOutput("xp_ui"))
           ),
    box(title = "Cartographie des compétences", collapsible = FALSE, width = 4, uiOutput('result_slider'))
  )
  ))
    