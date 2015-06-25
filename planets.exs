defmodule Vector do
	defstruct magnitude: 0.0, theta: 0.0
end

defmodule Planet do
	defstruct name: "", mass: 0.0, velocity: %Vector{}, force: %Vector{}
end