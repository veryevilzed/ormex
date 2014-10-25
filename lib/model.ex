defmodule Ormex.Model do
    defmacro __using__(_opts) do
        quote location: :keep do
            defmacro defmodel name, opts \\ [], code do
                quote do
                    defmodule :'#{unquote(name)}.Item' do
                        fields = []
                        unquote(code)
                        defstruct Enum.map(fields, fn(%{name: name, default: default}) -> {name, default} end)
                    end

                    defmodule :'#{unquote(name)}' do
                        fields = []
                        unquote(code)
                        def filter(opts \\ []), do: "filtered"
                        
                    end

                    defmodule :'#{unquote(name)}.Meta' do
                        fields = [] 
                        unquote(code)                        
                        def meta(), do: "OPA"
                    end
                end # quote
            end # defmodel

            defmacro deffield name, opts \\ [] do
                default = Dict.get(opts, :default, nil)
                datatype = Dict.get(opts, :datatype, :text)
                quote do
                    fields = [%{name: unquote(name), default: unquote(default), dataaype: unquote(datatype)}|fields]
                end
            end

        end             
    end
end

