' function ShowDetailsScreen(content, index)
'         details = CreateObject("roSGNode", "DetailsView")
'         details.content = content
'         details.jumpToItem = index
'         details.ObserveField("currentItem", "OnDetailsContentSet")
'         details.ObserveField("buttonSelected", "OnButtonSelected")
'         'Triggers a job to show the view
'         m.top.ComponentController.callFunc("show", {
'             view: details
'         })
'         return details
'     end function