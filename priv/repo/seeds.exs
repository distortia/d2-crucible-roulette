alias D2CrucibleRoulette.Strats

NimbleCSV.define(Parser, separator: ",", escape: "\"")

(File.cwd!() <> "/strats.csv")
|> File.stream!()
|> Parser.parse_stream()
|> Stream.map(fn [name, description, author] ->
  %{
    name: :binary.copy(name),
    description: :binary.copy(description),
    author: :binary.copy(author)
  }
end)
|> Stream.each(&Strats.add(&1))
|> Stream.run()
