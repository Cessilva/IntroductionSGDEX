function ShowDetailsScreen(content)
 
    details = CreateObject("roSGNode", "DetailsView")
 
    for each child in content.getChildren(-1, 0)
 
        'Tells details view which content getter is responsible for getting the content
 
        child.HandlerConfigDetails = {
            name: "GetDetailsContentConfig"
        }
 
    end for
 
    details.content = content
 
    'this will trigger job to show this screen
 
    m.top.ComponentController.callFunc("show", {
        view: details
    })
    return details
end function