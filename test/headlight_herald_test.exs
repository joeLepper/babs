defmodule HeadlightHeraldTest do
  use ExUnit.Case

  test "persist a single article" do
    article = HeadlightHerald.list()
      |> List.first()
      |> HeadlightHerald.get

    HeadlightHerald.persist_article({article, 0}, "articles")

    {:ok, file} = File.read("articles/0.txt")
    assert file == article
  end

  test "get all of Bab's articles" do
    {:ok, chain} =  HeadlightHerald.all()
                    |> Enum.join(" ")
                    |> String.downcase
                    |> Faust.generate_chain(3)

    Faust.traverse(chain, 100)
    |> IO.inspect
  end
end
