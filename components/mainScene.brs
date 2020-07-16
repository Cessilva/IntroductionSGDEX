
sub Show(args as Object)
    print "Hello World!"
'In this we first create a grid view object and set a few fields to fit our content.
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
    style: "standard"
    posterShape: "16x9"
    })
'we create a ContentNode and add a content handler to it in order to get and parse the content
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "CGRoot"
        }
    })
'add the ContentNode to the grid.
    m.grid.content = content
'Next we set up observers for what navigating the grid.
    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")
'Finally, we display the grid. When the grid gets displayed, its
'content handler will be invoked. Now, let’s setup the content handler.
    m.top.ComponentController.CallFunc("show", {
    view: m.grid
    })
    
    'Buena programacion 
    m.top.signalBeacon("AppLaunchComplete")
end sub


' sub OnGridItemSelected(event as Object)
'     grid = event.GetRoSGNode()
'     selectedIndex = event.getdata()
'     rowContent = grid.content.getChild(selectedIndex[0])
'     'Le estamos pasando  el primer hijo,y la segunda fila segun yo 
'     detailsScreen = ShowDetailsScreen(rowContent, selectedIndex[1])
'     detailsScreen.ObserveField("wasClosed", "OnDetailsWasClosed")
' end sub


