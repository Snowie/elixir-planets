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

defmodule Planet do
	defstruct name: "", mass: 0.0, position: %Point{}, velocity: %Vector{}, force: %Vector{}
end