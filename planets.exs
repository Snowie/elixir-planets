defmodule Vector do
	#A vector represented in units of magnitude and radians
	defstruct magnitude: 0.0, theta: 0.0
	
	def getXComponent(v) do
		:math.cos(v.theta) *  v.magnitude
	end
	
	def getYComponent(v) do
		:math.sin(v.theta) * v.magnitude
	end

	#Sum two vectors
	def add(v1, v2) do
		xComponent = getXComponent(v1) + getXComponent(v2)
		yComponent = getYComponent(v1) + getYComponent(v2)
		
		theta 	   = :math.atan2(yComponent, xComponent)
		magnitude  = :math.sqrt(:math.pow(xComponent, 2) + :math.pow(yComponent, 2))
		
		%Vector{magnitude: magnitude, theta: theta}
	end

	def sum_list(list) do
		sum_list(list, 0)
	end

	def sum_list([head|tail], sum) do
		sum_list(tail, Vector.add(head, sum))
	end

	def sum_list([], sum) do
		sum
	end

	#From: http://media.pragprog.com/titles/elixir/code/lists/mylist1.exs
  	def map([], _func),             do: []
  	def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]
end

#Basic 2D cartesian points
defmodule Point do
	defstruct x: 0.0, y: 0.0
	
	def translate(point, vector) do
		x = point.x + Vector.getXComponent(vector)
		y = point.y + Vector.getYComponent(vector)
		
		%Point{x: x, y: y}
	end

	#Cartesian distance
	def distance(p1, p2) do
		xSqr = :math.pow(p1.x - p2.x, 2)
		ySqr = :math.pow(p1.y - p2.y, 2)
		
		:math.sqrt(xSqr + ySqr)
	end
end

#A struct to represent various celestial bodies
defmodule Object do
	defstruct name: "", mass: 0.0, position: %Point{}, velocity: %Vector{}, force: %Vector{}

	def forceGravity(o1, o2) do
		#Gravitational constant
		g = :math.pow(6.6741, -11)
		distance = Point.distance(o1.position, o2.position)
		
		#Fg = G * M1 * M2 / r^2
		magnitude  = g * o1.mass * o2.mass / :math.pow(distance, 2)
		theta = :math.atan2(o2.position.y - o1.position.y, o2.position.x - o2.position.x)
		
		#Don't apply gravity to yourself in point objects, it gets messy.
		if o1.name !== o2.name do
			%Vector{magnitude: magnitude, theta: theta}
		else
			%Vector{}
		end
	end

	#Update the current force acting on the body
	def updateForce(obj, listOfObjects) do
		currForces = Vector.map(listOfObjects, fn(n) -> forceGravity(obj, n) end)

		currForce = Vector.sum(currForces)

		%Object{obj | force: currForce}
	end

	#Translate according to current velocity and new forces
	def move(obj, dt) do
		#Calculate new velocity vector
		aX = Vector.getXComponent(obj.force) / obj.mass
		aY = Vector.getYComponent(obj.force) / obj.mass
		vX = Vector.getXComponent(obj.velocity) + aX * dt
		vY = Vector.getYComponent(obj.velocity) + aY * dt
		theta = :math.atan2(vY, vX)
		magnitude = :math.sqrt(vX * vX + vY * vY)
		velocity = %Vector{magnitude: magnitude, theta: theta}

		#Translate and update
		%Object{obj | position: Point.translate(obj.position, velocity)}
	end
end