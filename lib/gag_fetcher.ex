defmodule GagFetcher do
  def get_content() do
    HTTPoison.start
    response = HTTPoison.get! "http://9gag.com"
    articles = Floki.find(response.body, "article")
    |> Floki.attribute("data-entry-id")
    # |> Enum.take(1)
    |> Enum.map(fn id -> 
      # IO.inspect "#love-count-" <> id izvadit uz ekrana
      {points, _} =  Floki.find(response.body, "#love-count-" <> id) 
      |> Floki.text
      |> String.replace(",",".")
      |> Float.parse
      
      {comments, _} = Floki.find(response.body, ".comment.badge-evt[data-entry-id=" <> id <> "]")
      |> hd
      |> Floki.text
      |> Integer.parse   

      %Gag{id: id, points: points, comments: comments}  
    end)

    
    # nil
 
    # |> length # returns number of lists
    # %Gag{id: 5}
  end
  def to_gag({_, attributes, children}) do
    hd attributes
    #  Map.get(attributes, "data-entry-id")
  end
end

