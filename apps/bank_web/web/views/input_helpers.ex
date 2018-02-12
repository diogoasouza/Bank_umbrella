defmodule BankWeb.InputHelpers do
  use Phoenix.HTML

  @moduledoc """
  This is the InputHelpers module.
  It contains is used on the Transfers split page to create the 'array_input' element
  """

  def array_input(form, field, type) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    id = Phoenix.HTML.Form.input_id(form, field)

    content_tag :ol,
      id: container_id(id),
      class: "input_container",
      data: [index: Enum.count(values)] do
      values
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        new_id = id <> "_#{index}"

        input_opts = [
          name: new_field_name(form, field),
          value: value,
          id: new_id,
          class: "form-control"
        ]

        form_elements(form, field, value, index, type)
      end)
    end
  end

  defp form_elements(form, field, value, index, type) do
    id = Phoenix.HTML.Form.input_id(form, field)
    new_id = id <> "_#{index}"

    input_opts = [
      name: new_field_name(form, field),
      value: value,
      id: new_id,
      class: "form-control",
      required: "required"
    ]

    content_tag :li do
      [
        apply(Phoenix.HTML.Form, type, [form, field, input_opts]),
        link("Remove", to: "#", data: [id: new_id], title: "Remove", class: "remove-form-field")
      ]
    end
  end

  defp container_id(id), do: id <> "_container"

  defp new_field_name(form, field) do
    Phoenix.HTML.Form.input_name(form, field) <> "[]"
  end

  def array_add_button(form, field, type) do
    id = Phoenix.HTML.Form.input_id(form, field)

    content =
      form_elements(form, field, "", "__name__", type)
      |> safe_to_string

    data = [
      prototype: content,
      container: container_id(id)
    ]

    link("Add", to: "#", data: data, class: "add-form-field")
  end
end
