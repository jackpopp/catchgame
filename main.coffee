Block = (x,y,g,c,t) ->
	@x = x
	@y = y
	@g = g
	@h = 20
	@w = 20
	@colour = c
	@type = t
	return

Player = (x, y, w, h) ->
	@x = x
	@y = y
	@h = h
	@w = w
	@speed = 15
	return

Game = ->

	START_HEIGHT = 50
	MIN_GRAVITY = 1
	MAX_GRAVITY = 5.2
	LEVEL_UP_SCORE = 7
	GOOD_BLOCK_INTERVAL = 1500
	BAD_BLOCK_INTERVAL = 5000

	@canvasElement = null
	@canvas = null
	@player = null
	@blocks = []
	@gameLoop = null
	@left = false
	@right = false
	@width = $(window).width()
	@height = $(window).height() - 20
	@score = 0
	@timeLeft = new Date().getTime()+60000
	@frameAnimationId = null
	@generateBlockInterval = null

	@level = 1
	@lives = 5


	@init = ->
		@canvasElement = $('#canvas')[0]
		@canvas = @canvasElement.getContext('2d')
		@canvas.canvas.width = @width
		@canvas.canvas.height = @height

		$('.lives').html @lives+' Lives'

		@player = new Player((($(window).width()/2)-100), ($(window).height()-200), 200, 50)

		@blocks.push new Block( 50, START_HEIGHT, ((Math.random()*MAX_GRAVITY)+MIN_GRAVITY), 'black', 'good' )
		@generateBlockInterval = setInterval(@genBlock.bind(@), GOOD_BLOCK_INTERVAL/@level)
		@generateBadInterval = setInterval(@genBadBlog.bind(@), BAD_BLOCK_INTERVAL/@level)
		#@timerInterval = setInterval(@countdown.bind(@), 1000)

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
			@canvas.fillStyle = block.colour
			@canvas.fillRect(block.x,block.y, block.h, block.w)

		if @player.x <= 0
			@left = false
		if @player.x >= $(window).width()-@player.w
			@right = false

		if @left
			@player.x-=@player.speed
		if @right
			@player.x+=@player.speed

		blocksToClear = []

		for block in @blocks
			# collision detection else let gravity do its thing.
			if block.y > @height
				blocksToClear.push block
				@score-=1
			else if (block.y >= @player.y and block.y < @player.y+@player.h) and (block.x >= @player.x and block.x < @player.x+@player.w)
				if block.type is 'good'
					@score+=(@level)
				else if block.type is 'bad'
					@lives--
					$('.lives').html @lives+' Lives'
					@gameOver() if @lives is 0
				blocksToClear.push block

			$('.score').html @score+'/'+@level*@level*LEVEL_UP_SCORE

		# Clear out any blocks that have collided with player or offscreen
		for block in blocksToClear
			@blocks.splice(@blocks.indexOf(block),1)

		# Added gravity to block.y
		for block in @blocks
			block.y+=block.g

		if @score > @level*@level*LEVEL_UP_SCORE
			@level++
			$('.level').html 'Level '+ @level
			clearInterval(@generateBadInterval)
			clearInterval(@generateBlockInterval)
			@generateBadInterval = setInterval(@genBadBlog.bind(@), BAD_BLOCK_INTERVAL/@level)
			@generateBlockInterval = setInterval(@genBlock.bind(@), GOOD_BLOCK_INTERVAL/@level)
		return

	@genBlock = ->
		@blocks.push new Block( (Math.floor((Math.random()*@width)+1)), START_HEIGHT, @getRandomArbitrary(MIN_GRAVITY, MAX_GRAVITY), 'black', 'good' )
		return

	@genBadBlog = ->
		@blocks.push new Block( (Math.floor((Math.random()*@width)+1)), START_HEIGHT, @getRandomArbitrary(MIN_GRAVITY, MAX_GRAVITY), 'red', 'bad' )
		return

	@animate = ->
		@frameAnimationId = window.requestAnimationFrame(@animate.bind(@))
		@paint.apply(@)
		return

	@countdown = ->
		timeNow = new Date().getTime()
		$('.time').html Math.round((@timeLeft-timeNow)/1000)+' seconds left.'
		if Math.round((@timeLeft-timeNow)/1000) < 0
			@gameOver()
			$('.time').html 'Game over.'
		return

	@gameOver = ->
		window.cancelAnimationFrame(@frameAnimationId)
		return

	@getRandomArbitrary = (min, max) ->
		return Math.random() * (max - min) + min

	@setEventHandlers = (self) ->
		$(window).keydown (e) ->
			if e.keyCode is 37
				self.left = true
				self.right = false
			if e.keyCode is 39
				self.left = false
				self.right = true
			return

		
		$(window).keyup (e) ->
			self.left = false
			self.right = false
			return
		
		return


	return

$ ->
	game = new Game()
	game.init()