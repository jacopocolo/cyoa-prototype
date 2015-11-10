Framer.Defaults.Animation =
    curve: "ease-in-out"
    time: 0.2

padding = 10
isCardClicked = false;
wasDragged = false
storyIndex = 0
blockIndex = 0

bg = new BackgroundLayer
  backgroundColor: "#000"

card = new Layer
	x: 0
	y: 0
	width: Screen.width #window.innerWidth
	height: Screen.height #window.innerHeight
	backgroundColor: "#fff"
	borderRadius: 10
	shadowY = 2
	shadowBlur = 4
	shadowColor = "rgba(0,0,0,0.7)"

startX = card.x
startY = card.y

cardText = structure.story[storyIndex].block[blockIndex].text

card.html = cardText
card.style =
    "color": "rgba(0,0,0,0.7)"
    "padding": padding*2+"px"
    "font-size": "30px"
    "line-height": "34px"
    "font-family": "Georgia, Times, Serif"
	"word-wrap": "break-word"

card.states.add
    options:
        scale: 0.85

card.states.add
	front:
		scale: 1.0
		
cardDefault = () ->
	card.states.switch("front")
	top.states.switch("default")
	left.states.switch("default")
	right.states.switch("default")
	bottom.states.switch("default")
	
card.on Events.TouchEnd, ->
	if wasDragged == false
		if blockIndex+1 < structure.story[storyIndex].block.length
			isCardClicked = false
			card.draggable.enabled = false
			blockIndex = blockIndex + 1
			cardText = cardText + structure.story[storyIndex].block[blockIndex].text
			card.html = cardText
		else if blockIndex+1 >= structure.story[storyIndex].block.length && structure.story[storyIndex].options == undefined
			storyIndex = storyIndex+1
			blockIndex = 0
			cardText = structure.story[storyIndex].block[blockIndex].text
			card.html = cardText
		else
			card.draggable.enabled = true
			#card.draggable.directionLock = true
			card.states.switch("options")
			top.states.switch("active")
			top.html = structure.story[storyIndex].options.top.text
			right.states.switch("active")
			right.html = structure.story[storyIndex].options.right.text
			bottom.states.switch("active")
			bottom.html = structure.story[storyIndex].options.bottom.text
			left.states.switch("active")
			left.html = structure.story[storyIndex].options.left.text
			isCardClicked = true

card.on Events.DragMove, ->
	offsetNumber = 15
	if card.draggable.offset.x > offsetNumber || card.draggable.offset.x < -offsetNumber || card.draggable.offset.y > offsetNumber || card.draggable.offset.y < -offsetNumber
		wasDragged = true

card.on Events.DragEnd, ->
	if wasDragged == true
	       this.animate
	        	properties:
	            	x: 0
	            	y: 0
	       if card.draggable.direction == "up"
           	cardDefault()
            storyIndex = structure.story[storyIndex].options.top.destination
            blockIndex = 0
            cardText = structure.story[storyIndex].block[blockIndex].text
          	card.html = cardText
				#card.html = "dragged X:"+card.draggable.offset.x+" Y:"+card.draggable.offset.y+"\n\n Direction: "+card.draggable.direction
			wasDragged = false
			
################################################
# OPTIONS: TOP, RIGHT, BOTTOM, LEFT 
################################################			
			
top = new Layer
    midX: Screen.width/2
    y: card.minY
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"

top.html = "top answer"
top.style =
    "color": "rgba(255,255,255,1)"
    "text-align": "center"

top.states.add
	active:
		opacity: 1.0

right = new Layer
    x: Screen.width-120
    y: Screen.height/2
    height: 30
    width: 200
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

right.html = "right answer"
right.style =
    "color": "rgba(255,255,255,1)"
    "text-align": "center"

right.states.add
    active:
        opacity: 1.0
        
bottom = new Layer
    midX: Screen.width/2
    y: Screen.height-20
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"

bottom.html = "bottom answer"
bottom.style =
    "color": "rgba(255,255,255,1)"
    "text-align": "center"

bottom.states.add
	active:
		opacity: 1.0
		
left = new Layer
    x: -100
    y: Screen.height/2
    height: 30
    width: 200
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

left.html = "left answer"
left.style =
    "color": "rgba(255,255,255,1)"
    "text-align": "center"

left.states.add
    active:
        opacity: 1.0
        
