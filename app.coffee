Framer.Defaults.Animation =
    curve: "ease-in-out"
    time: 0.2

console.log(structure)
    
padding = 10
isCardClicked = false;
wasDragged = false
chapterIndex = 0
chunkIndex = 0
fontSizeCard = Screen.width/15
lineheightCard = (Screen.width/15)+4
fontSizeOptions = Screen.width/25

fgColor = "rgba(255,255,255,1)"
bgColor = "rgb(238, 238, 238)"
cardTextColor = "rgba(0,0,0,0.7)"
optionsTextColor = "rgba(0,0,0,0.7)"

#temporary workaround till i figure out how to set font size properly
if Utils.isPhone() == true
  fontSizeCard = fontSizeCard*1.3
  lineheightCard = lineheightCard*1.3

bg = new BackgroundLayer
  backgroundColor: bgColor

card = new Layer
  x: 0
  y: 0
  width: Screen.width
  height: Screen.height
  backgroundColor: fgColor
  borderRadius: 10
  shadowY: 5
  shadowBlur: 10
  shadowColor: "rgba(0,0,0,0.2)"

card.index = 1000    

startX = card.x
startY = card.y

cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text

card.html = cardText
card.style =
    "display": "flex"
    "align-items": "center"
    "width": "100%"
    "color": cardTextColor
    "padding": padding*2+"px"
    "font-size": fontSizeCard+"px"
    "line-height": lineheightCard+"px"
    "font-family": "Georgia, Times, Serif"
    "word-wrap": "break-word"

card.states.add
    options:
        scale: 0.75
        shadowY: 5
        shadowBlur: 10

card.states.add
	front:
		x: 0
		y: 0
		scale: 1.0
        
card.states.add
	selected:
		shadowY: 50
		shadowBlur: 50
		
cardDefault = () ->
		card.draggable.enabled = false
		card.states.switch("front")
		top.states.switch("default")
		left.states.switch("default")
		right.states.switch("default")
		bottom.states.switch("default")

card.on Events.DragMove, ->
  horizontalOffset = Screen.width/8
  vericalOffset = Screen.height/8
  if card.draggable.offset.x > horizontalOffset || card.draggable.offset.x < -horizontalOffset || card.draggable.offset.y > vericalOffset || card.draggable.offset.y < -vericalOffset
    wasDragged = true

card.on Events.DragMove, ->
    if card.draggable.direction == "left" && card.minX<Screen.width/2
        right.states.switch("off")
        left.states.switch("highlight")
    if card.draggable.direction == "right" && card.minX>Screen.width/2
        left.states.switch("off")
        right.states.switch("highlight")
 
card.on Events.TouchStart, ->
    if card.states.current == "options"
        card.shadowY = 16
        card.shadowBlur = 32
            
#Works like this: first thing it checks if you are at the last chapter, than it checks if there are more chunks of text to show you, than it checks if there is a new chapter to show you, otherwise it shows you the options you have to go on.
card.on Events.TouchEnd, ->
    if wasDragged == false
        if structure.chapter[chapterIndex].end == true && chunkIndex+1 >= structure.chapter[chapterIndex].chunk.length
            print "end"
        else if chunkIndex+1 < structure.chapter[chapterIndex].chunk.length
            isCardClicked = false
            card.draggable.enabled = false
            chunkIndex = chunkIndex + 1
            cardText = cardText + structure.chapter[chapterIndex].chunk[chunkIndex].text
            card.html = cardText
        else if structure.chapter[chapterIndex].goto != undefined
            chapterIndex = structure.chapter[chapterIndex].goto
            chunkIndex = 0
            cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
            card.html = cardText   
        else if chunkIndex+1 >= structure.chapter[chapterIndex].chunk.length && structure.chapter[chapterIndex].options == undefined
            chapterIndex = chapterIndex+1
            chunkIndex = 0
            cardText = structure.chapter[chapterIndex].chunk[chunkIndex].text
            card.html = cardText
        else
            card.draggable.enabled = true
            if structure.chapter[chapterIndex].options.top.text == ""
                    card.draggable.vertical = false
            card.states.switch("options")
            top.states.switch("active")
            top.html = structure.chapter[chapterIndex].options.top.text
            right.states.switch("active")
            right.html = structure.chapter[chapterIndex].options.right.text
            bottom.states.switch("active")
            bottom.html = structure.chapter[chapterIndex].options.bottom.text
            left.states.switch("active")
            left.html = structure.chapter[chapterIndex].options.left.text
            applyStyle()
            isCardClicked = true

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
optionStyle = {"color": optionsTextColor, "text-align": "center", "font-size": fontSizeOptions+"px", "font-family": "Helvetica, Arial, sans-serif", "display": "flex", "align-items": "center"}

top = new Layer
    midX: Screen.width/2
    y: card.minY
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"
    

top.html = "top answer"
top.style = optionStyle
top.index = 0

top.states.add
	active:
		opacity: 1.0

right = new Layer
    height: 30
    width: Screen.height/1.5
    x: Screen.width-(Screen.height/3)-30
    y: Screen.height/2
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

right.html = "right answer"
right.style = optionStyle
right.index = 0

right.states.add
    active:
        opacity: 1.0
        
right.states.add
    highlight:
        scale: 1.2
        opacity: 1.0

right.states.add
    off:
        opacity: 0.2
        scale: 1.0
        
bottom = new Layer
    midX: Screen.width/2
    y: Screen.height-30
    height: 30
    width: 200
    opacity: 0.0
    backgroundColor: "transparent"

bottom.html = "bottom answer"
bottom.style = optionStyle
bottom.index = 0

bottom.states.add
	active:
		opacity: 1.0
		
left = new Layer
    height: 30
    width: Screen.height/1.5
    x: -(Screen.height/3)
    y: Screen.height/2
    opacity: 0.0
    originY: 0
    rotation: -90
    backgroundColor: "transparent"

left.html = "left answer"
left.style = optionStyle
left.index = 0

left.states.add
    active:
        opacity: 1.0
        scale: 1.0

left.states.add
    highlight:
        scale: 1.2
        opacity: 1.0
        
left.states.add
    off:
        opacity: 0.2
        scale: 1.0

applyStyle = () ->
    top.style = optionStyle
    right.style = optionStyle
    bottom.style = optionStyle
    left.style = optionStyle