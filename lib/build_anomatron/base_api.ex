defmodule BuildAnomatron.BaseApi do

  @jenkins_credentials Application.get_env(:build_anomatron, :jenkins_credentials)
  @base_url @jenkins_credentials[:url]
  @content_header [{"Content-type", "application/json"}]

  @type resp :: map()
  @type body :: map()
  @type path :: String.t
  @type options :: list()
  @type success_map :: {:ok, map()}
  @type error_map :: {:error, msg: String.t}

  defp encode_token() do
    Base.encode64("#{@jenkins_credentials[:username]}:#{@jenkins_credentials[:token]}")
  end

  defp headers() do
    auth_header = [{"Authorization", "Basic #{encode_token()}"}]
    (@content_header ++ auth_header)
  end

  @spec get_json(path, options) :: success_map | error_map
  def get_json(path, options \\ []) do
    HTTPoison.get(path, headers(), options)
    |> handle_reponse
  end

  def get_log(path, options \\ []) do
    HTTPoison.get(path, headers(), options)
  end

  @spec post_json(path, body) :: success_map | error_map
  def post_json(path, body) do
    path
    |> HTTPoison.post(Jason.encode!(body), headers())
    |> handle_reponse
  end
  
  @spec handle_reponse(resp) :: success_map | error_map
  defp handle_reponse(resp) do
    case resp do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode(body) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, msg: 'Not Found'}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, msg: reason}
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:ok, msg: body }
    end
  end

end
