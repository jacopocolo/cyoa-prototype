Framer.Defaults.Animation =
    curve: "ease-in-out"
    time: 0.2

padding = 10
isCardClicked = false;
wasDragged = false
chapterIndex = 0
chunkIndex = 0
fontSizeCard = 26
lineheightCard = 30
fontSizeOptions = 16

bg = new BackgroundLayer
  backgroundColor: "#000"

card = new Layer
	x: 0
	y: 0
	width: Screen.width #window.innerWidth
	height: Screen.height #window.innerHeight
	backgroundColor: "#f8f8f8"
	borderRadius: 10
	shadowY = 2
	shadowBlur = 4
	shadowColor = "rgba(0,0,0,0.7)"

card.index = 1000    

startX = card.x
startY = card.y

cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text

card.html = cardText
card.style =
    "display": "flex"
    "align-items": "center"
    "width": "100%"
    "color": "rgba(0,0,0,0.7)"
    "padding": padding*2+"px"
    "font-size": fontSizeCard+"px"
    "line-height": lineheightCard+"px"
    "font-family": "Georgia, Times, Serif"
	"word-wrap": "break-word"

card.states.add
    options:
        scale: 0.85

card.states.add
	front:
		x: 0
		y: 0
		scale: 1.0
		
cardDefault = () ->
		card.draggable.enabled = false
		card.states.switch("front")
		top.states.switch("default")
		left.states.switch("default")
		right.states.switch("default")
		bottom.states.switch("default")
	
card.on Events.TouchEnd, ->
	if wasDragged == false
		if chunkIndex+1 < structure.chapter[chapterIndex].chunk.length
			isCardClicked = false
			card.draggable.enabled = false
			chunkIndex = chunkIndex + 1
			cardText = cardText + structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
		else if chunkIndex+1 >= structure.chapter[chapterIndex].chunk.length && structure.chapter[chapterIndex].options == undefined
			chapterIndex = chapterIndex+1
			chunkIndex = 0
			cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
		else
			card.draggable.enabled = true
			#card.draggable.directionLock = true
			card.states.switch("options")
			top.states.switch("active")
			top.html = structure.chapter[chapterIndex].options.top.text
			right.states.switch("active")
			right.html = structure.chapter[chapterIndex].options.right.text
			bottom.states.switch("active")
			bottom.html = structure.chapter[chapterIndex].options.bottom.text
			left.states.switch("active")
			left.html = structure.chapter[chapterIndex].options.left.text
			isCardClicked = true

card.on Events.DragMove, ->
	offsetNumber = 50
	if card.draggable.offset.x > offsetNumber || card.draggable.offset.x < -offsetNumber || card.draggable.offset.y > offsetNumber || card.draggable.offset.y < -offsetNumber
		wasDragged = true

card.on Events.DragEnd, ->
	if wasDragged == true
		wasDragged = false
		if card.draggable.direction == "up"
			cardDefault()
			chapterIndex = structure.chapter[chapterIndex].options.top.destination
			chunkIndex = 0
			cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
		if card.draggable.direction == "down"
			cardDefault()
			chapterIndex = structure.chapter[chapterIndex].options.bottom.destination
			chunkIndex = 0
			cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
		if card.draggable.direction == "left"
			cardDefault()
			chapterIndex = structure.chapter[chapterIndex].options.left.destination
			chunkIndex = 0
			cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
		if card.draggable.direction == "right"
			cardDefault()
			chapterIndex = structure.chapter[chapterIndex].options.right.destination
			chunkIndex = 0
			cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
			card.html = cardText
	else
		this.animate
			properties:
				x: 0
				y: 0
			
################################################
# OPTIONS: TOP, RIGHT, BOTTOM, LEFT 
################################################			

optionStyle = {"color": "rgba(255,255,255,0.8)", "text-align": "center", "font-size": fontSizeOptions+"px", "font-family": "Helvetica, Arial, sans-serif"}

top = new Layer
    midX: Screen.width/2
    y: card.minY
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"

top.html = "top answer"
top.style = optionStyle
top.index = 1

top.states.add
	active:
		opacity: 1.0

right = new Layer
    height: 30
    width: 230
    x: Screen.width-115-20 #-this.width/2
    y: Screen.height/2
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

right.html = "right answer"
right.style = optionStyle
right.index = 1

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
bottom.style = optionStyle
bottom.index = 1

bottom.states.add
	active:
		opacity: 1.0
		
left = new Layer
    height: 30
    width: 230
    x: -115 #-this.width/2
    y: Screen.height/2
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

left.html = "left answer"
left.style = optionStyle
left.index = 1

left.states.add
    active:
        opacity: 1.0