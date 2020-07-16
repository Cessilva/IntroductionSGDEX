sub GetContent()
        'Esta es sólo una muestra. Por lo general, el feed se recupera de una url usando roUrlTransfer
        'De una API que nos proporciona el contenido

        feed = ReadAsciiFile("pkg:/components/Content/feed.json")

        if feed.Len() > 0
            json = ParseJson(feed)
            if json <> invalid  AND json.rows <> invalid AND json.rows.Count() > 0
                rootChildren = {
                    children: []
                }
                for each row in json.rows
                    if row.items <> invalid
                        rowAA = {
                        children: []
                        }
                        for childIndex = 0 to 3
                            for each item in row.items
                                rowAA.children.Push(itemNode)
                            end for
                        end for
                        rowAA.Append({ title: row.title })
                        rootChildren.children.Push(rowAA)
                    end if
                end for
                m.top.content.Update(rootChildren)
            end if
        end if
end sub