library(shiny)
library(dplyr)
library(openxlsx)
library(janitor)

data <- openxlsx::read.xlsx("data_cv_shiny.xlsx")%>%
  dplyr::mutate(date = as.Date(date, origin = "1899-12-30"))%>%
  dplyr::mutate(display_date = format(date, "%B %Y"))

mute <- function(x){ifelse(grepl("NA",x)|is.na(x), "", x)}

values_ref <- reactiveVal(c(""))

function(input, output, session) {

  output$cv_pdf <- downloadHandler(

    filename = "CV_Lina_El_Mouatassim.pdf",
    content = function(file) {
      file.copy("www/CV_Lina_El_Mouatassim.pdf", file)
    }
  )
  
  output$slider_ui <- renderUI({
    
    sliderTextInput(
      "slider",
      "",
      choices = format(data$date%>%unique()%>%sort(), "%B %Y"),
      selected = format(max(data$date), "%B %Y"),
      grid = FALSE,
      width = "90%"
    )
    
  })
  
observeEvent(input$slider,{

  df <- data %>% dplyr::filter(display_date == input$slider)
  
  output$text <- renderUI({
    
    HTML(paste0(
      "<h4 style = 'color:#4f26e5;'>En ",input$slider,", </h4><h5 style='font-weight:bold;'><br>",
      df$xp1,
      "</h5>",
      mute(paste0("<p style='font-style:italic;'>", df[["détail.xp1"]],"</p>")),
      "<h5 style='font-weight:bold;'>",mute(df$xp2),"</h5>",
      mute(paste0("<p style='font-style:italic;'>", df[["détail.xp2"]],"</p>"))
    ))
    
  })
  
  df_xp <- data[1:which(data$display_date == input$slider),]
  
  hc_xp <- highchart(height = 180)%>%
    hc_chart(animation = FALSE)%>%
    hc_plotOptions(bar = list(stacking = "normal", animation = FALSE))%>%
    hc_yAxis(title = list(text = "Nombre d'années d'expériences"), min = 0, max = 8, stackLabels = list(enabled = TRUE, format = "{total:,.2f} ans"))%>%
    hc_xAxis(visible = FALSE)%>%
    hc_add_series(type = "bar", name = "CDD ou CDI", color = "#bcaaff",data = ((df_xp[["CDD.ou.CDI"]]%>%sum())/12)%>%round(2), stack = "all")%>%
    hc_add_series(type = "bar", name = "Alternance", color = "#7955ff",data = ((df_xp[["Alternance"]]%>%sum())/12)%>%round(2), stack = "all")%>%
    hc_add_series(type = "bar", name = "Stage", color = "#4f26e5",data = ((df_xp[["Stage"]]%>%sum())/12)%>%round(2), stack = "all")%>%
    hc_add_series(type = "bar", name = "Emploi étudiant", color = "#2c157f", data = ((df_xp[["Emploi.étudiant"]]%>%sum())/12)%>%round(2), stack = "all")
  
  
  
  output$xp_ui <- renderUI({
    
    hc_xp
  })

  values <- df[,10:ncol(df)-1]%>%unlist()
  
  if(mean(values == values_ref())<1){
    
    values_ref(values)
    
  }
  
})

observeEvent(values_ref(),ignoreInit = TRUE,{
  
values <- values_ref()

values <- values[values > 0]

hc_skills <- highchart()%>%
  hc_tooltip(pointFormat = '{point.name} : {point.value}/10')%>%
  hc_plotOptions(
    series = list(animation=FALSE),
    packedbubble = list(
      minSize = 1,
      maxSize = 60,
      layoutAlgorithm = list(
        gravitationalConstant= 0.001, 
        splitSeries = TRUE),
      dataLabels = list(
        enabled = TRUE,
        format = '{point.name}'
      )
      
      )

    )

for (categ in c("Data", "Business","Langues")){
  
  color <- ifelse(categ == "Data", "#1b355a" , ifelse(categ == "Business", "#692062", "#b56c8a" ))
  
  skills <- values[grepl(categ, names(values))]
  
  if(length(skills)>0){
    
    list_skills <- list()
    
    for (i in 1:length(skills)){
      
      list_skills[[length(list_skills)+1]] <- list(value = skills[i]%>%unname()%>%as.numeric(), name = gsub(".*: ","",gsub("\\."," ",names(skills[i]))))
      
    }
  }
  
  hc_skills <- hc_skills%>%
    hc_add_series(name = categ, color = color, type = 'packedbubble', data = list_skills, sizeByAbsoluteValue = TRUE)
  
}

output$result_slider <- renderUI({
  
    hc_skills
  
})



})



}
