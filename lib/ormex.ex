defmodule Ormex do
    use Ormex.Model
end







# defprotocol Ormex.Model do
#   def blank?(data)
# end

# defmodule User do
#     defstruct name: "john", age: 27
# end

# defimpl Ormex.Model, for: User do
#     def blank?(_), do: false
# end