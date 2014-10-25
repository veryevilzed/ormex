import Ormex

defmodel AAA do
    deffield Name, default: "zed", datatype: :text
    deffield Level, datatype: :int
end