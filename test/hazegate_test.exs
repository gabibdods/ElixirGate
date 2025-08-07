defmodule HazegateTest do
  use ExUnit.Case
  doctest Hazegate

  test "greets the world" do
    assert Hazegate.hello() == :world
  end
end
