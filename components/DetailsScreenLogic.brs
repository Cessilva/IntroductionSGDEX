function ShowDetailsScreen(content, index)
        details = CreateObject("roSGNode", "DetailsView")
        details.content = content
        details.jumpToItem = index
        details.ObserveField("currentItem", "OnDetailsContentSet")
        details.ObserveField("buttonSelected", "OnButtonSelected")
        'Triggers a job to show the view
        m.top.ComponentController.callFunc("show", {
            view: details
        })
        return details
    end function

sub OnDetailsContentSet(event as Object)
        btnsContent = CreateObject("roSGNode", "ContentNode")
        btnsContent.Update({ children: [{ title: "Play", id: "play" }] })
        details = event.GetRoSGNode()
        details.buttons = btnsContent
end sub
sub OnButtonSelected(event as Object)
        details = event.GetRoSGNode()
        selectedButton = details.buttons.GetChild(event.GetData())
        ShowCustomView(selectedButton)
    '     "if selectedButton.id = "play"
    '     OpenVideoPlayer(details.content, details.itemFocused, details.isContentList)
    ' else if selectedButton.id = "episodes"
    '     ShowEpisodePickerView(details.currentItem.seasons)
    ' end if"
end sub 