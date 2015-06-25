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
end

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

defmodule Object do
	defstruct name: "", mass: 0.0, position: %Point{}, velocity: %Vector{}, force: %Vector{}

	def forceGravity(o1, o2) do
		G = :math.pow(6.6741, -11)
		distance = Point.distance(o1.position, o2.position)
		
		#Fg = G * M1 * M2 / r^2
		magnitude  = G * o1.mass * o2.mass / :math.pow(distance, 2)
		theta = :math.atan2(o2.position.y - o1.position.y, o2.position.x - o2.position.x)
		
		%Vector{magnitude: magnitude, theta: theta}
	end

	def updateForce(obj, setOfObjects) do
		currForce = %{}
		for other = %Object{name: name} <- setOfObjects, name != obj.name, do: currForce = Vector.add(currForce, forceGravity(obj, other))

		%Object{obj| force: currForce}
	end

	def move(obj, dt) do
		aX = Vector.getXComponent(obj.force) / obj.mass
		aY = Vector.getYComponent(obj.force) / obj.mass

		vX = Vector.getXComponent(obj.velocity) + aX * dt
		vY = Vector.getYComponent(obj.velocity) + aY * dt

		theta = :math.atan2(vY, vX)
		magnitude = :math.sqrt(vX * vX + vY * vY)

		velocity = %Vector{magnitude: magnitude, theta: theta}

		%Object{obj | position: Point.translate(obj.position, velocity)}
	end
end