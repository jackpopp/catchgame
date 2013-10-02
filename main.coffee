Block = (x,y,g) ->
	@x = x
	@y = 10
	@g = g
	return

Player = (x, y, w, h) ->
	@x = x
	@y = y
	@h = h
	@w = w
	return

Game = ->
	@canvasElement = null
	@canvas = null
	@player = null
	@blocks = []
	@gameLoop = null
	@left = false
	@right = false

	@init = ->
		@canvasElement = $('#canvas')[0]
		@canvas = @canvasElement.getContext('2d')
		@canvas.canvas.width = $(window).width()
		@canvas.canvas.height = $(window).height()-20

		@player = new Player((($(window).width()/2)-100), ($(window).height()-200), 200, 50)

		@blocks.push new Block(50,10,1)

		@setEventHandlers(@)

		@animate()
		return

	@paint = ->
		@canvas.width = canvas.width
		@canvas.fillStyle = 'white'
		@canvas.fillRect(0, 0, $(window).width(), $(window).height())
		@canvas.fillStyle = 'black'
		@canvas.fillRect(@player.x, @player.y, @player.w, @player.h)

		for block in @blocks
			@canvas.fillRect(block.x,block.y, 5, 5)

		if @player.x is 0
			@left = false
		if @player.x >= $(window).width()-@player.w
			@right = false

		if @left
			@player.x-=5
		if @right
			@player.x+=5

		for block in @blocks
			# collision detection else let gravity do its thing.
			block.y+=block.g

		return

	@animate = ->
		requestAnimationFrame(@animate.bind(@))
		@paint.apply(@)
		return

	@setEventHandlers = (self) ->
		$(window).keydown (e) ->
			if e.keyCode is 37
				self.left = true
				self.right = false
			if e.keyCode is 39
				self.left = false
				self.right = true
			return

		
		#$(window).keyup (e) ->
		#	self.left = false
		#	self.right = false
		#	return
		
		return


	return

$ ->
	game = new Game()
	game.init()