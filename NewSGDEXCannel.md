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