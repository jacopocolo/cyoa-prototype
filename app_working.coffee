Framer.Defaults.Animation =
    curve: "ease-in-out"
    time: 0.3

padding = 10
isCardClicked = false;
wasDragged = false

bg = new BackgroundLayer
  backgroundColor: "#000"

card = new Layer
    x: 0
    y: 0
    width: window.innerWidth;
    height: window.innerHeight;
    backgroundColor: "#fff"
    borderRadius: 10
    shadowY = 2
    shadowBlur = 4
    shadowColor = "rgba(0,0,0,0.7)"

card.html = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo."

card.style =
    "color": "rgba(0,0,0,0.7)"
    "padding": padding*2+"px"
    "font-size": "30px"
    "line-height": "34px"
    "font-family": "Georgia, Times, Serif"

card.states.add
    options:
        scale: 0.9

card.on Events.Click, ->
    if isCardClicked == false && !wasDragged
        card.states.switch("options")
        top.states.switch("active")
        isCardClicked = true
    else
        isCardClicked = false
        card.states.switch("default")
        top.states.switch("default")

startX = card.x
startY = card.y

card.draggable.enabled = true
card.on Events.DragEnd, ->
        this.animate
            properties:
            x: padding
            y: padding
            card.html = "dragged"

top = new Layer
    x: 0
    y: 0
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"

top.states.add
    active:
        opacity: 1.0

top.html = "top answer"
top.style =
    "color": "rgba(255,255,255,1)"
    "text-align": "center"
