SceneGraph Developer Extensions (SGDEX) es una colección de código de muestra que demuestra cómo un desarrollador puede usar componentes Roku SceneGraph (RSG) preconstruidos y reutilizables para permitir un desarrollo rápido mientras sigue un paradigma de experiencia de usuario coherente. Las Extensiones de desarrollador se componen esencialmente de dos funciones, Vistas(Views) y Administrador de contenido(Content Manager).

Como tal , se trata de una herramienta que se encuantra a nuestro alcance, como un framework.

Para acceder a el: https://github.com/rokudev/SceneGraphDeveloperExtensions

El repositorio cuenta con la documentacion necesaria para hacer el uso correcto de la extension,la extension 
y como agregarla a tu proyecto y algunos ejemplos del uso de esta.

Views 
Las vistas SGDEX son los componentes de pantalla completa. El uso de una vista SGDEX ahorra el esfuerzo de construir una vista desde cero al usar componentes RSG de nivel inferior. Las vistas se implementan como pilas, para habilitar múltiples vistas.

ViewStack
SGDEX admite el apilamiento inmediato de las vistas. Esto significa que el desarrollador puede agregar tantas vistas a una pila como sea necesario y SGDEX se encargará del "cierre del botón de retroceso" de la vista. Para obtener más información sobre una pila de vistas, consulte Uso de ViewStack.

Component Controller
SGDEX incluye un controlador de componentes que ayuda a administrar las vistas en el canal. El uso del controlador de componentes ayuda a administrar la pila de vistas. Para obtener más información al respecto, consulte Controlador de componentes.

Atributos del tema(Theme Attributes)
Las Extensiones de desarrollador de SceneGraph también admiten la personalización de los temas de los elementos que se muestran en una vista. Para obtener más información sobre los atributos del tema, consulte los atributos del tema para las vistas.

Gestor de contenidos(Content Manager)
El Administrador de contenido de SceneGraph Developer Extension (SGDEX) simplifica la administración de tareas para los desarrolladores mediante el uso de un controlador de contenido para administrar los nodos de tareas y agilizar la naturaleza de subprocesos múltiples de los nodos de Roku SceneGraph. Para obtener más información sobre el administrador de contenido, consulte Uso del Administrador de contenido.

Empezando con la documentacion,el directorio de documentación contiene varios archivos para ayudar a los desarrolladores a comprender y hacer el mejor uso de SGDEX.

Componenetes
# SGDEX Components:  
* [BaseScene](#basescene)  
* [ContentHandler](#contenthandler)  
* [RAFHandler](#rafhandler)  
* [EntitlementHandler](#entitlementhandler)  
* [ComponentController](#componentcontroller)  
* [MediaView](#mediaview)  
* [SearchView](#searchview)  
* [TimeGridView](#timegridview)  
* [EntitlementView](#entitlementview)  
* [ParagraphView](#paragraphview)  
* [DetailsView](#detailsview)  
* [GridView](#gridview)  
* [VideoView](#videoview)  
* [CategoryListView](#categorylistview)  
* [SGDEXComponent](#sgdexcomponent)

La importantes para TimeGridView

BaseScene
Extends: Scene
Description:El desarrollador debe extender de BaseScene y trabajar en su contexto.
La función show (args) debe ser anulada en el canal.

Interface
Fields

- ComponentController (node)
Hace referencia al nodo ComponentController que se crea y se usa dentro de la biblioteca

- exitChannel (bool) => Solo lectura
Sale del canal si se establece en verdadero

- theme (assocarray) => Escribir solamente
El tema se utiliza para personalizar la apariencia de todas las vistas SGDEX

Para campos comunes consulta SGDEXComponent
Para vistas específicas, vea la documentación de la vista:
GridView
DetailsView
VideoView
CategoryListView
El tema se puede configurar en varios niveles
Cualquier vista:

scene.theme = {   
    global: {     
        textColor: "FF0000FF"   } } 

To set global theme attributes refer to BaseScene


Establece todos los colores de texto en rojo 
scene.theme = {   
    gridView: {     
        textColor: "FF0000FF"   } }

Establece el color del texto del grid específico de la instancia: use el campo de tema de la vista para configurar su tema
view = CreateObject("roSGNode", "GridView") 
view.theme = {   textColor: "FF0000FF" }

this grid will only have text color red All theme fields are combined and used by view when created, so you can set

Este grid solo tendrá color de texto rojo. Todos los campos de tema se combinan y se usan por la vista cuando se crean, por lo que puede establecer

scene.theme = {    
    global: {     textColor: "FF0000FF"   }  

gridView: {     textColor: "00FF00FF"   } } 
view1 = CreateObject("roSGNode", "GridView") 
view2 = CreateObject("roSGNode", "GridView") 
view2.theme = {   textColor: "FFFFFFFF" } 
detailsView= CreateObject("roSGNode", "DetailsView")

En este caso, view1 - tendrá textos en 00FF00FF 
view2 - tendrá FFFFFFFF 
detailsView - tomará textColor de global y será FF0000FF

- updateTheme (assocarray)
Campo para actualizar themes pasando la configuración
La estructura de la configuración es la misma que para el campo del tema.
Solo debe pasar los campos que deben actualizarse, no todos los campos del tema.

Nota. si desea cambiar muchos campos, cámbielos con la menor cantidad de configuraciones que pueda, entonces no volvería a dibujar las vistas con demasiada frecuencia.