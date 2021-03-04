defmodule Rocketpay.Users.CreateTest do

  alias Rocketpay.Repo
  alias Rocketpay.User
  alias Rocketpay.Users.Create

  use Rocketpay.DataCase, async: true

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Rafael",
        password: "password",
        nickname: "rafaelTest",
        email: "galani.rafael@gmail.com",
        age: 23,
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Rafael", age: 23, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Rafael",
        nickname: "rafaelTest",
        email: "galani.rafael@gmail.com",
        age: 10,
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
