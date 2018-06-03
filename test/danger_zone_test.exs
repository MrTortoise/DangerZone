defmodule DangerZoneTest do
  use ExUnit.Case
  doctest DangerZone

  test "greets the world" do
    assert DangerZone.hello() == :world
  end
end
