defmodule Utils do
    
    
    defp escape(data) when is_binary(data), do: data |> String.to_char_list |> escape([])
    defp escape([], res), do: res |> List.to_string
    defp escape([char|tail], res) do
        IO.puts char
        case char do
            '\\' -> escape(tail, ['\\\\' | res])
            #'\'' -> escape(tail, ['\\\'' | res])
            39   -> escape(tail, ['\\\'' | res])
            '"' -> escape(tail,  ['\\"' | res])
            '\n' -> escape(tail, ['\\\\n' | res])
            '\r' -> escape(tail, ['\\\\r' | res])
            char -> escape(tail, [char | res])
        end
    end


    defp query_val(k) when is_binary(k), do: "'#{escape(k)}'"
    defp query_val(k) when is_integer(k), do: "#{k}"
    defp query_val(k) when is_float(k), do: "#{k}"
    defp query_val(k) when is_list(k) do
        k = k |> Enum.map(&query_val/1) |> Enum.join(", ")
        "[#{k}]"
    end


    defp query_keys([], res), do: res |> query([])
    defp query_keys([{key, val}|tail], res) when is_atom(key), do: query_keys([{Atom.to_string(key), val}|tail], res)
    defp query_keys([{key, val}|tail], res) do
        case String.split(key, "__") do
            [key, "eq"] -> query_keys(tail, [{key,"=", query_val(val)}|res])
            [key, "lt"] -> query_keys(tail, [{key,"<", query_val(val)}|res])
            [key, "gt"] -> query_keys(tail, [{key,">", query_val(val)}|res])
            [key, "gte"] -> query_keys(tail, [{key,">=", query_val(val)}|res])
            [key, "lte"] -> query_keys(tail, [{key," <= ", query_val(val)}|res])
            [key, "like"] -> query_keys(tail, [{key,"like", query_val(val)}|res])
            [key, "in"] -> query_keys(tail, [{key,"in", query_val(val)}|res])
            [key] -> query_keys(tail, [{key,"=", query_val(val)}|res])
            err -> raise "Key #{err} very bad!"
        end
    end

    def query_keys([]), do: []
    def query_keys(args) when is_map(args), do: query_keys(Map.to_list(args))
    def query_keys(args = [{key, val}|_]), do: query_keys(args, [])


    defp query([], res), do: res |> Enum.join(" AND ")
    defp query([{key, operator, val}|tail], res) do
        query(tail, ["#{key} #{operator} #{val}" | res]) 
    end

end