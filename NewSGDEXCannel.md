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

# COMPONENT CONTROLLER
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

> En este momento nos va a salir un error puesto que no existe el componente CGRoot , por loq ue lo crearemos a continuacion
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

        if feed.Len() > 0
            json = ParseJson(feed)
            if json <> invalid AND json.rows <> invalid AND json.rows.Count() > 0
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

> **Note:** De acuerdo con las mejores prácticas de SceneGraph, se sugiere utilizar:
>  
>    m.top.content.Update(rootChildren)
>    
>Esto elimina múltiples encuentros entre el hilo de renderizado y el nodo de la tarea.


####   Contents of the JSON file

Creamos un archivo JSON en "pkg:/components/content/feed.json", con los siguientes datos:
    {
        "rows": [{
            "title": "ROW 1",
    
            "items": [{
                    "hdPosterUrl": "poster_url"
                },{
                    "hdPosterUrl": "poster_url"
                },{
                    "hdPosterUrl": "poster_url"
                },{
                    "hdPosterUrl": "poster_url"
            }]
        },{
            "title": "ROW 2",
            "items": [{
                "hdPosterUrl": "poster_url"
            },{
                "hdPosterUrl": "poster_url"
            },{
                "hdPosterUrl": "poster_url"
            },{
                "hdPosterUrl": "poster_url"
            }]
        }]
    }