# Using ViewStack

<h1>Las vistas son componentes SGDEX de pantalla completa que se pueden usar como plantilla para crear una vista en lugar de crear una desde cero. 
SGDEX admite el apilamiento inmediato de las vistas. Esto significa que puede agregar tantas vistas a una pila y SGDEX manejará el cierre del botón de retroceso de la vista y agregará soporte para eventos cuando la vista sea:</h1>

- Opened
- Closed
- Hidden because next view is displayed
- Manually closed

<h1>El componente ViewStack está diseñado para funcionar con cualquier componente RSG o una vista SGDEX.
 
Focus Handling

La pila de vistas maneja el foco basico cuando se abre la vista o restaura el foco cuando está cerrado.

Según las mejores prácticas de Roku, una vista debe manejar el foco por sí misma. 
ViewStack establece el foco a la vista implementando:view.setFocus(true).

La vista implementa el manejo del foco de la siguiente manera:</h1>


    sub init()
        m.viewThatHasFocus = m.top.findNode("viewThatHasFocus")
        m.top.observeField("focusedChild","OnFocusChildChange")
    end sub

    sub OnFocusChildChange()
        if m.top.isInFocusChain() and not m.viewThatHasFocus.hasFocus() then
        m.viewThatHasFocus.setFocus(true)
        end if
    end sub

<h1>Nota:No establezca el foco en la vista antes de agregarlo a ViewStack, ya que establecerá el foco en una vista anterior</h1>


# Abriendo una nueva vista 
<h1>Para agregar (abrir) una nueva vista a la pila, use:</h1>

    sub Show(args)
        homeGrid = CreateObject("roSGNode", "GridView")
        homeGrid.content = GetContentNodeForHome() ' implemented by user
        
        'This will add your view to stack
        m.top.ComponentController.callFunc("show", {
            view: homeGrid
        })
    end sub

# Recibiendo un evento cuando la vista está cerrada
<h1>Si desea recibir una notificación cuando la vista se cierra manualmente o cuando el usuario ha presionado hacia atrás (observeField wasClosed), use lo siguiente:</h1>


    sub onShowLoginPage()
        loginView = CreateObject("roSGNode", "MyLoginView")
        loginView.observeField("wasClosed", "onLoginFinished")

        'This will add your view to stack
        m.top.ComponentController.callFunc("show", {
            view: loginView
        })
    end sub
    
    sub onLoginFinished(event as Object)
        loginView = event.getRosgNode()
        if loginView.isSuccess then
        ShowVideoPlayer()
        else
            'do your logic
        end if
    end sub

# Closing a view manually
<h1>Para cerrar una vista manualmente, usa el field de close de la vista. Esto es útil cuando el canal necesita mostrar la siguiente vista después de un inicio de sesión exitoso.

Nota: El campo close es agregado por el ViewStack.El desarrollador puede cerrar cualquier vista en la pila, incluso si no está en la parte superior.</h1>


sub onShowLoginPage()
    'Se crea la vista
    banner = CreateObject("roSGNode", "MyBannerView")
    banner.observeField("wasClosed", "onBannerClosed")
 
    m.timer = CreateObject("roSGNode", "Timer")
    'if user doesn't perform anything close the view
    m.timer.duration = 20
    m.timer.control = "start"
    m.timer.observeField("fire", "closeBanner")
 
    'This will add your view to stack
    m.top.ComponentController.callFunc("show", {
        view: banner
    })

    m.banner = banner
end sub
 
sub closeBanner()
    m.banner.close = true
end sub
 
sub onBannerClosed()
    'Show next view
end sub

# Component Controller
<h1>El uso del controlador de componentes ayuda a implementar y administrar la pila de vistas. Básicamente, implementa la administración de vista predeterminada básica. El Controlador de componentes tiene campos para permitir el desarrollo de vistas para construir un canal usando las Extensiones de desarrollador de SceneGraph. Consulte ComponentController Component para obtener más detalles.</h1>


## Component Controller Fields
- currentView:links de la vista que ViewStack muestra actualmente (esta vista representa la vista que muestra ViewStack. Si se muestra otra vista sin usar ViewStack, no se reflejaría aquí)

- allowCloseChannelOnLastView: si es verdadero, el canal se cierra cuando se presiona el botón Atrás o si la vista anterior establece el campo de cierre de la vista en verdadero

- allowCloseLastViewOnBack: si es verdadero, la vista actual está cerrada y el usuario puede abrir otra vista a través de la devolución de llamada wasClosed de la nueva vista
