defmodule DangerZoneTest do
  use ExUnit.Case
  doctest DangerZoneEngine

  test "greets the world" do
    assert DangerZoneEngine.hello() == :world
  end
end
