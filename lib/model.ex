defmodule Ormex.Model do
    defmacro __using__(_opts) do
        quote location: :keep do
            defmacro defmodel name, opts \\ [], code do

                engine = Dict.get(opts, :engine, "InnoDB")
                charset = Dict.get(opts, :charset, "UTF8")

                quote do
                    defmodule :'#{unquote(name)}.Item' do
                        fields = []
                        unquote(code)
                        defstruct Enum.map(fields, fn(%{name: name, opts: opts}) -> 
                            {name, Dict.get(opts, :default, nil)} 
                        end)
                    end

                    defmodule :'#{unquote(name)}' do
                        fields = []
                        unquote(code)
                        def filter(opts \\ []), do: "filtered"

                    end

                    defmodule :'#{unquote(name)}.Meta' do
                        fields = [] 
                        unquote(code)                        
                        
                        macro_get_fields(fields)

                        def create() do
                            "CREATE TABLE IF NOT EXISTS #{Ormex.Utils.get_name(unquote(name))} (" <> Ormex.Utils.create_fields(_fields) <> ") ENGINE=#{unquote(engine)} CHARACTER SET=#{unquote(charset)};"
                        end
                    end
                end # quote
            end # defmodel

            defmacro deffield name, opts \\ [] do
                datatype = Dict.get(opts, :datatype, :text)
                opts = opts |> Dict.delete(:column)  |> Dict.delete(:datatype)
                quote do
                    fields = [%{name: unquote(name), column: Dict.get(unquote(opts), :column, "#{Ormex.Utils.get_name(unquote(name))}"), datatype: unquote(datatype), opts: unquote(opts)}|fields]
                end
            end


            defmacro macro_get_fields(fields) do
                quote unquote: false do
                    defp _fields do
                        unquote(Macro.escape fields)
                    end 
                end
            end

        end             
    end
end

