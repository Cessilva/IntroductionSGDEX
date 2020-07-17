# Theme attributes for views
SceneGraph Developer Extensions (SGDEX) support customizing elements in the views.
## Using the theme attributes
- Establezca los atributos del tema al comienzo de un canal en la función Show (args).
- No establezca los atributos del tema global antes de abrir cada vista.
- To change one attribute, use the updateTheme field to specify only the attribute that needs to be changed.
- Establezca los atributos del tema y actualice los atributos como un bloque para que no se activen varias actualizaciones del tema.
- Theme attributes are only used by SGDEX views, and not by any other RSG nodes.

There are three ways to customize the appearance of a view:
## Global theme parameters
Setting the theme attribute to all the SGDEX views in SGDEX.brs:

    scene.theme = {
        global: {
            textColor: "FF0000FF"
            backgroundColor: "00FF00FF"
        }
    }

The code above sets the text color to RED for all the supported text in the views. The background color for the views is set to GREEN. 


## View type-specific attributes
Para establecer el fondo de todas las vistas en un color específico pero tener el fondo del grid configurado en otro color, use en SGDEX.brs:

        scene.theme = {
    global: {
       backgroundColor: "#ff0000"
    }
    gridView: {
        backgroundColor: "#ffff00"
        }
    }

Here, the views have a RED background, and the grids have a YELLOW background. 

## Instance-specific attributes
Since each view has its own theme field, to set view specific attributes using the theme field.

Note: Only set fields that are different from the ones set in the scene.

Si la scene tiene este tema :   

    scene.theme = {
        global: {
            backgroundColor: "#00FF00"
        }
    }
Estableciendo en DetailsScreenLogic.brs otro tema, aseguramos que todos menos detalles seran verdes:

     details = CreateObject("roSGNode", "DetailsView")
        details.theme = {
        backgroundColor: "#FF0000"
    }

> Nota: estos temas no se aplican a elementos NonSGDEX

# Updating theme attributes
The channel might need to update their branding on the current view or next view when a user takes an action. For example, when a user logs in to the channel, the logo might be changed. In such cases, the best approach is to update just one field; baseScene and SGDEX views have updateTheme field for such instances. The developer can use it to change/set any theme attribute.

UpdateTheme has the same syntax as theme.

For instance, if the overhang logo needs to be changed for the all channels after login, use the code below:
   
    sub OnLoginSuccess()
        scene = m.top.getScene()
        scene.updateTheme = {

            global: {
                OverhangLogoUri: "new logo url"
            }
        }
end sub 