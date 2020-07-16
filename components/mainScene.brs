sub Show(args as Object)
        m.grid = CreateObject("roSGNode", "GridView")   

        'Configurar la interfaz de usuario de la vista   
        m.grid.SetFields({        
            style: "standard"        
            posterShape: "16x9"      
        })
        
        ' Este es el contenido raíz que describe cómo llenar el resto de las filas
        content = CreateObject("roSGNode", "ContentNode")
        'Se agrega un manejador de configuracion, indicando que este sera la raiz
        content.AddFields({
            HandlerConfigGrid: {
            name: "CGRoot"
            }
        })
        'Se le asigna a la vista
        m.grid.content = content

        m.grid.ObserveField("rowItemSelected", "OnGridItemSelected") 
    
        'Activa un trabajo para mostrar la vista
        m.top.ComponentController.CallFunc("show", {
            view: m.grid
        })
end sub

sub OnGridItemSelected(event as Object)
    grid = event.GetRoSGNode()
    selectedIndex = event.getdata()
    rowContent = grid.content.getChild(selectedIndex[0])
    'Le estamos pasando  el primer hijo,y la segunda fila segun yo 
    detailsScreen = ShowDetailsScreen(rowContent, selectedIndex[1])
    detailsScreen.ObserveField("wasClosed", "OnDetailsWasClosed")
end sub

sub OnDetailsWasClosed(event as Object)
    details = event.GetRoSGNode()
    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], details.itemFocused]
end sub
