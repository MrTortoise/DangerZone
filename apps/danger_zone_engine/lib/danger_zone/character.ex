defmodule DangerZoneEngine.Character do
  alias __MODULE__

  @number_of_skills 3
  @enforce_keys [:name, :skills]

  defstruct [:name, :skills]

  def new(name, skills)
      when is_list(skills) and length(skills) == @number_of_skills do
    {:ok, %Character{name: name, skills: skills}}
  end

  def new(_, _), do: {:error, :incorrect_skill}
end
