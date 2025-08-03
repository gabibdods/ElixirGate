defmodule ElixirgateTest do
  use ExUnit.Case
  doctest Elixirgate

  test "greets the world" do
    assert Elixirgate.hello() == :world
  end
end
