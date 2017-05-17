defmodule HeadlightHerald do
  @endpoint "https://www.tillamookheadlightherald.com"

  def all,
    do: list()
        |> Task.async_stream(HeadlightHerald, :get, [], [max_concurrency: 8, timeout: 20_000])
        |> Enum.to_list
        |> Enum.map(&unpack/1)
        |> Enum.filter(&filter/1)

  def list,
    do: HTTPoison.get!("#{@endpoint}/search/?a=91949040-af54-11e5-bf82-f35c68f27803&s=start_time&sd=desc&app%5B0%5D=editorial&o=0&l=100").body
        |> Floki.find("article")
        |> Floki.find(".card-headline")
        |> Floki.find("a")
        |> Floki.attribute("href")

  def persist_article({article, idx}, dir) do
    {:ok, file} = File.open("#{dir}/#{idx}.txt", [:write, :utf8])
    IO.write(file, article)
    File.close(file)
    article
  end

  def get(article_url),
    do: HTTPoison.get("#{@endpoint}#{article_url}")
        |> process(article_url)

  def process({:ok, %{body: body}=_response}, article_url) do
    article = Floki.find(body, ".subscriber-premium")
      |> Floki.find("div p")
      |> Floki.text
    %{ url: article_url, article: article }
  end
  def process(_, article_url), do: %{ url: article_url, article: "" }

  defp unpack({:ok, text}), do: text

  defp filter(%{ url: article_url, article: "" }), do: false
  defp filter(_), do: true
end
