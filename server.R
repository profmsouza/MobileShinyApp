library(shiny)
#library(shinyMobile)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    # Hierarchical lists
    observeEvent(input$reg, {
        entrada_reg = input$reg
        ufs <- filter(inc, Região == input$reg)
        ufs <- droplevels(ufs)
        shinyMobile::updateF7SmartSelect(
            inputId = "uf",
            choices = levels(ufs$Nome_UF),
            selected = levels(ufs$Nome_UF)[1]
        )
    })
    
    observeEvent(input$uf, {
        entrada_uf = input$uf
        cids <- inc %>%
            filter(Região == input$reg,
                   Nome_UF == input$uf)
        cids <- droplevels(cids)
        shinyMobile::updateF7SmartSelect(
            inputId = "cid",
            choices = levels(cids$Nome_Município),
            selected = levels(cids$Nome_Município)[1]
        )
    })
    
    observeEvent(input$cid, {
        entrada_cid = input$cid
    })
    
})
