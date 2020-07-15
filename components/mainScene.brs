sub Show(args as Object)
        m.grid = CreateObject("roSGNode", "GridView")   
        m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")  

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
            fields : { param : "123" }
            }
        })
        'Se le asigna a la vista
        m.grid.content = content
    
        'Activa un trabajo para mostrar la vista
        m.top.ComponentController.CallFunc("show", {
            view: m.grid
        })
end sub