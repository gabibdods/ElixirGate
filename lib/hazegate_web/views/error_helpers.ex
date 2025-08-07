defmodule HazegateWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  # Bring in the HTML Helpers needed
  import Phoenix.HTML.Form
  use PhoenixHTMLHelpers

  @doc """
  Generates tags for inlined form input errors.
  """

  def error_tag(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn {msg, opts} ->
      content_tag(:span, translate_error({msg, opts}),
        class: "error-tag",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  @doc """
  Translates an error message using Gettext.
  """

  def translate_error({msg, opts}) do
    # change this too
    if count = opts[:count] do
      Gettext.dngettext(HazegateWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(HazegateWeb.Gettext, "errors", msg, opts)
    end
  end
end
