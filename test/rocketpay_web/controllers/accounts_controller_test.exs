defmodule RocketpayWeb.AccountsControllerTest do
  alias Rocketpay.{Account, User}
  use RocketpayWeb.ConnCase, async: true

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rafael",
        password: "password",
        nickname: "rafaelTest",
        email: "galani.rafael@gmail.com",
        age: 23,
      }

      {:ok, %User{id: user_id, account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic cmFmYWVsOnBhc3N3b3Jk")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, deposit", %{conn: conn, account_id: account_id} do
      params = %{
        value: "50.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{"account" => %{"balance" => "50.00", "id" => _id}, "message" => "Balance changed successfully."} = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{
        value: "invalid value"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid value. Please use decimal values only."} == response
    end
  end
end
