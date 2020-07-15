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
