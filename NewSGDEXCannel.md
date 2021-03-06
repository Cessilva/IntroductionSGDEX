# Building a channel using SceneGraph Developer Extensions
### Este tutorial es para construir un canal basado en Extensiones de desarrollador de SceneGraph (SGDEX). Los desarrolladores que desean crear su primer canal Roku, o están interesados en mover su canal existente a RSG, se benefician de esta guía.

### SGDEX includes the following views:
- Grid
- Details
- Video with endcard view
- Category list
- Entitlement
### Combinando las vistas enumeradas anteriormente, el desarrollador puede crear su canal sin un conocimiento profundo de los componentes de Roku SceneGraph.

# Creando un proyecto
1.- Agregar las extensiones necesarias para tener la estructura deseada
    project/
        components/
            SGDEX/
            "your RSG components"
        source/
            SGDEX.brs
            main.brs
        manifest


    1.-Installation(https://github.com/rokudev/SceneGraphDeveloperExtensions/tree/master/extensions)
    
    Follow these steps to prepare your channel to use SGDEX components:

        1.- Copy the SGDEX folder into your channel so that the path to the folder is pkg:/components/SGDEX. This path is required for certain graphic elements to work correctly.

        2.- Copy SGDEX.brs into your channel so that the path to the file is pkg:/source/SGDEX.brs

        3.- Add this line to your manifest: bs_libs_required=roku_ads_lib
    
    You are now ready to use SGDEX components in your channel!

En la carpeta de origen,en el archivo main.brs sustituye el codigo por lo siguiente:

    ' This function should be implemented in order to start SGDEX channel
    function GetSceneName() 
        return "mainScene"
    end function

El código anterior crea la escena y es el primer paso para crear una aplicación.

Aquí, "mainScene" es el nombre de la escena.

2.- Developing a channel
To develop a SGDEX channel, create a Scene that extends from BaseScene.
**Scene**
The XML file contains the following:

    <?xml version="1.0" encoding="UTF-8"?>
    
    <component name="mainScene" extends="BaseScene" >
        <script type="text/brightscript" uri="pkg:/components/mainScene.brs" />    
    </component>

In /components/MainScene.brs, add:

    sub Show(args as Object)
        'This function is called when the view is ready to show your content
    end sub

Esta función pasa los parámetros del main.brs y decide qué vista se muestra.

Puedes mostrar una pantalla de inicio(vista) o crear una pantalla de enlace profundo (vista) pasando los parámetros correspondientes.

La escena tiene un campo en la interfaz (ComponentController) que se utiliza para mostrar vistas y controlar flujos.

Un componenteController es el componente que controla todas las vistas.

### Interface

**Fields**

| **Field**      | **Description**                                           |
| -------------- | --------------------------------------------------------- |
| currentScreen  | La vista que se muestra actualmente                                                   |
| shouldCloseLastScreenOnBack | Indica si la última pantalla de la pila debe cerrarse antes de que salga el canal |

Manipule esta pantalla si el canal necesita implementar enlaces profundos
o, un cuadro de confirmación cuando el usuario presione back en la pantalla o vista principal.

### Function interface

| **Function** | **Use**                             |
| ------------ | ----------------------------------- |
| show         | Se usa para agregar una nueva vista a la pila |

# CREANDO Y MOSTRANDO NUESTRA PRIMERA VISTA 
To show the first view, the developer needs to create the view, add content to it, and then display it.

#### Example

In /components/mainScene.brs, add the following to indicate the show(args) function:

    
    sub Show(args as Object)
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

> The above code creates a simple grid view and displays it.

# INTERFACES DE LAS VISTAS
## View UI setup

| **Field**   | **Description**                                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------------- |
| style       | El estilo que se utilizará, consulte la documentación de cada estilo                                                 |
| posterShape | La forma del póster que se utilizará en esta vista.                                                                  |
| content     | View's content                                                                                                       |
| overhang    | Configure el overhang para personalizar cada vista de su canal.                                                      |

### View visibility handling

| **Field** | **Description**                                                                 |
| ----------| --------------------------------------------------------------------------------------------------------------- |
| wasClosed |Se activa cuando la vista actual está cerrada. Use esto cuando lea cualquier valor desde una vista cerrada. Por ejemplo, itemFocused para establecer el enfoque adecuado de la pantalla anterior                           |
| saveState | Se activa cuando se abre una nueva vista después de la vista actual. Es útil cuando los datos deben guardarse antes de abrir otra vista. Por ejemplo, pausar audio o video cuando se abre una nueva vista|
| wasShown  |Se activa cuando la vista actual se abre por primera vez o se restaura después de cerrar la vista superior                                                                                        |
| close     | Use este campo para cerrar la vista manualmente. Por ejemplo, durante un flujo de registro, todas las vistas de registro se cierran después de iniciar sesión correctamente                                                        |

Si el desarrollador no tiene contenido para el grid, use HandlerConfigGrid que describe cómo llenar filas para el grid view:

    content = CreateObject("roSGNode", "ContentNode")
 
    content.AddFields({
        HandlerConfigGrid: {
            name: "CGRoot"
        }
    })
    m.grid.content = content

> En este momento nos va a salir un error puesto que no existe el componente CGRoot , por lo que lo crearemos a continuacion
> Aparece un mensaje similar a este:
> BRIGHTSCRIPT: ERROR: roSGNode: Failed to create roSGNode with type CGRoot: pkg:/components/SGDEX/Scenes/BaseScene.brs(59)

## Content Getters( Getters de contenido)

A content getter es un componente responsable de llenar con datos(populating) el contenido de las vistas

Para cargar ciertos datos para una vista, use  content getters.

Para agregar root Content Getter, agréguelo al contenido de la vista creada:

    m.grid = CreateObject("roSGNode", "GridView")
 
    content = CreateObject("roSGNode", "ContentNode")
 
    content.AddFields({
        HandlerConfigGrid: {
            name: "CGRoot"
            fields : { param: "123" }
        }
    })
 
    m.grid.content = content

Cada vista SGDEX tiene un JSON Content Getter field que tiene:

    name \[required\] - Project Content Getter component name
    fields \[optional\] - Developer interface fields to be populated



### Default Content Getter

#### Interfaces

Content getter proporciona una lista predefinida de interfaces:

<table>
<thead>
<tr class="header">
<th><strong>Field</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>content</td>
<td>Contenido modificable. Puede ser de una vista vista o un hijo (fila o vista t¿de detalles o video)</td>
</tr>
<tr class="even">
<td>handlerConfig</td>
<td><p>Use handlerConfig para leer el valor de la configuración o restaurarlo al contenido si es necesario</p>
<p><strong>Note</strong>: Content getter elimina las configuraciones procesadas.Si los datos tienen que ser recargados cada que el contenido se muestra,restaure la configuración para el contenido en el Content Getter adecuado</p></td>
</tr>
<tr class="odd">
<td>offset</td>
<td>Indica qué desplazamiento está en uso. Utilice el desplazamiento para la carga diferida horizontal de la fila del grid </td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>Indica el tamaño de página configurado por el desarrollador. Se utiliza para la carga diferida horizontal del grid.</td>
</tr>
</tbody>
</table>

### Implementing Content Getter (Creacion de componente CGRoot)

To implement a Content Getter, create a component and extend it from ContentHandler.

    <?xml version="1.0" encoding="UTF-8"?>
    
    <component name="CGRoot" extends="ContentHandler" xsi:noNamespaceSchemaLocation="https://devtools.web.roku.com/schema/RokuSceneGraph.xsd">
    
        <script type="text/brightscript" uri="pkg:/components/Content/CGRoot.brs" />
    
    </component>

Content Getter implements only one required function GetContent() that
does not return anything:

    sub GetContent()
    
        'Esta es sólo una muestra. Por lo general, el feed se recupera de una url usando roUrlTransfer
        'De una API que nos proporciona el contenido

        feed = ReadAsciiFile("pkg:/components/content/feed.json")

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

> **Note:** De acuerdo con las mejores prácticas de SceneGraph, se sugiere utilizar:
>  
>    m.top.content.Update(rootChildren)
>    
>Esto elimina múltiples encuentros entre el hilo de renderizado y el nodo de la tarea.


####   Contents of the JSON file

Creamos un archivo JSON en "pkg:/components/content/feed.json", con los siguientes datos:

{
    "rows": [{
        "title": "Peliculas",
        "items": [{
                "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
                "title":"Live Gaming 1",
                "description":"kjdlskhfkdsjgñldsjgkdljsfgkdf vjshglfdkg trgkntrgjr fgkrtjg day, browse live broadcasts by the games you love and follow your favorite Twitch broadcasters."
            },{
                "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
                "title":"Live Gaming 2",
                "description":"With the Twitch channel, you can watch the rkjgeljfgmost popular broadcasts of the day, browse live broadcasts by the games you love and follow your favorite Twitch broadcasters."
            },{
                "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
                "title":"Live Gaming 3",
                "description":"ergkWith the Twitch channel, you can watch the most popular broadcasts of the day, browse live broadcasts by the games you love and follow your favorite Twitch broadcasters."
            },{
                "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
                "title":"Live Gaming 4",
                "description":"With the Twitch channel, you canvfkjbgkfjghbdfukhgf watch the most popular broadcasts of the day, browse live broadcasts by the games you love and follow your favorite Twitch broadcasters."
        }]
    },{
        "title": "Series",
        "items": [{
            "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
            "title":"Live Gaming SERIE 1"
        },{
            "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
            "title":"Live Gaming SERIE 2"
        },{
            "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
            "title":"Live Gaming SERIE 3"
        },{
            "hdPosterUrl": "https://blog.roku.com/developer/files/2016/10/twitch-poster-artwork.png",
            "title":"Live Gaming SERIE 4"
        }]
    }]
}

## ABRIENDO LA SIGUIENTE VISTA 

Para abrir una nueva vista para una determinada acción, use el mismo mecanismo para
crear y llenar la vista.

Por ejemplo, abrir una pantalla de detalles tras una seleccion del grid y suponiendo que se haya ejecutado lo siguiente en el mainScene.brs:

    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")

usa:

    sub OnGridItemSelected(event as Object)
    
        grid = event.GetRoSGNode()
        selectedIndex = event.getdata()
        rowContent = grid.content.getChild(selectedIndex[0])
    
        detailsScreen = ShowDetailsScreen(rowContent, selectedIndex[1])
        detailsScreen.ObserveField("wasClosed", "OnDetailsWasClosed")
    end sub


## DETALLES DE LA VISTA 

Agrega la funcion ShowDetailsScreen agregando /components/DetailsScreenLogic.brs con el siguiente contenido:   

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

El código anterior crea una nueva vista de detalles y pasa la fila de la cuadrícula como
contenido para más detalles. También usa jumpToItem para establecer el índice de inicio.

Agrega al mainScene.xml el script para que reconozca la funcion:

    <?xml version="1.0" encoding="utf-8" ?>
    <component name="mainScene" extends="BaseScene" >
        <script type="text/brightscript" uri="pkg:/components/mainScene.brs" />
        <script type="text/brightscript" uri="pkg:/components/DetailsScreenLogic.brs" />
    </component>

Si el desarrollador no quiere pasar una lista de elementos sino solo uno
artículo, pueden usar el fragmento a continuación:

    details.content = content.getChild(index)
    
    'Tells details screen that only one item should be visible
    
    details.isContentList = false
    
    'isContentList – Informs details view that this is a proper item and can be rendered such that no extra items are loaded

# AGREGANDO UN BOTON 
We begin by creating an DetailsView and observing the content and buttonSelected Field.
    details = CreateObject("roSGNode", "DetailsView")
    details.ObserveField("content", "OnDetailsContentSet")
    details.ObserveField("buttonSelected", "OnButtonSelected")

Agregamos el contenido del boton :

    sub OnDetailsContentSet(event as Object)
        btnsContent = CreateObject("roSGNode", "ContentNode")
        btnsContent.Update({ children: [{ title: "Play", id: "play" }] })
        details = event.GetRoSGNode()
        details.buttons = btnsContent
    end sub

Now let’s create the button observer. You get the context like you did before and get the content of the button in a similar way

    sub OnButtonSelected(event as Object)
        details = event.GetRoSGNode()
        selectedButton = details.buttons.GetChild(event.GetData())
       
    end if

En este momento nosotros tendremos un boton que nos pueda direccionar a una vista que no sea de tipo SGDEX 

## Opening non-SGDEX view

SGDEX no se limita a usar solo vistas SGDEX; el canal puede mostrar su propia vista y observar sus campos.

To open a non-SGDEX view, create, and populate interface fields, set
observers and call:
Para abrir una vista que no sea SGDEX, crear y completa los campos de interfaz, establezca
observadores y call:

~~~~
 m.top.ComponentController.callFunc("show", {
        view: yourViewNode
    })
~~~~

Esto oculta la vista actual (si existe) y muestra la vista que no es SGDEX.

**Note:** Component controller establece el foco en tu vista, asi que tu vista 
debe implementar un manejo de enfoque adecuado.

**Example**

~~~~
<?xml version="1.0" encoding="UTF-8"?>
 
<component name="CustomView" extends="Group" xsi:noNamespaceSchemaLocation="https://devtools.web.roku.com/schema/RokuSceneGraph.xsd">
    <script type = "text/brightscript" uri="pkg:/components/customView.brs"/ >
    <children>
        <Group id="container">
            <Button id="btn" text="Push Me"/>
        </Group>
    </children>
</component>
~~~~

In /components/NonSGDEX/CustomView/CustomView.brs", add:

~~~~
    function init() as void
        m.btn = m.top.findNode("btn")
        m.top.observeField("focusedChild", "OnChildFocused")
    end function
 
    sub OnChildFocused()
        if m.top.isInFocusChain() and not m.btn.hasFocus() then
            m.btn.setFocus(true)
        end if
    end sub
  ~~~~

Para poder usarla debemos hacer uso de un manejador de logica como en el caso de DetailsScreenLogic.brs al cual llamaremos CustomViewLogic.brs


Agregarla al mainScene:
~~~~
    <?xml version="1.0" encoding="utf-8" ?>
    <component name="mainScene" extends="BaseScene" >
        <script type="text/brightscript" uri="pkg:/components/mainScene.brs" />
        <script type="text/brightscript" uri="pkg:/components/DetailsScreenLogic.brs" />
        <script type="text/brightscript" uri="pkg:/components/CustomViewLogic.brs" />
    </component>
~~~~

y llamarla desde el boton:

~~~~
sub OnButtonSelected(event as Object)
        details = event.GetRoSGNode()
        selectedButton = details.buttons.GetChild(event.GetData())
        ShowCustomView(selectedButton)
end sub 
~~~~

Whenever the view receives focus, it should be checked if it's in the
focus chain and the node unfocused.

Focus handling is important as component controller sets focus to
a non-SGDEX view in two cases:

  - The view is just shown

  - The view is restored after top view was closed

Component Controller is responsible for closing this view when the back
button is pressed.

If the view needs to be closed manually, a new field called "close"
should be added to the view.

By setting yourView.close = true, the developer can close the current
view and the previous view is opened.


###### Copyright (c) 2018 Roku, Inc. All rights reserved.