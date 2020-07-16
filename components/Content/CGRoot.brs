sub GetContent()
' 'Esto si estas usando una API para obtener un JSON 
' ' In this you get the content from your feed url and parse it. 
' ' To get the content from a feed url you do the following
' url = CreateObject("roUrlTransfer")
' url.SetUrl("http://feed_path")
' url.SetCertificatesFile("common:/certs/ca-bundle.crt")
' url.AddHeader("X-Roku-Reserved-Dev-Id", "")
' url.InitClientCertificates()
' feed = url.GetToString()
' 'Note: this is for a url using https. The Certificates are only needed if you use https, not http.


' EN CASO DE NO TENER UN SERVICIO PODEMOS PONER UN JSON ESTATICO
feed = ReadAsciiFile("pkg:/components/Content/feed.json")
sleep(500)
' Now it is our job to parse the data.
' In this sample we are dividing the content into two Categories:movies and series. 
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
                        for each item in row.items
                            rowAA.children.Push(item)
                        end for

                        rowAA.Append({ title: row.title})
                        rootChildren.children.Push(rowAA)
                    end if
                end for
                m.top.content.Update(rootChildren)
            end if
        end if       
end sub 